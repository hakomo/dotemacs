
(defun camel-to-snake-backward-word ()
  (interactive)
  (let ((case-fold-search nil)
        (s (buffer-substring
            (point) (save-excursion (forward-word -1) (point)))))
    (delete-region (point) (progn (forward-word -1) (point)))
    (insert (funcall (if (= (string-to-char s) (downcase (string-to-char s)))
                         'downcase 'upcase)
                     (replace-regexp-in-string
                      "\\([A-Z]\\)" "_\\1"
                      (store-substring s 0 (downcase (string-to-char s))))))))

(defun rough-comment (bg ed)
  (interactive (list (point) (mark)))
  (save-excursion
    (if mark-active
        (comment-or-uncomment-region
         (progn (goto-char (if (< bg ed) bg ed)) (beginning-of-line) (point))
         (progn (goto-char (if (< bg ed) ed bg)) (end-of-line) (point)))
      (comment-or-uncomment-region (progn (beginning-of-line) (point))
                                   (progn (end-of-line) (point))))))

(defun back-to-indentation-or-beginning-of-line ()
  (interactive)
  (when (eq (point) (progn (back-to-indentation) (point)))
    (beginning-of-line)))

(defun kill-whole-line-or-region (bg ed)
  (interactive (list (point) (mark)))
  (if mark-active (kill-region bg ed) (kill-whole-line)))

(defun kill-ring-save-whole-line-or-region (bg ed)
  (interactive (list (point) (mark)))
  (if mark-active
      (kill-ring-save bg ed)
    (save-excursion
      (kill-ring-save (progn (beginning-of-line) (point))
                      (progn (end-of-line) (point))))))

(defun delete-region-and-yank (bg ed)
  (interactive (list (point) (mark)))
  (when mark-active (delete-region bg ed))
  (yank))
