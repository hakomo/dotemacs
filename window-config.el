
(require 'moz)

(defvar window-config-mode nil)

(defvar window-config-mode-map
  (let ((map (make-sparse-keymap))
        (key 0))
    (while (< key 256)
      (define-key map (char-to-string key) 'undefined)
      (setq key (+ key 1)))

    (define-key map "q" 'window-config-mode)

    (define-key map "s" 'set-cr-contents-1)
    (define-key map "d" 'set-cr-contents-2)
    (define-key map "f" 'set-cr-contents-3)

    (define-key map "l" 'set-cr-aligned-0)
    (define-key map "c" 'set-cr-aligned-1)
    (define-key map "r" 'set-cr-aligned-2)
    (define-key map "x" 'set-cr-aligned-3)
    (define-key map "v" 'set-cr-aligned-4)

    (define-key map "g" 'toggle-shell-p)
    (define-key map "t" 'set-shell-t-t)
    (define-key map "b" 'set-shell-t-nil)
    map))

(define-minor-mode window-config-mode
  "" :lighter " WC" :keymap window-config-mode-map
  (cond
   (window-config-mode
    (setq window-config-mode t)
    (force-mode-line-update)
    (run-hooks 'window-config-mode-hook))
   (t
    (force-mode-line-update)
    (setq window-config-mode nil))))

(defun set-cr-contents-1 ()
  (interactive)
  (setq cr-contents 1)
  (modify-frame))

(defun set-cr-contents-2 ()
  (interactive)
  (setq cr-contents 2)
  (modify-frame))

(defun set-cr-contents-3 ()
  (interactive)
  (setq cr-contents 3)
  (modify-frame))

(defun set-cr-aligned-0 ()
  (interactive)
  (setq cr-aligned 0)
  (modify-frame))

(defun set-cr-aligned-1 ()
  (interactive)
  (setq cr-aligned 1)
  (modify-frame))

(defun set-cr-aligned-2 ()
  (interactive)
  (setq cr-aligned 2)
  (modify-frame))

(defun set-cr-aligned-3 ()
  (interactive)
  (setq cr-aligned 3)
  (modify-frame))

(defun set-cr-aligned-4 ()
  (interactive)
  (setq cr-aligned 4)
  (modify-frame))

(defun toggle-shell-p ()
  (interactive)
  (setq shell-p (not shell-p))
  (modify-frame))

(defun set-shell-t-t ()
  (interactive)
  (setq shell-t t)
  (modify-frame))

(defun set-shell-t-nil ()
  (interactive)
  (setq shell-t nil)
  (modify-frame))

(defvar desktop-y)
(defvar desktop-h)
(defvar desktop-x)
(defvar desktop-w)
(defvar frame-t)
(defvar frame-b)
(defvar frame-l)
(defvar frame-r)

(load (downcase (concat user-login-name "@" system-name)))

(defvar firefox-w (+ 1030 frame-l frame-r))

(defvar frame-ch (/ (- desktop-h frame-t) (frame-char-height)))
;; (defvar frame-ch (/ (- desktop-h frame-t frame-b) (frame-char-height)))

(defvar frame1-cw 80)
(defvar frame2-cw (+ (* frame1-cw 2) 2))

(defvar frame1-w (+ (* (+ frame1-cw 2) (frame-char-width)) frame-l frame-r))
(defvar frame2-w (+ (* (+ frame2-cw 2) (frame-char-width)) frame-l frame-r))

(defvar frame3-w (+ (- frame1-w frame-r) (max frame-l frame-r)
                    (- firefox-w frame-l frame-r)))
;; (defvar frame3-w (+ frame1-w firefox-w))

(defvar cr-contents)
(defvar cr-aligned)
(defvar shell-p)
(defvar shell-t)

(defvar winconf-list '((2 4 t t) (2 1 t t) (3 3 t t) (3 3 nil nil)))
(defvar frame-id 0)

(defvar main-buf "*scratch*")
(defvar sub-buf "*scratch*")

(defun ltwh-alist (lt tp wd ht)
  `((left . ,(if (= lt -1) -1 (+ desktop-x lt)))
    (top . ,(if (= tp -1) -1 (+ desktop-y tp))) (width . ,wd) (height . ,ht)))

(defun modify-frame-ltwh (lt tp wd ht)
  (if (= wd (frame-width))
      (modify-window)
    (add-hook 'window-configuration-change-hook 'modify-window))
  (modify-frame-parameters nil (ltwh-alist lt tp wd ht)))

(defun modify-frame-lw (lt wd)
  (modify-frame-ltwh lt 0 wd frame-ch))

(defun modify-firefox-ltwh (lt tp wd ht)
  (comint-send-string
   (inferior-moz-process)
   (format "moveTo(%d,%d); resizeTo(%d,%d);"
           (+ desktop-x lt) (+ desktop-y tp) wd ht)))

(defun modify-firefox-lw (lt wd)
  ;; (modify-firefox-ltwh lt (- frame-t) wd (+ desktop-h frame-t frame-b))
  (modify-firefox-ltwh lt 0 wd desktop-h)
  )

(defun toggle-frame ()
  (interactive)
  (let ((l (nth frame-id winconf-list)))
    (setq cr-contents (nth 0 l)
          cr-aligned (nth 1 l)
          shell-p (nth 2 l)
          shell-t (nth 3 l)))
  (modify-frame)
  (setq frame-id (% (+ frame-id 1) 4)))

(defun in-desktop-p ()
  (cond
   ((= cr-contents 1)
    (< frame1-w desktop-w))
   ((= cr-contents 2)
    (< frame2-w desktop-w))
   ((= cr-contents 3)
    (< frame3-w desktop-w))))

(defun mc-in-desktop-p ()
  (cond
   ((= cr-contents 1)
    (< frame1-w desktop-w))
   ((= cr-contents 2)
    (< frame2-w (/ (+ desktop-w frame1-w) 2)))
   ((= cr-contents 3)
    (< frame3-w (/ (+ desktop-w frame1-w) 2)))))

(defun modify-frame ()
  (interactive)
  (save-window)
  (cond
   ((= cr-contents 1)
    (modify-firefox-lw (/ (- desktop-w firefox-w) 2) firefox-w)
    (cond
     ((= cr-aligned 0)
      (modify-frame-lw 0 frame1-cw))
     ((= cr-aligned 2)

      (modify-frame-parameters nil '((left . -1)))

      (modify-frame-lw -1 frame1-cw))
     (t
      (modify-frame-lw (/ (- desktop-w frame1-w) 2) frame1-cw))))

   ((= cr-contents 2)
    (modify-firefox-lw (/ (- desktop-w firefox-w) 2) firefox-w)
    (cond
     ((not (or (in-desktop-p) (= cr-aligned 4)))
      (modify-frame-lw 0 (- (/ (- desktop-w frame-l) (frame-char-width)) 2))
      ;; (modify-frame-lw
      ;; 0 (- (/ (- desktop-w frame-l frame-r) (frame-char-width)) 2))
      )
     ((and (not (mc-in-desktop-p)) (= cr-aligned 4))
      (modify-frame-lw
       (/ (- desktop-w frame1-w) 2)
       (- (/ (- (/ (+ desktop-w frame1-w) 2) frame-l)
             (frame-char-width)) 2)))
      ;; (modify-frame-lw
      ;;  (/ (- desktop-w frame1-w) 2)
      ;;  (- (/ (- (/ (+ desktop-w frame1-w) 2) frame-l frame-r)
      ;;        (frame-char-width)) 2)))
     ((= cr-aligned 0)
      (modify-frame-lw 0 frame2-cw))
     ((= cr-aligned 1)
      (modify-frame-lw (/ (- desktop-w frame2-w) 2) frame2-cw))
     ((and (mc-in-desktop-p) (not (= cr-aligned 2)))
      (modify-frame-lw (/ (- desktop-w frame1-w) 2) frame2-cw))
     (t
      (modify-frame-lw -1 frame2-cw))))

   (t
    (cond
     ((not (or (in-desktop-p) (= cr-aligned 4)))
      (modify-firefox-lw (- frame1-w (min frame-l frame-r))
                         (+ (- desktop-w frame1-w) frame-l frame-r))
      ;; (modify-firefox-lw frame1-w (- desktop-w frame1-w))

      (modify-frame-lw 0 frame1-cw))

     ((and (not (mc-in-desktop-p)) (= cr-aligned 4))
      (modify-firefox-lw (- (/ (+ desktop-w frame1-w) 2) (min frame-l frame-r))
                         (+ (/ (- desktop-w frame1-w) 2) frame-l frame-r))
      ;; (modify-firefox-lw (/ (+ desktop-w frame1-w) 2)
      ;;                    (/ (- desktop-w frame1-w) 2))

      (modify-frame-lw (/ (- desktop-w frame1-w) 2) frame1-cw))

     ((= cr-aligned 0)
      (modify-firefox-lw (- frame1-w (min frame-l frame-r)) firefox-w)
      ;; (modify-firefox-lw frame1-w firefox-w)

      (modify-frame-lw 0 frame1-cw))

     ((= cr-aligned 1)
      (modify-firefox-lw
       (+ (/ (- desktop-w frame3-w) 2) (- frame1-w (min frame-l frame-r)))
       firefox-w)
      ;; (modify-firefox-lw
      ;;  (+ (/ (- desktop-w frame3-w) 2) frame1-w)
      ;;  firefox-w)

      (modify-frame-lw (/ (- desktop-w frame3-w) 2) frame1-cw))

     ((and (mc-in-desktop-p) (not (= cr-aligned 2)))
      (modify-firefox-lw
       (+ (/ (- desktop-w frame1-w) 2) (- frame1-w (min frame-l frame-r)))
       firefox-w)
      ;; (modify-firefox-lw
      ;;  (+ (/ (- desktop-w frame3-w) 2) frame1-w)
      ;;  firefox-w)

      (modify-frame-lw (/ (- desktop-w frame1-w) 2) frame1-cw))

     (t
      (modify-firefox-lw (+ (- desktop-w firefox-w) frame-r) firefox-w)
      ;; (modify-firefox-lw (- desktop-w firefox-w) firefox-w)

      (modify-frame-lw (- desktop-w frame3-w) frame1-cw))))))

(defun modify-window ()
  (remove-hook 'window-configuration-change-hook 'modify-window)
  (delete-other-windows)
  (cond
   ((= cr-contents 2)
    (split-window-horizontally (+ frame1-cw 2))
    (switch-to-buffer main-buf)
    (other-window 1)
    (cond
     ((not shell-p)
      (switch-to-buffer sub-buf)
      (other-window 1))
     (shell-t
      (split-window-vertically
       (if (> frame-ch 47) 21 (/ (* (- frame-ch 3) 4) 9)))
      (shell)
      (other-window 1)
      (switch-to-buffer sub-buf)
      (other-window 1))
     (t
      (split-window-vertically
       (if (> frame-ch 47) -21 (- (/ (* (- frame-ch 3) 4) 9))))
      (switch-to-buffer sub-buf)
      (other-window 1)
      (shell)
      (other-window 1))))
   (t
    (cond
     ((not shell-p)
      (switch-to-buffer main-buf))
     (shell-t
      (split-window-vertically (if (> frame-ch 47) 21 (- frame-ch 27)))
      (shell)
      (other-window 1)
      (switch-to-buffer main-buf))
     (t
      (split-window-vertically (if (> frame-ch 47) -21 (- 27 frame-ch)))
      (switch-to-buffer main-buf)
      (other-window 1)
      (shell)
      (other-window 1))))))

(defun save-window ()
  (let ((p (selected-window))
        (q (selected-window)))
    (cond
     ((eq (window-buffer p) (get-buffer "*shell*")))
     ((= (car (window-edges p)) 0)
      (setq main-buf (window-buffer p)))
     (t
      (setq sub-buf (window-buffer p))))
    (setq p (next-window p))
    (while (not (eq p q))
      (cond
       ((eq (window-buffer p) (get-buffer "*shell*")))
       ((= (car (window-edges p)) 0)
        (setq main-buf (window-buffer p)))
       (t
        (setq sub-buf (window-buffer p))))
      (setq p (next-window p)))))

(toggle-frame)

(provide 'window-config)
