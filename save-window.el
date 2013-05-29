
(require 'toggle-shell)

(defvar sw-edge)
(defvar l-buffer "*scratch*")
(defvar r-buffer "*scratch*")

(defun save-window ()
  (when (get-buffer-window "*shell*")
    (toggle-shell))
  (setq sw-edge (car (window-edges)))
  (if (= sw-edge 0)
      (setq l-buffer (window-buffer))
    (setq r-buffer (window-buffer)))
  (if (= (car (window-edges (next-window))) 0)
      (setq l-buffer (window-buffer (next-window)))
    (setq r-buffer (window-buffer (next-window)))))

(defun recover-window ()
  (switch-to-buffer (if (= (car (window-edges)) 0) l-buffer r-buffer))
  (other-window 1)
  (switch-to-buffer (if (= (car (window-edges)) 0) l-buffer r-buffer))
  (when (not (= (car (window-edges)) sw-edge))
    (other-window 1)))

(provide 'save-window)
