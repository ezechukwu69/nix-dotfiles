(let* ((org-file (expand-file-name "config.org" user-emacs-directory))
       (el-file "~/.cache/emacs/config.el"))
  ;; Ensure cache directory exists
  (make-directory (file-name-directory el-file) t)
  
  ;; Tangle if needed (org newer than el, or el doesn't exist)
  (when (or (not (file-exists-p el-file))
            (file-newer-than-file-p org-file el-file))
    (org-babel-tangle-file org-file))
  
  ;; Load the tangled file from cache directory
  (load el-file))

;;(org-babel-load-file (expand-file-name "config.org" user-emacs-directory))
(put 'downcase-region 'disabled nil)
