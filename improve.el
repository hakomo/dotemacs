
(defun save-all-buffers-kill-emacs ()
  (interactive)
  (save-some-buffers 4)
  (kill-emacs))

(defun upcase-backward-word (p)
  "Convert previous word (or arg words) to upper case."
  (interactive "p")
  (upcase-word (- p)))

;; (defun f-i ()
;;   (interactive)
;;   (message "%d" (following-char)))

;; (defun upcase-backward-word (p)

;;   (interactive "p")
;; (let ((p (point)))
;;   (save-excursion
;;     (forward-word -1)
;;     (while (= (preceding-char) 95)
;;       (forward-word -1))
;;     (upcase-region (point) p)))

;; (upcase-region

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
