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

;; Emacs Behavior Mods

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

(when (fboundp 'winner-mode)
      (winner-mode 1))

(require 'color-theme)
(color-theme-initialize)
;;(color-theme-deep-blue)
;;(color-theme-comidia)
(color-theme-calm-forest)


(if (>= emacs-major-version 23)
    (set-frame-font "DejaVu Sans Mono-12"))




