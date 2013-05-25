
;; (setq dropbox-emacs-dir "~/.emacs.d/")

(require 'server)
(when (not (server-running-p))
  (server-start))

(custom-set-variables
 '(menu-bar-mode nil)
 '(tool-bar-mode nil)
 '(scroll-bar-mode nil)

 ;; '(mode-line-format '(" " mode-line-buffer-identification " "
 ;;                      mode-line-modes))

 '(show-paren-mode t)

 '(blink-cursor-mode nil)

 ;; '(linum-format "%4d")

 '(inhibit-startup-screen t)
 '(initial-scratch-message)

 '(scroll-step 1)

 '(indent-tabs-mode nil)
 ;; '(c-default-style "gnu")

 '(auto-save-mode nil)
 '(make-backup-files nil)

 '(global-auto-revert-mode t)

 '(x-select-enable-clipboard t)

 '(eval-expression-print-length nil)

 ;; '(default-frame-alist (append '((alpha . 90)) default-frame-alist))

 '(load-path (append (list dropbox-emacs-dir
                           (concat dropbox-emacs-dir "auto-install"))
                     load-path)))

;; (load-theme 'misterioso t)

(custom-set-faces
 ;; '(anything-candidate-number    ((t ())))
 '(comint-highlight-prompt      ((t (                            ))))
 '(error                        ((t (:foreground "pink"          ))))
 '(font-lock-builtin-face       ((t (:foreground "deepSkyBlue"   ))))
 '(font-lock-comment-face       ((t (:foreground "lightSalmon"   ))))
 '(font-lock-constant-face      ((t (:foreground "deepSkyBlue"   ))))
 '(font-lock-function-name-face ((t (:foreground "lightGoldenrod"))))
 '(font-lock-keyword-face       ((t (:foreground "deepSkyBlue"   ))))
 '(font-lock-string-face        ((t (:foreground "lightSalmon"   ))))
 '(font-lock-type-face          ((t (:foreground "paleGreen"     ))))
 '(font-lock-variable-name-face ((t (:foreground "lightGoldenrod"))))
 '(fringe                       ((t (                            ))))
 '(header-line                  ((t (:background "#902448"       ))))
 '(highlight                    ((t (:background "darkOliveGreen"))))
 ;; '(linum                        ((t (:foreground "white"         ))))
 '(match                        ((t (:background "darkOliveGreen"))))
 '(minibuffer-prompt            ((t (:foreground "deepSkyBlue"   ))))
 '(mode-line                    ((t (:background "#902448"       ))))
 '(mode-line-highlight          ((t (                            ))))
 '(mode-line-inactive           ((t (:background "#481224"       ))))
 '(region                       ((t (:background "darkOliveGreen"))))
 '(show-paren-match             ((t (:background "deepSkyBlue"   ))))
 '(show-paren-mismatch          ((t (:background "#902448"       ))))

 ;; '(anything-ff-file             ((t (                            ))))
 ;; '(anything-ff-directory        ((t (:inherit dired-directory    ))))

 '(default                      ((t (:family "consolas"
                                     :height 110
                                     :background "darkSlateGray"
                                     :foreground "white"
                                     )))))

