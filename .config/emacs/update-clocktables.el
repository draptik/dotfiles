(require 'org)
(require 'org-clock)

(defun update-org-clocktables (file)
  "Update all dynamic blocks (e.g., clocktable) in FILE."
  (find-file file)
  ;; Move to first heading so org-clock-* functions that expect a heading won't error.
  (goto-char (point-min))
  (when (re-search-forward org-heading-regexp nil t)
    (beginning-of-line)
    (ignore-errors
      (org-clock-remove-empty-clock-drawer)))
  (org-update-all-dblocks)
  (save-buffer)
  (kill-buffer))

(let ((file (car command-line-args-left)))
  (update-org-clocktables file))
