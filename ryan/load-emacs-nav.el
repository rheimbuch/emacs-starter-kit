;; Load Emacs Nav

(add-to-list 'load-path (concat dotfiles-dir "ryan/emacs-nav-20110220"))
(require 'nav)
;; (nav)

(define-key global-map "\C-cb" 'nav)
