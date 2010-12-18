(require 'undo-tree)
(global-undo-tree-mode)

(if (fboundp 'menu-bar-mode) (menu-bar-mode 1))

(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)
