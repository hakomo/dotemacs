
(require 'flycheck)

(require 'auto-reload)

(require 'server)
(server-start)

(make-variable-buffer-local 'compile-command)

(defvar execute-function)
(defvar execute-command-l "default")
(make-variable-buffer-local 'execute-command-l)

(defvar shell-delimiter (if (eq system-type 'windows-nt) "&" ";"))

(defun get-parent-directory-file (d n)
  (let ((p ""))
    (while (not (or (string= d p) (file-exists-p (concat d n))))
      (setq p d
            d (file-name-directory (directory-file-name d))))
    (if (string= d p) nil d)))

(defun get-root-directory ()
  (let ((d (get-parent-directory-file default-directory ".projectemacs")))
    (if d d (get-parent-directory-file default-directory "TAGS"))))

(defun delete-file-parent-directory (d n)
  (let ((p ""))
    (while (not (string= d p))
      (when (file-exists-p (concat d n))
        (delete-file (concat d n)))
      (setq p d
            d (file-name-directory (directory-file-name d))))))

(defun delete-file-recursively (d n)
  (dolist (f (directory-files d))
    (cond
     ((file-directory-p (concat d f))
      (when (not (or (string= f ".") (string= f "..")))
        (delete-file-recursively (concat d f "/") n)))
     ((string= f n)
      (delete-file (concat d n))))))

(defun init-file (d n f)
  (delete-file-parent-directory d n)
  (delete-file-recursively d n)
  (write-region f nil (concat d n)))

(defun init-project (d)
  (interactive "DProject root directory: ")
  (setq d (expand-file-name d))
  (init-file
   d ".projectemacs"
   (substring (expand-file-name (read-file-name "Main file: " buffer-file-name))
              (length d)))
  (init-file d "TAGS" "")
  (update-tags))

;; (defun execute ()
;;   (interactive)
;;   (setq execute-command-l (read-string "Execute command: " execute-command-l)))

(defun auto-compile-and-execute-java ()
  (let ((d (get-root-directory)))
    (cond
     (d
      (when (not (file-directory-p (concat d "classes")))
        (make-directory (concat d "classes")))

      (when (string= compile-command "make -k ")
        (setq compile-command
              (concat "javac -cp \"" d "..\" -d \"" d "classes\" \"" d
                      (with-temp-buffer
                        (insert-file-contents (concat d ".projectemacs"))
                        (buffer-string)) "\" ")))

      (when (string= execute-command-l "default")
        (setq execute-command-l
              (concat "java -cp \"" d "classes\" \""
                      (replace-regexp-in-string
                       "/" "."
                       (concat (substring d (length (file-name-directory
                                                     (directory-file-name d))))
                               (file-name-sans-extension
                                (with-temp-buffer (insert-file-contents
                                                   (concat d ".projectemacs"))
                                                  (buffer-string))))) "\" ")))

      (setq execute-function
            (if (string= execute-command-l "")
                nil
              `(lambda ()
                 (set-buffer "*shell*")
                 (goto-char (point-max))
                 (comint-kill-input)
                 (insert ,execute-command-l)
                 (comint-send-input)))))
     (t
      (when (string= compile-command "make -k ")
        (setq compile-command
              (concat "javac \"" (file-name-nondirectory buffer-file-name)
                      "\" ")))

      (when (string= execute-command-l "default")
        (setq execute-command-l
              (concat "java -cp . \"" (file-name-sans-extension
                                       (file-name-nondirectory
                                        buffer-file-name)) "\" ")))

      (setq execute-function
            (if (string= execute-command-l "")
                nil
              `(lambda ()
                 (set-buffer "*shell*")
                 (goto-char (point-max))
                 (comint-kill-input)
                 (insert ,(concat "cd \"" default-directory "\" "
                                  shell-delimiter " " execute-command-l))
                 (comint-send-input)))))))

  (compile compile-command))

(defun auto-compile-and-execute-cpp ()
  (when (string= compile-command "make -k ")
    (setq compile-command
          (concat "g++ -Wall \"" (file-name-nondirectory buffer-file-name)
                  "\" ")))

  (when (string= execute-command-l "default")
    (setq execute-command-l "./a.out "))

  (setq execute-function
        (if (string= execute-command-l "")
            nil
          `(lambda ()
             (set-buffer "*shell*")
             (goto-char (point-max))
             (comint-kill-input)
             (insert ,(concat "cd \"" default-directory "\" "
                              shell-delimiter " " execute-command-l))
             (comint-send-input))))

  (compile compile-command))

(defun auto-compile-and-execute-tex ()
  (let ((n (file-name-sans-extension (file-name-nondirectory
                                      buffer-file-name))))
    (cond
     ((file-newer-than-file-p (concat n ".tex") (concat n ".pdf"))
      (setq execute-function
            `(lambda ()
               (set-buffer "*shell*")
               (goto-char (point-max))
               (comint-kill-input)
               (insert ,(format "cd \"%s\" %s ptex2pdf -l -ot '-synctex=1' \"%s.tex\" %s fwdsumatrapdf.exe \"%s.pdf\" \"%s.tex\" %d "
                                default-directory shell-delimiter n
                                shell-delimiter n n (line-number-at-pos)))
               (comint-send-input)))
      (flycheck-compile))
     (t
      (shell-command (format "fwdsumatrapdf.exe \"%s.pdf\" \"%s.tex\" %d " n n
                             (line-number-at-pos)))))))

(defun auto-compile-and-execute-ruby ()
  (when (string= execute-command-l "default")
    (setq execute-command-l (concat "ruby \"" (file-name-nondirectory
                                               buffer-file-name) "\" ")))

  (setq execute-function
        (if (string= execute-command-l "")
            nil
          `(lambda ()
             (set-buffer "*shell*")
             (goto-char (point-max))
             (comint-kill-input)
             (insert ,(concat "cd \"" default-directory "\" "
                              shell-delimiter " " execute-command-l))
             (comint-send-input))))

  (flycheck-compile))

(defun auto-compile-and-execute ()
  (interactive)
  (save-some-buffers t)
  (cond
   ((eq major-mode 'emacs-lisp-mode)
    (emacs-lisp-byte-compile))

   ((eq major-mode 'latex-mode)
    (auto-compile-and-execute-tex))

   ((or (eq major-mode 'html-mode)
        (eq major-mode 'css-mode)
        (eq major-mode 'js-mode)
        (eq major-mode 'php-mode))
    (auto-reload))

   ((eq major-mode 'ruby-mode)
    (auto-compile-and-execute-ruby))

   ((or (eq major-mode 'c-mode)
        (eq major-mode 'c++-mode))
    (auto-compile-and-execute-cpp))

   ((eq major-mode 'java-mode)
    (auto-compile-and-execute-java))))

(defun auto-close (b s)
  (when (string-match "finished" s)
    (with-current-buffer b
      (let ((i (point-min)))
        (while (and (<= i (point-max))
                    (not (equal (get-text-property i 'face)
                                '(compilation-line-number underline))))
          (setq i (1+ i)))
        (when (> i (point-max))
          (delete-window (get-buffer-window b))
          (when execute-function
            (funcall execute-function)))))))

(setq compilation-finish-functions 'auto-close)

(defun update-tags ()
  (let ((d (get-root-directory)))
    (when d
      (shell-command
       (concat "ctags -e -f \"" d "TAGS\" -R -L - \"" (directory-file-name d)
               "\" ")))))

(add-hook 'after-save-hook 'update-tags)
