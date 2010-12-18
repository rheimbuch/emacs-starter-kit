;; Emacs Behavior Mods

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

(when (fboundp 'winner-mode)
      (winner-mode 1))

(add-to-list 'load-path (concat dotfiles-dir "ryan/windows"))
(require 'windows)
(win:startup-with-window)
(define-key ctl-x-map "C" 'see-you-again)

(autoload 'save-current-configuration "revive" "Save status" t)
(autoload 'resume "revive" "Resume Emacs" t)
(autoload 'wipe "revive" "Wipe Emacs" t)
