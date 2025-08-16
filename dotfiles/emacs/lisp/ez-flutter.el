;;; ez-flutter.el --- Interactive Flutter commands with dape integration -*- lexical-binding: t; -*-

;; Author: Your Name
;; Version: 1.0.0
;; Package-Requires: ((emacs "27.1") (dape "0.1"))
;; Keywords: flutter, dart, mobile, development
;; URL: https://github.com/yourusername/ez-flutter

;;; Commentary:

;; This package provides interactive Flutter development commands integrated
;; with dape (Debug Adapter Protocol for Emacs). It includes commands for
;; starting/stopping Flutter apps, hot reload/restart functionality, device
;; management, and automatic hot reload on save.

;;; Code:

(require 'dape)
(require 'project)
(require 'dart-mode nil t)
(require 'apheleia nil t)

(defgroup ez-flutter nil
  "Interactive Flutter commands with dape integration."
  :group 'development
  :prefix "ez-flutter-")

(defcustom ez-flutter-auto-reload-on-save t
  "When non-nil, automatically run hot reload on save in dart-mode."
  :type 'boolean
  :group 'ez-flutter)

(defcustom ez-flutter-dape-config-name "flutter"
  "Name of the dape configuration to use for Flutter debugging."
  :type 'string
  :group 'ez-flutter)

(defvar ez-flutter--dape-process nil
  "Current dape process for Flutter debugging.")

(defvar ez-flutter--devices-cache nil
  "Cached list of Flutter devices.")

(defvar ez-flutter--devices-cache-time nil
  "Time when devices were last cached.")

(defvar ez-flutter--reload-timer nil
  "Timer for delayed hot reload to avoid conflicts with formatters.")



(defconst ez-flutter--cache-duration 30
  "Duration in seconds to cache device list.")

;;; Utility functions

(defun ez-flutter--find-project-root ()
  "Find Flutter project root using project.el, fallback to pubspec.yaml search."
  (or 
   ;; First try project.el
   (when-let ((project (project-current)))
     (let ((root (project-root project)))
       ;; Verify it's actually a Flutter project by checking for pubspec.yaml
       (when (file-exists-p (expand-file-name "pubspec.yaml" root))
         root)))
   ;; Fallback to manual pubspec.yaml search
   (when-let ((dir (locate-dominating-file default-directory "pubspec.yaml")))
     (expand-file-name dir))))

(defun ez-flutter--ensure-project-root ()
  "Ensure we're in a Flutter project, signal error if not."
  (unless (ez-flutter--find-project-root)
    (error "Not in a Flutter project (no pubspec.yaml found in project root or parent directories)")))

(defun ez-flutter--get-dape-process ()
  "Get the current Flutter dape process."
  (or ez-flutter--dape-process
      (error "No active Flutter dape process. Run ez/flutter-start first")))

(defun ez-flutter--send-dap-command (command &optional arguments)
  "Send a DAP custom command to the Flutter dape process."
  (let ((process (ez-flutter--get-dape-process)))
    (dape--with process
                (dape--request process
                               "workspace/executeCommand"
                               (list :command command
                                     :arguments (or arguments []))
                               (lambda (_response)
                                 (message "Flutter command '%s' executed" command))
                               (lambda (error)
                                 (message "Flutter command failed: %s" 
                                          (plist-get error :message)))))))

(defun ez-flutter--parse-devices (output)
  "Parse flutter devices output into a list of (name . id) pairs."
  (let ((devices '())
        (lines (split-string output "\n" t)))
    (dolist (line lines)
      (when (string-match "^\\([^•]+\\)\\s-*•\\s-*\\([^•]+\\)\\s-*•" line)
        (let ((name (string-trim (match-string 1 line)))
              (id (string-trim (match-string 2 line))))
          (unless (string-match-p "No devices" name)
            (push (cons name id) devices)))))
    (nreverse devices)))

(defun ez-flutter--get-devices (&optional force-refresh)
  "Get list of Flutter devices, using cache unless FORCE-REFRESH is t."
  (when (or force-refresh
            (null ez-flutter--devices-cache)
            (null ez-flutter--devices-cache-time)
            (> (float-time (time-subtract (current-time) 
                                          ez-flutter--devices-cache-time))
               ez-flutter--cache-duration))
    (message "Refreshing Flutter devices...")
    (let ((output (shell-command-to-string "flutter devices")))
      (setq ez-flutter--devices-cache (ez-flutter--parse-devices output)
            ez-flutter--devices-cache-time (current-time))))
  ez-flutter--devices-cache)

;;; Interactive commands

;;;###autoload
(defun ez/flutter-start ()
  "Start Flutter debugging session with dape."
  (interactive)
  (ez-flutter--ensure-project-root)
  (let ((default-directory (ez-flutter--find-project-root)))
    (when ez-flutter--dape-process
      (message "Flutter dape process already running")
      (return))
    
    ;; Ensure dape configuration exists
    (unless (assoc ez-flutter-dape-config-name dape-configs)
      (add-to-list 'dape-configs
                   `(,ez-flutter-dape-config-name
                     modes (dart-mode)
                     command "flutter"
                     command-args ("debug_adapter")
                     :type "dart"
                     :name "Flutter Debug"
                     :request "launch"
                     :program "lib/main.dart"
                     :cwd dape-cwd-fn)))
    
    ;; Start dape session
    (dape ez-flutter-dape-config-name)
    
    ;; Store the process reference
    (run-with-timer 1 nil
                    (lambda ()
                      (setq ez-flutter--dape-process
                            (get-buffer-process (dape--repl-buffer)))
                      (message "Flutter dape session started")))))

;;;###autoload
(defun ez/flutter-stop ()
  "Stop the Flutter dape process."
  (interactive)
  (if ez-flutter--dape-process
      (progn
        (when (process-live-p ez-flutter--dape-process)
          (dape-quit ez-flutter--dape-process))
        (setq ez-flutter--dape-process nil)
        (message "Flutter dape process stopped"))
    (message "No Flutter dape process running")))

;;;###autoload
(defun ez/flutter-hot-restart ()
  "Send hot restart command to Flutter dape process."
  (interactive)
  (ez-flutter--send-dap-command "hotRestart"))

;;;###autoload
(defun ez/flutter-hot-reload ()
  "Send hot reload command to Flutter dape process."
  (interactive)
  (ez-flutter--send-dap-command "hotReload"))

;;;###autoload
(defun ez/flutter-devices ()
  "List Flutter devices and launch selected emulator."
  (interactive)
  (let* ((devices (ez-flutter--get-devices))
         (device-names (mapcar #'car devices))
         (selected-name (completing-read "Select device: " device-names nil t)))
    (when selected-name
      (let* ((device-id (cdr (assoc selected-name devices)))
             (command (format "flutter emulators --launch %s" device-id)))
        (message "Launching device: %s" selected-name)
        (async-shell-command command "*Flutter Device Launch*")))))

;;; Auto-reload on save

(defun ez-flutter--auto-reload ()
  "Automatically run hot reload if enabled and in a Flutter project.
Uses a timer to avoid conflicts with formatters like apheleia."
  (when (and ez-flutter-auto-reload-on-save
             (ez-flutter--find-project-root)
             ez-flutter--dape-process
             (process-live-p ez-flutter--dape-process))
    
    ;; Cancel any existing timer
    (when ez-flutter--reload-timer
      (cancel-timer ez-flutter--reload-timer))
    
    ;; Set a new timer to delay the reload
    (setq ez-flutter--reload-timer
          (run-with-timer ez-flutter-reload-delay nil
                          (lambda ()
                            (setq ez-flutter--reload-timer nil)
                            ;; Check if buffer is still modified (formatter might still be running)
                            (unless (buffer-modified-p)
                              (ez/flutter-hot-reload)))))))

;;;###autoload
(defun ez-flutter-enable-auto-reload ()
  "Enable automatic hot reload on save for dart-mode."
  (interactive)
  (add-hook 'dart-mode-hook
            (lambda ()
              (add-hook 'after-save-hook #'ez-flutter--auto-reload nil t)))
  (setq ez-flutter-auto-reload-on-save t)
  (message "Flutter auto-reload on save enabled"))

;;;###autoload
(defun ez-flutter-disable-auto-reload ()
  "Disable automatic hot reload on save for dart-mode."
  (interactive)
  (remove-hook 'dart-mode-hook
               (lambda ()
                 (add-hook 'after-save-hook #'ez-flutter--auto-reload nil t)))
  (setq ez-flutter-auto-reload-on-save nil)
  (message "Flutter auto-reload on save disabled"))

;;; Minor mode for better integration

(defvar ez-flutter-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c f s") #'ez/flutter-start)
    (define-key map (kbd "C-c f q") #'ez/flutter-stop)
    (define-key map (kbd "C-c f r") #'ez/flutter-hot-restart)
    (define-key map (kbd "C-c f l") #'ez/flutter-hot-reload)
    (define-key map (kbd "C-c f d") #'ez/flutter-devices)
    map)
  "Keymap for ez-flutter-mode.")

;;;###autoload
(define-minor-mode ez-flutter-mode
  "Minor mode for Flutter development with enhanced commands."
  :lighter " Flutter"
  :keymap ez-flutter-mode-map
  :group 'ez-flutter
  (if ez-flutter-mode
      (progn
        (when ez-flutter-auto-reload-on-save
          (add-hook 'after-save-hook #'ez-flutter--auto-reload nil t))
        (message "ez-flutter-mode enabled"))
    (remove-hook 'after-save-hook #'ez-flutter--auto-reload t)
    (message "ez-flutter-mode disabled")))

;;; Auto-enable in dart-mode

;;;###autoload
(defun ez-flutter-setup ()
  "Set up ez-flutter for dart-mode buffers."
  (when (derived-mode-p 'dart-mode)
    (ez-flutter-mode 1)))

;; Auto-enable in dart-mode buffers
(add-hook 'dart-mode-hook #'ez-flutter-setup)

;;; Integration with dape

(defun ez-flutter--dape-started (process)
  "Hook function called when dape process starts."
  (when (string-match-p "flutter\\|dart" (process-name process))
    (setq ez-flutter--dape-process process)))

(defun ez-flutter--dape-stopped (process)
  "Hook function called when dape process stops."
  (when (eq process ez-flutter--dape-process)
    (setq ez-flutter--dape-process nil)))

;; Add hooks for dape integration
(add-hook 'dape-start-hook #'ez-flutter--dape-started)
(add-hook 'dape-exit-hook #'ez-flutter--dape-stopped)

(provide 'ez-flutter)

;;; ez-flutter.el ends here
