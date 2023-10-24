(package-initialize)
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

;; ===================================================================
;; BACKUP FILES (see https://www.emacswiki.org/emacs/BackupDirectory)
;; ===================================================================
;; NOTE: `temporary-file-directory' on linux is: `/tmp'
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; (message "Deleting old backup files...")
;; (let ((week (* 60 60 24 7))
;;       (current (float-time (current-time))))
;;   (dolist (file (directory-files temporary-file-directory t))
;;     (when (and (backup-file-name-p file)
;;                (> (- current (float-time (fifth (file-attributes file))))
;;                   week))
;;       (message "%s" file)
;;       (delete-file file))))


; YAML Mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))

;; ===================================================================
;; DISABLE CTRL-Z MINIMIZATION/SUSPENSION OF EMACS ===================
;; ===================================================================
(global-set-key [(control z)] nil)

;; ===================================================================
;; ANSWER Y INSTEAD OF YES ON PROMPTS ================================
;; ===================================================================
(defalias 'yes-or-no-p 'y-or-n-p)

;; ===================================================================
;; COMMENT REGION ====================================================
;; ===================================================================
(global-set-key (kbd "C-M-;") 'comment-or-uncomment-region)

;; ===================================================================
;; FRAME TITLE =======================================================
;; ===================================================================
;; Display complete path + filename in title (ie
;; ~/dirA/dirB/fileX.txt)
(setq frame-title-format
      '("%S" (buffer-file-name "%f"
			       (dired-directory dired-directory "%b"))))

;; ===================================================================
;; TAB-WIDTH =========================================================
;; ===================================================================
(setq-default tab-width 4)

;; ===================================================================
;; SKELETON PAIR MODE ================================================
;; ===================================================================
(setq skeleton-pair t)
(global-set-key "(" 'skeleton-pair-insert-maybe)
(global-set-key "[" 'skeleton-pair-insert-maybe)
(global-set-key "\"" 'skeleton-pair-insert-maybe)
(global-set-key "{" 'skeleton-pair-insert-maybe)

;; ===================================================================
;; SCRATCH BUFFER ====================================================
;; ===================================================================
;(setq initial-major-mode 'org-mode)
(setq initial-scratch-message "")

;; ===================================================================
;; Wayland: paste from clipboard =====================================
;; ===================================================================
;; https://www.emacswiki.org/emacs/CopyAndPaste#h5o-4
;;
;; credit: yorickvP on Github
(setq wl-copy-process nil)
(defun wl-copy (text)
  (setq wl-copy-process (make-process :name "wl-copy"
                                      :buffer nil
                                      :command
                                      '("wl-copy"
                                        "-f" "-n")
                                      :connection-type
                                      'pipe))
  (process-send-string wl-copy-process text)
  (process-send-eof wl-copy-process))
(defun wl-paste ()
  (if (and wl-copy-process (process-live-p wl-copy-process))
      nil ; should return nil if we're the current paste owner
    (shell-command-to-string "wl-paste -n | tr -d \r")))
(setq interprogram-cut-function 'wl-copy)
(setq interprogram-paste-function 'wl-paste)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(calendar-date-style 'european)
 '(column-number-mode t)
 '(custom-enabled-themes '(tango-dark))
 '(desktop-restore-eager 5)
 '(desktop-save-mode t)
 '(display-time-24hr-format t)
 '(display-time-mode t)
 '(fancy-splash-image "nil")
 '(global-auto-revert-mode t)
 '(ido-enable-flex-matching t)
 '(inhibit-startup-buffer-menu t)
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(haskell-mode markdown-mode fsharp-mode i3wm-config-mode csharp-mode ## yaml-mode))
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
