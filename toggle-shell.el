
(defvar before-window)

(defun make-shell ()
  (cond
   ((and (not (eq (selected-window) (next-window)))
         (= (car (window-edges)) 0))
    (other-window 1)
    (split-window-vertically 21)
    (shell)
    nil)
   (t
    (split-window-vertically 21)
    (shell)
    t)))

(defun toggle-shell ()
  (interactive)
  (let ((w (get-buffer-window "*shell*")) (p t))
    (cond
     (w
      (when (not (eq w (selected-window)))
        (setq before-window (selected-window)))
      (delete-window w)
      (select-window before-window))
     (t
      (setq before-window (selected-window))
      (when (make-shell)
        (setq before-window (next-window)))))))

(provide 'toggle-shell)
