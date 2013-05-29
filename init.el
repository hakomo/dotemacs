
;; (setq dropbox-emacs-dir "~/.emacs.d/")

(custom-set-variables
 '(menu-bar-mode nil)
 '(tool-bar-mode nil)
 '(scroll-bar-mode nil)

 '(show-paren-mode t)

 '(blink-cursor-mode nil)

 ;; '(linum-format "%4d")

 '(inhibit-startup-screen t)
 '(initial-scratch-message)

 '(scroll-step 1)

 '(indent-tabs-mode nil)
 '(c-default-style "gnu")

 '(auto-save-mode nil)
 '(make-backup-files nil)

 '(global-auto-revert-mode t)

 '(x-select-enable-clipboard t)

 '(eval-expression-print-length nil)

 '(load-path (append (list dropbox-emacs-dir
                           (concat dropbox-emacs-dir "auto-install"))
                     load-path)))

;; (load-theme 'misterioso t)

(custom-set-faces
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

 ;; '(anything-candidate-number    ((t ())))
 '(anything-ff-file             ((t (                            ))))
 '(anything-ff-directory        ((t (:inherit dired-directory    ))))

 '(default                      ((t (:family "consolas"
                                     :height 110
                                     :background "darkSlateGray"
                                     :foreground "white"
                                     )))))

(set-fontset-font nil 'japanese-jisx0208 (font-spec :family "MeiryoKe_Gothic"))

;; (require 'auto-install)
;; (setq auto-install-directory (concat dropbox-emacs-dir "auto-install/"))
;; (auto-install-update-emacswiki-package-name t)
;; (auto-install-compatibility-setup)

(require 'package)
(setq package-user-dir (concat dropbox-emacs-dir "elpa"))
;; (add-to-list 'package-archives
;;              '("melpa" . "http://melpa.milkbox.net/packages/") t)
;; (add-to-list 'package-archives
;;              '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(require 'toggle-shell)

(require 'window-config)

(load "improve")

(load "auto-compile-and-execute")

(require 'anything-startup)
(add-to-list 'anything-c-source-imenu '(mode-line . "\\<anything-map>"))
(add-to-list 'descbinds-anything-source-template
             '(candidate-number-limit . 800))

(require 'anything-yaetags)
(add-to-list 'anything-c-source-yaetags-select
             '(mode-line . "\\<anything-map>"))
(defun anything-yaetags ()
  (interactive)
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

;; (add-to-list 'load-path (concat dropbox-emacs-dir "auto-complete"))
;; (require 'auto-complete-config)
;; (add-to-list 'ac-dictionary-directories
;;              (concat dropbox-emacs-dir "auto-complete/dict"))
;; (ac-config-default)
;; (setq ac-auto-start nil) ;;
;; (add-to-list 'ac-modes 'web-mode)
;; (setq ac-use-fuzzy nil) ;;

;; (setq ac-use-menu-map t) ;;
;; (define-key ac-menu-map (kbd "C-k") 'ac-next) ;;
;; (define-key ac-menu-map (kbd "C-l") 'ac-previous) ;;

(require 'color-moccur)
(setq moccur-split-word t)

(require 'anything-c-moccur)
(setq anything-c-moccur-higligt-info-line-flag t
      anything-c-moccur-enable-auto-look-flag t
      anything-c-moccur-enable-initial-pattern t)

(require 'php-mode)

;; (require 'php-completion)

;; (add-hook 'php-mode-hook
;;           (lambda () (add-to-list 'ac-sources 'ac-source-php-completion)))

(load "sdic-for-popwin")

(global-set-key (kbd "C-a") 'back-to-indentation-or-beginning-of-line)
;; c
;; d
;; e
(global-set-key (kbd "C-f") 'anything-for-files)
;; g
(global-set-key (kbd "C-h") 'delete-backward-char)
;; i
(global-set-key (kbd "C-j") 'backward-char)
(global-set-key (kbd "C-k") 'next-line)
(global-set-key (kbd "C-l") 'previous-line)
(global-set-key (kbd "C-m") 'newline-and-indent)
(global-set-key (kbd "C-o") 'other-window)
(global-set-key (kbd "C-r") 'query-replace)
(global-set-key (kbd "C-s") 'anything-c-moccur-occur-by-moccur)
(global-set-key (kbd "C-t") 'toggle-shell)
;; u
(global-set-key (kbd "C-v") 'auto-compile-and-execute)
(global-set-key (kbd "C-w") 'kill-whole-line-or-region)
;; x
(global-set-key (kbd "C-y") 'delete-region-and-yank)
;; SPC
(global-set-key (kbd "C-.") 'anything-imenu)
;; /
(global-set-key (kbd "C-;") 'forward-char)
(global-set-key (kbd "C-`") 'next-error)

(global-set-key (kbd "M-h") 'mark-whole-buffer)
(global-set-key (kbd "M-l") 'recenter)
(global-set-key (kbd "M-o") 'toggle-frame)
(global-set-key (kbd "M-r") 'replace-string)
(global-set-key (kbd "M-s") 'anything-c-moccur-dmoccur)
(global-set-key (kbd "M-u") 'camel-to-snake-backward-word)
(global-set-key (kbd "M-w") 'kill-ring-save-whole-line-or-region)
;; x
(global-set-key (kbd "M-.") 'anything-yaetags)
(global-set-key (kbd "M-;") 'rough-comment)

(global-set-key (kbd "C-x C-c") 'save-buffers-kill-processes-and-terminal)
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

(add-hook 'js-mode-hook (setq js-indent-level 2))

;; (mapc (lambda (mdhook)
;;         (add-hook mdhook 'linum-mode))
;;       '(c-mode-hook css-mode-hook c++-mode-hook emacs-lisp-mode-hook
;;                     html-mode-hook java-mode-hook js-mode-hook
;;                     latex-mode-hook php-mode-hook ruby-mode-hook))

(add-hook 'before-save-hook 'delete-trailing-whitespace)
