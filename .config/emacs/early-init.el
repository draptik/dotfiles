;; early-init.el --- Early initialization -*- lexical-binding: t -*-
;; Loaded before package system and UI initialization.

;;; Performance
(setq gc-cons-threshold (* 50 1000 1000))   ; increase GC threshold during startup
(setq package-enable-at-startup nil)         ; we call package-initialize manually

;;; Suppress UI chrome before it renders (avoids flicker)
(push '(menu-bar-lines . 0)       default-frame-alist)
(push '(tool-bar-lines . 0)       default-frame-alist)
(push '(vertical-scroll-bars)     default-frame-alist)

;;; Restore GC threshold after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1000 1000))))

;;; early-init.el ends here
