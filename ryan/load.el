
(require 'undo-tree)
(global-undo-tree-mode)

(if (fboundp 'menu-bar-mode) (menu-bar-mode 1))

(require 'smex)
(smex-initialize)
;; Use SMEX for M-x
(global-set-key "\M-x" 'smex)
(global-set-key "\M-X" 'smex-major-mode-commands)
(global-set-key "\C-x\C-m" 'smex)
(global-set-key "\C-c\C-m" 'smex)

;; Old M-x function
(global-set-key "\C-c\C-c\C-m" 'execute-extended-command)

;; Disable auto searching for file in IDO
(setq ido-auto-merge-delay-time 99999)

(define-key ido-file-dir-completion-map (kbd "C-c C-s")
  (lambda ()
    (interactive)
    (ido-initiate-auto-merge (current-buffer))))
