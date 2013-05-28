
(make-variable-buffer-local 'compile-command)

(defvar execute-function)
(defvar execute-command-l "default")
(make-variable-buffer-local 'execute-command-l)

;; (setq project-alist '(("hakomo-desk" ("/home/hakomo/" . "b") ("c" . "d"))
;;                       ("hakomo-note" ("e" . "f") ("g" . "h"))))

;; (defun starts-with (s t)
;;   (string= (substring s 0 (min (length s) (length t))) t))

;; (defun project-exists-p ()
;;   (let ((l (cdr (assoc system-name project-alist))))
;;     (if (not l) nil
;;       (while (and l (not (starts-with buffer-file-name (caar l))))
;;         (setq l (cdr l)))
;;       (car l))))

;; (setq a-a '())
;; (add-to-list 'a-a '("hakomo-desk" ("a" . "b") ("c" . "d")))
;; (add-to-list 'a-a '("hakomo-note" ("e" . "f") ("g" . "h")))

;; (defun (l p)
;;   (let ((m nil) (q nil))
;;     (while l
;;       (cond
;;        ((starts-with buffer-file-name (caar l))
;;         (add-to-list 'm 'p)
;;         (setq m (append m (cdr l))
;;               q t
;;               l nil))
;;        (t
;;         (add-to-list 'm (car l))
;;         (setq l (cdr l)))))
;;     (when (not q)
;;       (add-to-list 'm 'p))
;;     m))

;; (defun ()
;;   (let ((l project-alist) (m nil) (p nil))
;;     (while l
;;       (cond
;;        ((string= (caar l) system-name)
;;         (add-to-list 'm (cons system-name (* (cdar l) '(d . f))))
;;         (setq m (append m (cdr l))
;;               p r
;;               l nil))
;;        (t
;;         (add-to-list 'm (car l))
;;         (setq l (cdr l)))))
;;     (when (not p)
;;       (add-to-list 'm `(,system-name (d . f))))
;;     m))

;; (add-to-list 'project-alist `(,system-name ((,d . ,f))))

(defun cd-unique-file (d n f)
  (shell-command
   (cond
    ((eq system-type 'gnu/linux)
     "") ;;
    ((eq system-type 'windows-nt)
     (concat "del " d " " n " /s"))))
  (write-region f nil (concat d n)))

(defun get-unique-file-path (n)
  (let ((d default-directory)
        (p ""))
    (while (not (or (string= d p) (file-exists-p (concat d n))))
      (setq p d
            d (file-name-directory (directory-file-name d))))
    (if (string= d p) nil d)))

(defun get-root ()
  (let ((d (get-unique-file-path "javaMainPath"))
        (e (get-unique-file-path "TAGS")))
    (if d d e)))

(defun cd-root (d)
  (interactive "DProject root directory: ")
  (cd-unique-file d "javaMainPath" (substring buffer-file-name (length d)))
  (cd-unique-file d "TAGS" nil))

(defun update-main-path ()
  (interactive)
  (let ((d (get-root)))
    (when (not d)
      (setq d (read-directory-name "Project root directory: ")))
    (cd-unique-file d "javaMainPath" (substring buffer-file-name (length d)))))

(defun execute ()
  (interactive)
  (setq execute-command-l (read-string "Execute command: " execute-command-l)))

;; (let ((d (read-directory-name "Project root directory: "))
;;       (f (read-file-name "Main file: " buffer-file-name)))
;;   (setq f (substring f (length d)))



;;   )

(defun auto-compile-and-execute-java ()
  (let ((d (get-unique-file-path "javaMainPath")))
    (when (not d)
      (setq d (get-unique-file-path "TAGS"))
      (when (not d)
        (setq d (read-directory-name "Project root directory: ")))
      (cd-unique-file
       d "javaMainPath"
       (substring (read-file-name "Main file: " buffer-file-name) (length d))))
    (when (not (file-exists-p "classes"))
      (make-directory "classes"))

    (when (string= compile-command "make -k ")
      (setq compile-command
            (concat "javac -cp " d ".. -d " d "classes " d
                    (with-temp-buffer
                      (insert-file-contents (concat d "javaMainPath"))
                      (buffer-string)) " ")))

    (when (string= execute-command-l "default")
      (setq execute-command-l
            (concat "java -cp " d "classes "
                    (replace-regexp-in-string
                     "/" "."
                     (concat (substring d (length (file-name-directory
                                                   (directory-file-name d))))
                             (file-name-sans-extension
                              (with-temp-buffer
                                (insert-file-contents (concat d "javaMainPath"))
                                (buffer-string))))) " "))))
  (setq execute-function
        (if (string= execute-command-l "")
            'invalid
          `(lambda ()
             (set-buffer "*shell*")
             (goto-char (point-max))
             (comint-kill-input)
             (insert ,execute-command-l)
             (comint-send-input))))
  (compile compile-command))

;; (defun url-escape-point (c)
;;   "Escape (quote) a character for a URL"
;;   (format "%%%X" (string-to-char c)))

;; (defun url-quote-str-utf8 (s)
;;   "Quote special characters in a URL string"
;;   (let ((unquoted-re "[^a-zA-Z0-9_./-:]")
;;         (encoded (encode-coding-string s 'utf-8))
;;         (n 0))
;;     (while (setq n (string-match unquoted-re encoded n))
;;       (setq encoded
;;             (replace-match (url-escape-point (match-string 0 encoded))
;;                            t t encoded)
;;             n (1+ n)))
;;     encoded))

;; (defun url-quote-region-utf8 (min max)
;;   "Quote text for inclusion in a HTTP URL"
;;   (interactive "*r")
;;   (let ((s (copy-sequence (buffer-substring min max))))
;;     (goto-char max)
;;     (insert " => ")
;;     (set-mark-command nil)
;;     (insert (url-quote-str-utf8 s))))

;;     (setq execute-function
;;           (if (string= execute-command-l "")
;;               'invalid
;;             `(lambda ()
;;                (comint-send-string (inferior-moz-process) ,(concat "
;; function reload(){
;;   var i;
;;   for(i=0;i<gBrowser.browsers.length;++i){
;;     var spec=gBrowser.getBrowserAtIndex(i).currentURI.spec.toLowerCase();
;;     if(spec=='file:///" (url-quote-str-utf8 (file-name-sans-extension buffer-file-name)) ".pdf" "'.toLowerCase())break;
;;   }
;;   if(i>=gBrowser.browsers.length)return;
;;   gBrowser.selectedTab=gBrowser.tabContainer.childNodes[i];
;;   BrowserReload();
;; }
;; reload();
;; ")))))

;; (defun TeX-command-master-a (&optional override-confirm)
;;   (interactive "P")
;;   (add-to-list 'TeX-command-list '("ptex2pdf" "ptex2pdf -l -ot '-synctex=1' %t"
;;                                    TeX-run-TeX nil (latex-mode)))
;;   (TeX-command "ptex2pdf" 'TeX-master-file override-confirm))

(defun auto-compile-and-execute ()
  (interactive)
  (save-some-buffers t)
  (cond
   ((eq major-mode 'emacs-lisp-mode)
    (emacs-lisp-byte-compile))

   ;; ((eq major-mode 'latex-mode)

   ;;  (let ((n (file-name-nondirectory buffer-file-name)))
   ;;    (cond
   ;;     ((file-newer-than-file-p n (concat (file-name-sans-extension n) ".pdf"))
   ;;      ;; (when (string= compile-command "make -k ")
   ;;      ;;   (setq compile-command (concat "ptex2pdf -l -ot '-synctex=1' " n)))

   ;;      ;; (setq execute-function
   ;;      ;;       `(lambda ()
   ;;      ;;          (shell-command
   ;;      ;;           ,(format "fwdsumatrapdf.exe %s.pdf %s %d"
   ;;      ;;                    (file-name-sans-extension n) n
   ;;      ;;                    (line-number-at-pos)))))

   ;;      (TeX-command-master-a)

   ;;      ;; (compile compile-command)
   ;;      )

   ;;     (t
   ;;      (shell-command
   ;;       (format "fwdsumatrapdf.exe %s.pdf %s %d" (file-name-sans-extension n) n
   ;;               (line-number-at-pos)))))))

   ((eq major-mode 'java-mode)
    (auto-compile-and-execute-java))))

(defun auto-close (b s)
  (when (string-match "finished" s)
    (when (save-current-buffer
            (set-buffer b)
            (save-excursion
              (goto-char (point-min))
              (not (or (search-forward "warning:" nil t)
                       ;; (search-forward "" nil t)
                       (search-forward "note:" nil t)
                       ;; (search-forward "" nil t)
                       ))))
      (delete-window (get-buffer-window b)))
    (funcall execute-function)))

(setq compilation-finish-functions 'auto-close)

(defun update-tags ()
  (let ((d (get-root)))
    (when d
      (shell-command (concat "ctags -e -f " d "TAGS -R -L - "
                             (directory-file-name d))))))

(add-hook 'after-save-hook 'update-tags)
