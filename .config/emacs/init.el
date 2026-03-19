;; init.el --- Main initialization -*- lexical-binding: t -*-

;;; Package setup
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;;; Sane defaults
(setq-default
 inhibit-startup-screen t
 ring-bell-function     'ignore          ; no bell
 make-backup-files      nil              ; no foo~ clutter
 auto-save-default      nil
 indent-tabs-mode       nil              ; spaces, not tabs
 fill-column            80)

(setq scroll-conservatively 101)         ; smooth scrolling
(delete-selection-mode 1)                ; typing replaces selection
(global-auto-revert-mode 1)              ; reload files changed on disk
(savehist-mode 1)                        ; persist minibuffer history
(recentf-mode 1)                         ; track recent files

;;; Theme — detect light/dark from KITTY_THEME env var
(defun my/apply-theme ()
  (let ((theme (getenv "KITTY_THEME")))
    (if (string-equal theme "LIGHT")
        (progn (setq frame-background-mode 'light)
               (load-theme 'modus-operandi t))
      (progn (setq frame-background-mode 'dark)
             (load-theme 'modus-vivendi t)))))

(my/apply-theme)

;;; Re-apply theme for new frames (needed when running as daemon)
(add-hook 'after-make-frame-functions
          (lambda (frame)
            (with-selected-frame frame
              (my/apply-theme))))

;;; Line numbers in programming modes
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;;; Completion — the modern "minad stack"
(use-package vertico
  :init (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :init (marginalia-mode))

(use-package consult
  :bind (("C-x b"   . consult-buffer)
         ("C-x r b" . consult-bookmark)
         ("M-y"     . consult-yank-pop)
         ("M-s r"   . consult-ripgrep)
         ("M-s l"   . consult-line)))

(use-package embark
  :bind (("C-." . embark-act)
         ("M-." . embark-dwim)))

(use-package embark-consult
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;;; Git
(use-package magit
  :bind ("C-x g" . magit-status))

;;; LSP (built-in eglot, activate per language as needed)
;; (add-hook 'python-mode-hook #'eglot-ensure)
;; (add-hook 'c-mode-hook      #'eglot-ensure)

;;; Persist cursor position
(save-place-mode 1)

;;; Keep customizations out of this file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;;; init.el ends here
