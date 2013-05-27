
(require 'toggle-shell)

(defvar sw-edges 'l)
(defvar shell-p nil)
(defvar l-buffer "*scratch*")
(defvar r-buffer "*scratch*")

(defun save-window ()
  (setq sw-edges (if (eq (selected-window) (get-buffer-window "*shell*")) 's
                   (if (= (car (window-edges)) 0) 'l 'r))
        shell-p (get-buffer-window "*shell*"))
  (when shell-p
    (delete-window shell-p))
  (if (= (car (window-edges)) 0)
      (setq l-buffer (window-buffer))
    (setq r-buffer (window-buffer)))
  (if (= (car (window-edges (next-window))) 0)
      (setq l-buffer (window-buffer (next-window)))
    (setq r-buffer (window-buffer (next-window)))))

(defun recover-window ()
  (let ((l nil) (r nil) (s nil))
    (switch-to-buffer (if (= (car (window-edges)) 0) l-buffer r-buffer))
    (if (= (car (window-edges)) 0)
        (setq l (selected-window))
      (setq r (selected-window)))
    (other-window 1)
    (switch-to-buffer (if (= (car (window-edges)) 0) l-buffer r-buffer))
    (if (= (car (window-edges)) 0)
        (setq l (selected-window))
      (setq r (selected-window)))
    (when shell-p
      (make-shell)
      (setq s (selected-window)))
    (cond
     ((and (eq sw-edges 's) s))
     ((and (eq sw-edges 'r) r)
      (select-window r))
     (t
      (select-window l)))))

(provide 'save-window)
