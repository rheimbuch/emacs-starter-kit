;; Load Scala Mode

(add-to-list 'load-path (concat dotfiles-dir "ryan/scala-mode"))

(require 'scala-mode-auto)

(defun scala-turn-off-indent-tabs-mode ()
  (setq indent-tabs-mode nil))
(add-hook 'scala-mode-hook 'scala-turn-off-indent-tabs-mode)
