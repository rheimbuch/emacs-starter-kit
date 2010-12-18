(setq org-export-blocks
      (cons '(erviz org-export-blocks-format-erviz) org-export-blocks))

(defvar org-erviz-cui-jar-path (expand-file-name
                                "erviz-cui-1.0.6.jar"
                                (file-name-directory (or load-file-name buffer-file-name))))

(defvar org-erviz-core-jar-path (expand-file-name
                                 "erviz-core-1.0.6.jar"
                                 (file-name-directory (or load-file-name buffer-file-name))))

(defun org-export-blocks-format-erviz-command (in-file out-file args)
  (concat "java -cp "
          "\"" org-erviz-cui-jar-path ":" org-erviz-core-jar-path "\" "
          "jp.gr.java_conf.simply.erviz.cui.Main"
          " -i " data-file " -o " out-file " " args))

(defun org-export-blocks-format-erviz (body &rest headers)
  "Pass block BODY to the erviz utility to create an image"
  (message "erviz-formatting...")
  (let* ((args (if (cdr headers) (mapconcat 'identity (cdr headers) " ")))
         (data-file (make-temp-file "org-erviz"))
         (hash (progn
                 (set-text-properties 0 (length body) nil body)
                 (sha1 (prin1-to-string (list body args)))))
         (raw-out-file (if headers (car headers)))
         (out-file-parts (if (string-match "\\(.+\\)\\.\\([^\\.]+\\)$" raw-out-file)
                             (cons (match-string 1 raw-out-file)
                                   (match-string 2 raw-out-file))
                           (cons raw-out-file "png")))
         (dot-file (concat (car out-file-parts) "_" hash "." "dot"))
         (out-file (concat (car out-file-parts) "_" hash "." (cdr out-file-parts))))
    (cond
     ((or htmlp latexp docbookp)
      (unless (file-exists-p out-file)
        (mapc ;; remove old hashed versions of this file
         (lambda (file)
           (when (and (string-match (concat (regexp-quote (car out-file-parts))
                                            "_\\([[:alnum:]]+\\)\\."
                                            (regexp-quote (cdr out-file-parts)))
                                    file)
                      (= (length (match-string 1 out-file)) 40))
             (delete-file (expand-file-name file
                                            (file-name-directory out-file)))))
         (directory-files (or (file-name-directory out-file)
                              default-directory)))
        (with-temp-file data-file (insert body))
        (message (org-export-blocks-format-erviz-command data-file dot-file args))
        (shell-command (org-export-blocks-format-erviz-command data-file dot-file args))
        (shell-command (concat "dot " dot-file " -Tpng " " -o " out-file)))
      (format "\n[[file:%s]]\n" out-file))
     (t (concat
         "\n#+BEGIN_EXAMPLE\n"
         body (if (string-match "\n$" body) "" "\n")
         "#+END_EXAMPLE\n")))
    )
  )
