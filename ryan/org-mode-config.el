;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Load Development Org-mode

(add-to-list 'load-path (concat dotfiles-dir "ryan/org-mode/lisp"))
(add-to-list 'load-path (concat dotfiles-dir "ryan/org-mode/contrib/lisp"))
(require 'org-install)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org-Mode Configuration


(setq org-directory "~/Dropbox/notes/")
(setq org-default-notes-file (concat org-directory "notes.org"))
(setq org-startup-indented t)
(setq org-mobile-directory "~/Dropbox/MobileOrg/")
(setq org-mobile-inbox-for-pull (concat org-mobile-directory "mobileorg.org"))

(require 'org-latex)
(require 'org-bibtex)
(require 'org-exp-bibtex)

(setq org-export-latex-listings 'listings)
(add-to-list 'org-export-latex-packages-alist '("" "listings"))
(add-to-list 'org-export-latex-packages-alist '("" "color"))

(add-to-list 'org-export-latex-classes
             '("koma-article"
               "\\documentclass{scrartcl}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\praragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(add-to-list 'org-export-latex-classes
             '("koma-report"
               "\\documentclass{scrreprt}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\praragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; active Babel Languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (R . t)
   (clojure . t)
   (python . t)
   (ruby . t)
   ))

;; auto evaled languages
(defun my-org-confirm-babel-evaluate (lang body)
  (not (or
        (string= lang "ditaa")
        (string= lang "ruby")
        (string= lang "emacs-lisp")
        (string= lang "elisp")
        (string= lang "python"))))

(setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)

;; Export ical format using UTC time
(setq org-icalendar-use-UTC-date-time t)
(setq org-combined-agenda-icalendar-file "~/Dropbox/MobileOrg/agenda.ics")

;; Handle Bibtex processing on pdf export
(setq org-latex-to-pdf-process
      '("pdflatex -interaction nonstopmode -output-directory %o %b"
        "bibtex %b"
        "pdflatex -interaction nonstopmode -output-directory %o %b"
        "pdflatex -interaction nonstopmode -output-directory %o %b"))

;; ;; Converted remember templates to org-capture.
;; ;; See: M-x customize-variable org-capture-templates
;; (setq org-remember-templates
;;       (list
;;        (list "Todo"
;;              ?t
;;              "* TODO %?\n  %i\n  %a"
;;              (concat org-directory "TODO.org")
;;              "Tasks")
;;        (list "Journal"
;;              ?j
;;              "* %U %?\n\n  %i\n  %a"
;;              (concat org-directory "Journal.org"))))



(define-key global-map "\C-cr" 'org-capture)

(setq org-todo-keywords
      '((sequence "TODO" "WORKINGON" "ONHOLD" "|" "DONE")
        (sequence "|" "CANCELED")))

;; Activate Clock In/Out
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Setup Reftex integration

(defun org-mode-reftex-setup ()
  (load-library "reftex")
  (and (buffer-file-name)
       (file-exists-p (buffer-file-name))
       (reftex-parse-all))
  (define-key org-mode-map (kbd "C-c )") 'reftex-citation))
(add-hook 'org-mode-hook 'org-mode-reftex-setup)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Compile Development Org-mode without make/install

(defvar my/org-lisp-directory "~/.emacs.d/org/lisp"
  "Directory where your org-mode files live.")

(defvar my/org-compile-sources t
  "If `nil', never compile org-sources. `my/compile-org' will only create
the autoloads file `org-install.el' then. If `t', compile the sources, too.")

;; Customize:
(setq my/org-lisp-directory "~/.emacs.d/ryan/org-mode/lisp")

;; Customize:
(setq  my/org-compile-sources t)

(defun my/compile-org(&optional directory)
  "Compile all *.el files that come with org-mode."
  (interactive)
  (setq directory (concat
                   (file-truename
                    (or directory my/org-lisp-directory)) "/"))

  (add-to-list 'load-path directory)

  (let ((list-of-org-files (file-expand-wildcards (concat directory "*.el"))))

    ;; create the org-install file
    (require 'autoload)
    (setq esf/org-install-file (concat directory "org-install.el"))
    (find-file esf/org-install-file)
    (erase-buffer)
    (mapc (lambda (x)
            (generate-file-autoloads x))
          list-of-org-files)
    (insert "\n(provide (quote org-install))\n")
    (save-buffer)
    (kill-buffer)
    (byte-compile-file esf/org-install-file t)

    (dolist (f list-of-org-files)
      (if (file-exists-p (concat f "c")) ; delete compiled files
          (delete-file (concat f "c")))
      (if my/org-compile-sources     ; Compile, if `my/org-compile-sources' is t
          (byte-compile-file f)))))
