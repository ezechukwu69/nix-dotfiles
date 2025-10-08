;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Aporetic Sans Mono" :size 14 :weight 'bold)
      doom-variable-pitch-font (font-spec :family "Aporetic Sans Mono" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;; accept completion from copilot and fallback to company
;;
;; (map!
;;  :nv "g r a" #'eglot-code-actions
;;  :nv "g r n" #'eglot-rename
;;  :nv "g r r" #'xref-find-references
;;  :nv "g r i" #'eglot-find-implementation
;;  :nv "g r t" #'eglot-find-typeDefinition
;;  :nv "g r D" #'eglot-show-call-hierarchy
;;  :nv "g r T" #'eglot-show-type-hierarchy)

(setq consult-imenu-config
      '((prog-mode :toplevel "Class" "Function" "Method" "Interface" "Struct" "Enum" "Type" "Component" "Trait" "Impl" "Module")))

(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("M-l" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word))
  :config
  (add-to-list 'copilot-indentation-alist '(prog-mode 2))
  (add-to-list 'copilot-indentation-alist '(org-mode 2))
  (add-to-list 'copilot-indentation-alist '(text-mode 2))
  (add-to-list 'copilot-indentation-alist '(closure-mode 2))
  (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2)))

(use-package! eldoc-box
  :bind (:map prog-mode-map
              ("C-c u" . eldoc-box-scroll-down)
              ("C-c d" . eldoc-box-scroll-up)
              ("C-c C-u" . eldoc-box-scroll-down)
              ("C-c C-d" . eldoc-box-scroll-up)
              ("M-h" . eldoc-box-help-at-point))
  :config
  ;; (add-hook 'eglot-managed-mode-hook #'eldoc-box-hover-mode t)
  ;; (add-hook 'prog-mode-hook #'eldoc-box-hover-mode t)
  (add-hook 'eldoc-box-buffer-setup-hook #'eldoc-box-prettify-ts-errors 0 t))

(use-package! buffer-box)

(use-package! vue-mode
  :mode ("\\.vue\\'" . vue-mode)
  :config
  (setq vue-html-tab-width 2)
  (setq vue-html-extra-indent 0)
  (setq vue-html-color-interpolations t))

;; (use-package! web-mode)
(use-package! emmet-mode
  :hook ((vue-mode . emmet-mode)))

;; (use-package! nano-modeline
;;   :config
;;   (add-hook 'prog-mode-hook            #'nano-modeline-prog-mode)
;;   (add-hook 'text-mode-hook            #'nano-modeline-text-mode)
;;   (add-hook 'org-mode-hook             #'nano-modeline-org-mode)
;;   (add-hook 'pdf-view-mode-hook        #'nano-modeline-pdf-mode)
;;   (add-hook 'mu4e-headers-mode-hook    #'nano-modeline-mu4e-headers-mode)
;;   (add-hook 'mu4e-view-mode-hook       #'nano-modeline-mu4e-message-mode)
;;   (add-hook 'elfeed-show-mode-hook     #'nano-modeline-elfeed-entry-mode)
;;   (add-hook 'elfeed-search-mode-hook   #'nano-modeline-elfeed-search-mode)
;;   (add-hook 'term-mode-hook            #'nano-modeline-term-mode)
;;   (add-hook 'xwidget-webkit-mode-hook  #'nano-modeline-xwidget-mode)
;;   (add-hook 'messages-buffer-mode-hook #'nano-modeline-message-mode)
;;   (add-hook 'org-capture-mode-hook     #'nano-modeline-org-capture-mode)
;;   (add-hook 'org-agenda-mode-hook      #'nano-modeline-org-agenda-mode)
;;   (nano-modeline-text-mode 1))
(use-package! vue-ts-mode
  :mode ("\\.vue\\'" . vue-ts-mode))

;; make sure you're using one of the vue-ts-mode or web-mode and change the `vue-ts-mode` to something else

(use-package! spacious-padding
  :if (display-graphic-p)
  :config
  (setq spacious-padding-widths
        '(
          :internal-border-width 2
          ;;:header-line-width 4
          :mode-line-width 5
          :tab-width 2
          :right-divider-width 10
          ;;:scroll-bar-width 8
          ;;:fringe-width 1
          ))

  (setq spacious-padding-subtle-frame-lines
        `( :mode-line-active "#FFFFFF"
           ;;:mode-line-inactive vertical-border))
           :mode-line-inactive "#808080"))

  (spacious-padding-mode 1)

  ;; Set a key binding if you need to toggle spacious padding.
  (define-key global-map (kbd "<f8>") #'spacious-padding-mode))

(add-load-path! "lisp")
(require 'ez-flutter)

;; Your tree-sitter Dart setup code here
(after! treesit 
  (setq treesit-language-source-alist
        (assq-delete-all 'dart treesit-language-source-alist))

  (setq treesit-language-source-alist
        (append treesit-language-source-alist
                '((dart "https://github.com/UserNobody14/tree-sitter-dart"))))
  )

(after! ace-window
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (custom-set-faces!
    '(aw-leading-char-face
      :foreground "white" :background "red"
      :weight bold :height 2.2 :box (:line-width 3 :color "red"))))


(after! eglot
  ;; Remove legacy tsserver if desired
  (setq eglot-server-programs
        (seq-remove (lambda (entry)
                      (let ((modes (if (listp (car entry)) (car entry) (list (car entry)))))
                        (seq-some (lambda (mode)
                                    (let ((mode-name (if (listp mode) (car mode) mode)))
                                      (memq mode-name '(
                                                        js-mode
                                                        js-ts-mode
                                                        tsx-mode
                                                        tsx-ts-mode
                                                        ;; ruby-ts-mode
                                                        ;; ruby-mode
                                                        typescript-mode
                                                        typescript-ts-mode))))
                                  modes)))
                    eglot-server-programs))

  (add-hook 'vue-ts-mode-hook 'lsp)

  ;; (add-to-list 'eglot-server-programs
  ;;              '(((ruby-mode :language-id "ruby")
  ;;                 (ruby-ts-mode :language-id "ruby")
  ;;                 ))
  ;;              "ruby-lsp")

  (add-to-list 'eglot-server-programs
               '(((js-mode :language-id "javascript")
                  (js-ts-mode :language-id "javascript")
                                        ; (vue-ts-mode :language-id "vue")
                  (tsx-ts-mode :language-id "typescriptreact")
                  (typescript-ts-mode :language-id "typescript")
                  (typescript-mode :language-id "typescript"))
                 "vtsls" "--stdio"))

  ;; Your workspace configuration (place this after the server configuration)
  (setq-default eglot-workspace-configuration
                '((vtsls
                   . ((completeFunctionCalls . t)
                      (typescript . ((updateImportsOnFileMove . ((enabled . "always")))
                                     (suggest . ((completeFunctionCalls . t)))
                                     (inlayHints . ((parameterNames . ((enabled . "literals")
                                                                       (suppressWhenArgumentMatchesName . nil)))
                                                    (parameterTypes . ((enabled . t)))
                                                    (variableTypes . ((enabled . nil)))
                                                    (propertyDeclarationTypes . ((enabled . t)))
                                                    (functionLikeReturnTypes . ((enabled . t)))
                                                    (enumMemberValues . ((enabled . t)))))
                                     (format . ((insertSpaceAfterCommaDelimiter . t)
                                                (insertSpaceAfterConstructor . t)
                                                (insertSpaceAfterSemicolonInForStatements . t)
                                                (insertSpaceBeforeAndAfterBinaryOperators . t)
                                                (insertSpaceAfterKeywordsInControlFlowStatements . t)
                                                (insertSpaceAfterFunctionKeywordForAnonymousFunctions . t)
                                                (insertSpaceBeforeFunctionParenthesis . nil)
                                                (insertSpaceAfterOpeningAndBeforeClosingNonemptyParentheses . nil)
                                                (insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets . nil)
                                                (insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces . nil)
                                                (placeOpenBraceOnNewLineForFunctions . nil)
                                                (placeOpenBraceOnNewLineForControlBlocks . nil)
                                                (indentSize . 4)
                                                (tabSize . 4)
                                                (convertTabsToSpaces . t)))
                                     (preferences . ((indentSize . 4)
                                                     (tabSize . 4)
                                                     (convertTabsToSpaces . t)
                                                     (insertSpaceAfterCommaDelimiter . t)
                                                     (insertSpaceAfterSemicolonInForStatements . t)
                                                     (insertSpaceBeforeAndAfterBinaryOperators . t)
                                                     (insertSpaceAfterKeywordsInControlFlowStatements . t))))))))
                )

  (add-to-list 'eglot-server-programs
               `(vue-ts-mode . ("lspx" "--lsp" "vue-language-server --stdio" "--lsp" "vtsls --stdio" :initializationOptions `(:vtsls
                                                                                                                              (:tsserver
                                                                                                                               (:globalPlugins (:name "@vue/typescript-plugin"
                                                                                                                                                :location (string-trim-right (shell-command-to-string "npm list -g --parseable @vue/language-server | head -n1"))
                                                                                                                                                :languages ("vue")
                                                                                                                                                :configNamespace "typescript")))))))
  
  (add-hook 'js-mode-hook 'eglot-ensure)
  (add-hook 'js-ts-mode-hook 'eglot-ensure)
  (add-hook 'tsx-mode-hook 'eglot-ensure)
  (add-hook 'tsx-ts-mode-hook 'eglot-ensure)
  (add-hook 'typescript-mode-hook 'eglot-ensure)
  (add-hook 'typescript-ts-mode-hook 'eglot-ensure))

(setq epg-pinentry-mode 'loopback)

(map!
 :nvi "C-e" #'end-of-line
 :nvi "C-a" #'beginning-of-line
 :nvi (kbd "C-SPC") #'set-mark-command)

(completion-preview-mode 1)
(global-set-key (kbd "C-x _") 'maximize-window)
(map!
 :after corfu
 :map corfu-map
 "C-n" #'corfu-next
 "C-p" #'corfu-previous)

;; (global-set-key emacs-lisp-mode (kbd "C-x _") 'maximize-window)

(after! org
  (setq org-M-RET-may-split-line '((default . nil)))
  (setq org-insert-heading-respect-content t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-todo-keywords '(
                            (sequence "TODO(t!)" "PROJ(p)" "LOOP(r)" "STRT(s)" "WAIT(w!)" "HOLD(h!)" "IDEA(i!)"
                                      "|" "DONE(d!)" "KILL(k!)")
                            (sequence "[ ](T!)" "[-](S!)" "[?](W!)" "|" "[X](D!)")
                            (sequence "|" "OKAY(o)" "YES(y)" "NO(n)"))))

(repeat-mode 1)
(when (getenv "WAYLAND_DISPLAY")
  (setq interprogram-cut-function
        (lambda (text)
          (with-temp-buffer
            (insert text)
            (call-process-region (point-min) (point-max) "wl-copy" nil nil nil "-f" "-n"))))
  (setq interprogram-paste-function
        (lambda ()
          (shell-command-to-string "wl-paste -n | tr -d '\\r'"))))

(setq lsp-disabled-clients '(rubocop-ls))
(after! corfu
  (setq corfu-preselect 'first)
  (map! :map corfu-map
        "<escape>" #'corfu-quit)
  )

(defun mark-line ()
  "Mark the current line."
  (interactive)
  (beginning-of-line)
  (set-mark (point))
  (end-of-line))

(defun mark-line-rev ()
  "Mark the current line. in reverse"
  (interactive)
  (end-of-line)
  (set-mark (point))
  (beginning-of-line))

(map!
 :desc "Mark line"
 "M-o" #'mark-line
 "M-O" #'mark-line-rev)

(map!
 :map evil-normal-state-map
 "U" #'evil-redo
 "C-r" #'isearch-backward)
