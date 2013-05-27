
(require 'moz)
(require 'save-window)

(defvar firefox-w 1030)

(defvar frame1-cw 80)

(defvar winconf-list '((1 . 1) (2 . 1) (3 . 3)))

(defvar window-config-mode nil)

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

(defvar desktop-y 0)
(defvar desktop-h (- (x-display-pixel-height) 40))
(defvar desktop-x 0)
(defvar desktop-w (x-display-pixel-width))
(defvar frame-t 30)
(defvar frame-b 8)
(defvar frame-l 8)
(defvar frame-r 8)

(load (downcase (concat user-login-name "@" system-name)) t)

(setq firefox-w (+ firefox-w frame-l frame-r))

(cond
 ((eq system-type 'windows-nt)
  (defvar frame-ch (/ (- desktop-h frame-t) (frame-char-height))))
 (t
  (defvar frame-ch (/ (- desktop-h frame-t frame-b) (frame-char-height)))))

(defvar frame2-cw (+ (* frame1-cw 2) 2))

(defvar frame1-w (+ (* (+ frame1-cw 2) (frame-char-width)) frame-l frame-r))
(defvar frame2-w (+ (* (+ frame2-cw 2) (frame-char-width)) frame-l frame-r))

(cond
 ((eq system-type 'windows-nt)
  (defvar frame3-w (+ (- frame1-w frame-r) (max frame-l frame-r)
                      (- firefox-w frame-l frame-r))))
 (t
  (defvar frame3-w (+ frame1-w firefox-w))))

(defvar cr-contents)
(defvar cr-aligned)

(defvar frame-id 0)

(defun ltwh-alist (lt tp wd ht)
  `((left . ,(if (= lt -1) -1 (+ desktop-x lt)))
    (top . ,(if (= tp -1) -1 (+ desktop-y tp))) (width . ,wd) (height . ,ht)))

(defun modify-frame-ltwh (lt tp wd ht)
  (if (and (= wd (frame-width)) (= ht (frame-height)))
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
  (cond
   ((eq system-type 'windows-nt)
    (modify-firefox-ltwh lt (- frame-t) wd (+ desktop-h frame-t frame-b)))
   (t
    (modify-firefox-ltwh lt 0 wd desktop-h))))

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

(defun modify-window ()
  (remove-hook 'window-configuration-change-hook 'modify-window)
  (save-window)
  (delete-other-windows)
  (when (= cr-contents 2)
    (split-window-horizontally (+ frame1-cw 2)))
  (recover-window))

(defun modify-frame ()
  (cond
   ((= cr-contents 1)
    (modify-firefox-lw (/ (- desktop-w firefox-w) 2) firefox-w)
    (cond
     ((= cr-aligned 0)
      (modify-frame-lw 0 frame1-cw))
     ((= cr-aligned 2)
      (modify-frame-lw -1 frame1-cw))
     (t
      (modify-frame-lw (/ (- desktop-w frame1-w) 2) frame1-cw))))

   ((= cr-contents 2)
    (modify-firefox-lw (/ (- desktop-w firefox-w) 2) firefox-w)
    (cond
     ((not (or (in-desktop-p) (= cr-aligned 4)))
      (cond
       ((eq system-type 'windows-nt)
        (modify-frame-lw 0 (- (/ (- desktop-w frame-l) (frame-char-width)) 2)))
       (t
        (modify-frame-lw
         0 (- (/ (- desktop-w frame-l frame-r) (frame-char-width)) 2)))))
     ((and (not (mc-in-desktop-p)) (= cr-aligned 4))
      (cond
       ((eq system-type 'windows-nt)
        (modify-frame-lw
         (/ (- desktop-w frame1-w) 2)
         (- (/ (- (/ (+ desktop-w frame1-w) 2) frame-l) (frame-char-width)) 2)))
       (t
        (modify-frame-lw
         (/ (- desktop-w frame1-w) 2)
         (- (/ (- (/ (+ desktop-w frame1-w) 2) frame-l frame-r)
               (frame-char-width)) 2)))))
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
      (cond
       ((eq system-type 'windows-nt)
        (modify-firefox-lw (- frame1-w (min frame-l frame-r))
                           (+ (- desktop-w frame1-w) frame-l frame-r)))
       (t
        (modify-firefox-lw frame1-w (- desktop-w frame1-w))))
      (modify-frame-lw 0 frame1-cw))

     ((and (not (mc-in-desktop-p)) (= cr-aligned 4))
      (cond
       ((eq system-type 'windows-nt)
        (modify-firefox-lw
         (- (/ (+ desktop-w frame1-w) 2) (min frame-l frame-r))
         (+ (/ (- desktop-w frame1-w) 2) frame-l frame-r)))
       (t
        (modify-firefox-lw (/ (+ desktop-w frame1-w) 2)
                           (/ (- desktop-w frame1-w) 2))))
      (modify-frame-lw (/ (- desktop-w frame1-w) 2) frame1-cw))

     ((= cr-aligned 0)
      (cond
       ((eq system-type 'windows-nt)
        (modify-firefox-lw (- frame1-w (min frame-l frame-r)) firefox-w))
       (t
        (modify-firefox-lw frame1-w firefox-w)))
      (modify-frame-lw 0 frame1-cw))

     ((= cr-aligned 1)
      (cond
       ((eq system-type 'windows-nt)
        (modify-firefox-lw
         (+ (/ (- desktop-w frame3-w) 2) (- frame1-w (min frame-l frame-r)))
         firefox-w))
       (t
        (modify-firefox-lw (+ (/ (- desktop-w frame3-w) 2) frame1-w)
                           firefox-w)))

      (modify-frame-lw (/ (- desktop-w frame3-w) 2) frame1-cw))

     ((and (mc-in-desktop-p) (not (= cr-aligned 2)))
      (cond
       ((eq system-type 'windows-nt)
        (modify-firefox-lw
         (+ (/ (- desktop-w frame1-w) 2) (- frame1-w (min frame-l frame-r)))
         firefox-w))
       (t
        (modify-firefox-lw (+ (/ (- desktop-w frame3-w) 2) frame1-w)
                           firefox-w)))
      (modify-frame-lw (/ (- desktop-w frame1-w) 2) frame1-cw))

     (t
      (cond
       ((eq system-type 'windows-nt)
        (modify-firefox-lw (+ (- desktop-w firefox-w) frame-r) firefox-w))
       (t
        (modify-firefox-lw (- desktop-w firefox-w) firefox-w)))
      (modify-frame-lw (- desktop-w frame3-w) frame1-cw))))))

(defun toggle-frame ()
  (interactive)
  (let ((l (nth frame-id winconf-list)))
    (setq cr-contents (car l)
          cr-aligned (cdr l)))
  (modify-frame)
  (setq frame-id (% (+ frame-id 1) (length winconf-list))))

(toggle-frame)

(provide 'window-config)