(set-fontset-font nil 'japanese-jisx0208 (font-spec :family "MeiryoKe_Gothic"))

(load "auto-reload")

(require 'window-config)

(load "improve")

(load "auto-compile-and-execute")

;; (require 'auto-install)
;; (setq auto-install-directory (concat dropbox-emacs-dir "auto-install"))
;; (auto-install-update-emacswiki-package-name t)
;; (auto-install-compatibility-setup)

(require 'anything-startup)
(add-to-list 'anything-c-source-imenu '(mode-line . "\\<anything-map>"))
(add-to-list 'descbinds-anything-source-template
             '(candidate-number-limit . 800))

(require 'anything-yaetags)
(add-to-list 'anything-c-source-yaetags-select
             '(mode-line . "\\<anything-map>"))
(defun anything-yaetags ()
  (interactive)
  (update-tags)
  (anything-other-buffer '(anything-c-source-yaetags-select)
                         "*anything yaetags*"))

(require 'popwin)
(popwin-mode 1)
(setq popwin:popup-window-height 16
      anything-samewindow nil
      popwin:special-display-config
      (append '(("*anything*") ("*anything for files*") ("*anything yaetags*")
                ("*sdic*")) popwin:special-display-config))

;; (add-to-list 'load-path (concat dropbox-emacs-dir "yasnippet"))
;; (require 'yasnippet)
;; (yas-global-mode 1)

(add-to-list 'load-path (concat dropbox-emacs-dir "auto-complete"))
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories
             (concat dropbox-emacs-dir "auto-complete/dict"))
(ac-config-default)
(setq ac-auto-start nil) ;;
(add-to-list 'ac-modes 'web-mode)
(setq ac-use-fuzzy nil) ;;

(setq ac-use-menu-map t) ;;
(define-key ac-menu-map (kbd "C-k") 'ac-next) ;;
(define-key ac-menu-map (kbd "C-l") 'ac-previous) ;;

(require 'color-moccur)
(setq moccur-split-word t)

(require 'anything-c-moccur)
(setq anything-c-moccur-higligt-info-line-flag t
      anything-c-moccur-enable-auto-look-flag t
      anything-c-moccur-enable-initial-pattern t)

(require 'web-mode)
(setq auto-mode-alist
      (append '(("\\.[sx]?html?\\(\\.[a-zA-Z_]+\\)?\\'" . web-mode)
                ("\\.inc\\'" . web-mode) ("\\.phtml\\'" . web-mode)
                ("\\.php[s34]?\\'" . web-mode)) auto-mode-alist))

(require 'php-completion)

(add-hook 'web-mode-hook
          (lambda () (add-to-list 'ac-sources 'ac-source-php-completion)))

(add-to-list 'load-path (concat dropbox-emacs-dir "sdic"))
(require 'sdic)
;; sdic-display-buffer ��������
(defadvice sdic-display-buffer (around sdic-display-buffer-normalize activate)
  "sdic �̃o�b�t�@�\���𕁒ʂɂ���B"
  (setq ad-return-value (buffer-size))
  (let ((p (or (ad-get-arg 0)
               (point))))
    (and sdic-warning-hidden-entry
         (> p (point-min))
         (message "���̑O�ɂ��G���g��������܂��B"))
    (goto-char p)
    (display-buffer (get-buffer sdic-buffer-name))
    (set-window-start (get-buffer-window sdic-buffer-name) p)))

(defadvice sdic-other-window (around sdic-other-normalize activate)
  "sdic �̃o�b�t�@�ړ��𕁒ʂɂ���B"
  (other-window 1))

(defadvice sdic-close-window (around sdic-close-normalize activate)
  "sdic �̃o�b�t�@�N���[�Y�𕁒ʂɂ���B"
  (bury-buffer sdic-buffer-name))

(add-to-list 'load-path (concat dropbox-emacs-dir "yatex"))
(require 'yatex)

;; (setq tex-command "platex")
;; ;; (setq tex-command "ptex2pdf -l -ot '-texsync=1'")

(add-to-list 'load-path (concat dropbox-emacs-dir "site-lisp/site-start.d"))
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)

(global-set-key (kbd "C-a") 'back-to-indentation-or-beginning-of-line)
;; c
;; d
;; e
(global-set-key (kbd "C-f") 'anything-for-files)
;; g
(global-set-key (kbd "C-h") 'delete-backward-char)
;; (global-set-key (kbd "C-i") 'auto-complete)
(global-set-key (kbd "C-j") 'backward-char)
(global-set-key (kbd "C-k") 'next-line)
(global-set-key (kbd "C-l") 'previous-line)
(global-set-key (kbd "C-m") 'newline-and-indent)
(global-set-key (kbd "C-o") 'other-window)
(global-set-key (kbd "C-r") 'query-replace)
(global-set-key (kbd "C-s") 'anything-c-moccur-occur-by-moccur)
(global-set-key (kbd "C-t") 'anything-imenu)
;; u
(global-set-key (kbd "C-v") 'auto-compile-and-execute)
(global-set-key (kbd "C-w") 'kill-whole-line-or-region)
;; x
(global-set-key (kbd "C-y") 'delete-region-and-yank)
;; SPC
(global-set-key (kbd "C-,") 'scroll-up-command)
(global-set-key (kbd "C-.") 'scroll-down-command)
;; /
(global-set-key (kbd "C-;") 'forward-char)
(global-set-key (kbd "C-`") 'next-error)

(global-set-key (kbd "M-h") 'mark-whole-buffer)
(global-set-key (kbd "M-l") 'recenter)
(global-set-key (kbd "M-o") 'toggle-frame)
(global-set-key (kbd "M-r") 'replace-string)
(global-set-key (kbd "M-s") 'anything-c-moccur-dmoccur)
(global-set-key (kbd "M-t") 'anything-yaetags)
(global-set-key (kbd "M-u") 'upcase-backward-word)
(global-set-key (kbd "M-w") 'kill-ring-save-whole-line-or-region)
;; x
(global-set-key (kbd "M-;") 'rough-comment)

(global-set-key (kbd "C-x C-c") 'save-all-buffers-kill-emacs) ;;
;; e

(define-key anything-map (kbd "C-f") 'anything-quit-and-find-file)
(define-key anything-map (kbd "C-h") nil)
(define-key anything-map (kbd "C-j") 'anything-previous-source)
(define-key anything-map (kbd "C-k") 'anything-next-line)
(define-key anything-map (kbd "C-l") 'anything-previous-line)
(define-key anything-map (kbd "C-w") nil)
(define-key anything-map (kbd "C-;") 'anything-next-source)

(define-key anything-c-moccur-anything-map (kbd "C-h") nil)
(define-key anything-c-moccur-anything-map (kbd "C-j")
  'anything-c-moccur-anything-previous-file-matches)
(define-key anything-c-moccur-anything-map (kbd "C-k")
  'anything-c-moccur-next-line)
(define-key anything-c-moccur-anything-map (kbd "C-l")
  'anything-c-moccur-previous-line)
(define-key anything-c-moccur-anything-map (kbd "C-w") nil)
(define-key anything-c-moccur-anything-map (kbd "C-;")
  'anything-c-moccur-anything-next-file-matches)

(define-key web-mode-map (kbd "C-;") nil)
(define-key web-mode-map (kbd "M-;") nil)

;; (define-key tex-mode-map (kbd "C-j") nil)

(add-hook 'js-mode-hook (setq js-indent-level 2))

;; (mapc (lambda (mdhook)
;;         (add-hook mdhook 'linum-mode))
;;       '(emacs-lisp-mode-hook c-mode-hook c++-mode-hook ruby-mode-hook
;;                              js-mode-hook java-mode-hook web-mode-hook))

(add-hook 'before-save-hook 'delete-trailing-whitespace)