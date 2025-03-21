;;; init.el:
(require 'org)
(defvar my-config-dir user-emacs-directory)
(org-babel-load-file (expand-file-name "my-init.org" my-config-dir))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(ddskk reftex flyspell yatex dockerfile-mode yaml-mode lsp-pyright pet ruff-format python-mode highlight-indent-guides flycheck lsp-ui lsp-mode emacs-lsp-booster org-modern ox-gfm yasnippet tempel orderless affe embark-consult embark consult avy-zap avy marginalia vertico cape nerd-icons-corfu corfu exec-path-from-shell smerge-mode magit which-key spaceline iflipb puni free-keys rainbow-delimiters git-gutter multiple-cursors expand-region bufferlo centaur-tabs projectile volatile-highlights solarized-theme nerd-icons-completion f dash blackout el-get pretty-hydra hydra leaf-keywords leaf))
 '(package-vc-selected-packages
   '((emacs-lsp-booster :url "https://github.com/blahgeek/emacs-lsp-booster"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
