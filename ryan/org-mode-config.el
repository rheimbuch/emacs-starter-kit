;; Org-Mode Configuration
(org-remember-insinuate)
(setq org-directory "~/Dropbox/notes/")
(setq org-default-notes-file (concat org-directory "notes.org"))

(setq org-remember-templates
      (list
       (list "Todo"
             ?t
             "* TODO %?\n  %i\n  %a"
             (concat org-directory "TODO.org")
             "Tasks")
       (list "Journal"
             ?j
             "* %U %?\n\n  %i\n  %a"
             (concat org-directory "Journal.org"))))

(define-key global-map "\C-cr" 'org-remember)

(setq org-todo-keywords
      '((sequence "TODO" "WORKINGON" "ONHOLD" "|" "DONE")
        (sequence "|" "CANCELED")))
