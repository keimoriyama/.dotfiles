;;; init.el:
(when (< emacs-major-version 23)
  (defvar user-emacs-directory "~/.emacs.d/"))

; システムに装飾キー渡さない
(setq mac-pass-control-to-system nil)
(setq mac-pass-command-to-system nil)
(setq mac-pass-option-to-system nil)


(define-key global-map (kbd "C-t") 'other-window)

; 好きなコマンドを割り振ろう
(global-set-key (kbd "C-x C-c") 'magit) ;; 私は helm-M-xにしています

;; C-x C-z(suspend)も変更するのもありでしょう.
(global-set-key (kbd "C-x C-z") 'your-favorite-command)
;; I never use C-x C-c
(defalias 'exit 'save-buffers-kill-emacs)


(column-number-mode t)
(size-indication-mode t)
(setq display-time-24hr-format t)
(display-time-mode t)

(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

(setq frame-title-format "%f")

(global-display-line-numbers-mode 1)

(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

(set-face-attribute 'default nil
                    :family "Menlo"
                    :height 200)

(setq backup-directory-alist
      `((".*".,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory)))

(global-auto-revert-mode t)

(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

(setq mac-command-modifier 'meta)

(add-hook 'emacs-startup-hook
          #'(lambda ()
              (fset 'yes-or-no-p 'y-or-n-p)))

(with-eval-after-load 'comp-run
  ;; config
  (setopt native-comp-async-jobs-number 8)
  (setopt native-comp-speed 3)
  (setopt native-comp-always-compile t))

(with-eval-after-load 'warnings
  ;; config
  (setopt warning-suppress-types '((comp))))

(defun elisp-mode-hooks ()
  "list-mode-hooks"
  (when (require 'eldoc nil t)
    (setq eldoc-idle-delay 0.2)
    (setq eldoc-echo-area-use-multiline-p t)
    (turn-on-eldoc-mode)))
(add-hook 'emacs-lisp-mode-hook 'elisp-mode-hooks)

; <leaf-install-code>
(eval-and-compile
  (customize-set-variable
   'package-archives '(("org" . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu" . "https://elpa.gnu.org/packages/")
                       ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf pretty-hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)
    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init))

(leaf dash
  :ensure t)

(leaf f
  :ensure t)

(leaf nerd-icons-completion
  :ensure t
  :global-minor-mode t)

(defadvice moccur-edit-change-file
    (after save-after-moccur-edit-buffer activate)
  (save-buffer))

(leaf kanagawa-themes
  :ensure t
  :config
  (load-theme 'kanagawa-wave t))

(leaf volatile-highlights
  :ensure t
  :global-minor-mode t)

(leaf undohist
  :ensure t
  :config
  (undohist-initialize))

(cua-mode t)
(setq cua-enable-cua-keys nil)

(leaf projectile
  :ensure t
  :config projectile-mode
  :init (projectile-mode +1)
  :bind (("C-c p" . projectile-command-map)))

(leaf otpp
  :ensure t
  :after project
  :vc (:url "https://github.com/abougouffa/one-tab-per-project")
  :global-minor-mode t)

(leaf expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(leaf multiple-cursors
  :ensure t
  :bind ("M-m" . hydra-multiple-cursors/body)
  :hydra
  (hydra-multiple-cursors (:color pink :hint nil)
"
                                                                        ╔════════╗
    Point^^^^^^             Misc^^            Insert                            ║ Cursor ║
  ──────────────────────────────────────────────────────────────────────╨────────╜
     _k_    _K_    _M-k_    [_l_] edit lines  [_i_] 0...
     ^↑^    ^↑^     ^↑^     [_m_] mark all    [_a_] letters
    mark^^ skip^^^ un-mk^   [_s_] sort        [_n_] numbers
     ^↓^    ^↓^     ^↓^
     _j_    _J_    _M-j_
  ╭──────────────────────────────────────────────────────────────────────────────╯
                           [_q_]: quit, [Click]: point
"
          ("l" mc/edit-lines :exit t)
          ("m" mc/mark-all-like-this :exit t)
          ("j" mc/mark-next-like-this)
          ("J" mc/skip-to-next-like-this)
          ("M-j" mc/unmark-next-like-this)
          ("k" mc/mark-previous-like-this)
          ("K" mc/skip-to-previous-like-this)
          ("M-k" mc/unmark-previous-like-this)
          ("s" mc/mark-all-in-region-regexp :exit t)
          ("i" mc/insert-numbers :exit t)
          ("a" mc/insert-letters :exit t)
          ("n" ladicle/mc/insert-numbers :exit t)
          ("<mouse-1>" mc/add-cursor-on-click)
          ;; Help with click recognition in this hydra
          ("<down-mouse-1>" ignore)
          ("<drag-mouse-1>" ignore)
          ("q" nil)))

(leaf git-gutter
  :ensure t
  :init
  (global-git-gutter-mode))

(leaf rainbow-delimiters
  :ensure t
  :hook
  ((prog-mode-hook . rainbow-delimiters-mode)))

(leaf hl-line
  :init
  (global-hl-line-mode +1))

(leaf elec-pair
  :config
  (electric-pair-mode +1))

(leaf puni
  :ensure t
  :global-minor-mode t
  :bind ("C-c b" . hydra-puni/body)
  :hydra
  (hydra-puni
   (:color red :hint nil)
   "
move parenthes _f_orward  _b_ackward"
   ("f" puni-slurp-forward)
   ("b" puni-slurp-backward)))

(leaf iflipb
  :ensure t
  :bind
  (("M-n" . iflipb-next-buffer)
   ("M-p" . iflipb-previous-buffer)))

(leaf autorevert
  :doc "revert buffers when files on disk change"
  :global-minor-mode global-auto-revert-mode)

(leaf simple
  :doc "basic editing commands for Emacs"
  :custom ((kill-read-only-ok . t)
           (kill-whole-line . t)
           (eval-expression-print-length . nil)
           (eval-expression-print-level . nil)))

(leaf spaceline
  :ensure t
  :config (spaceline-spacemacs-theme))


(leaf startup
  :doc "process Emacs shell arguments"
  :custom `((auto-save-list-file-prefix . ,(locate-user-emacs-file "backup/.saves-"))))

(leaf which-key
  :doc "Display available keybindings in popup"
  :ensure t
  :global-minor-mode t)

(leaf magit
  :ensure t)

(leaf smerge-mode
  :doc "Manage git confliction"
  :ensure t
  :preface
  (defun start-smerge-mode-with-hydra ()
    (interactive)
    (progn
      (smerge-mode 1)
      (smerge-mode/body)))
  :pretty-hydra
  ((:color blue :quit-key "q" :foreign-keys warn)
   ("Move"
    (("n" smerge-next "next")
     ("p" smerge-prev "preview"))
    "Keep"
    (("b" smerge-keep-base "base")
     ("u" smerge-keep-upper "upper")
     ("l" smerge-keep-lower "lower")
     ("a" smerge-keep-all "both")
     ("\C-m" smerge-keep-current "current"))
    "Others"
    (("C" smerge-combine-with-next "combine with next")
     ("r" smerge-resolve "resolve")
     ("k" smerge-kill-current "kill current"))
    "End"
    (("ZZ" (lambda ()
             (interactive)
             (save-buffer)
             (bury-buffer))
      "Save and bury buffer" :color blue)
     ("q" nil "cancel" :color blue)))))

(leaf exec-path-from-shell
  :doc "Get environment variables such as $PATH from the shell"
  :ensure t
  :defun (exec-path-from-shell-initialize)
  :custom ((exec-path-from-shell-check-startup-files)
           (exec-path-from-shell-variables . '("PATH" "GOPATH" "JAVA_HOME")))
  :config
  (exec-path-from-shell-initialize))


(leaf vertico
  :doc "VERTical Interactive COmpletion"
  :ensure t
  :global-minor-mode t)

(leaf marginalia
  :doc "Enrich existing commands with completion annotations"
  :ensure t
  :global-minor-mode t)

(leaf avy
  :doc "Jump to things in tree-style"
  :url "https://github.com/abo-abo/avy"
  :ensure t)

(leaf avy-zap
  :doc "Zap to char using avy"
  :url "https://github.com/cute-jumper/avy-zap"
  :ensure t)

(leaf consult
  :doc "Consulting completing-read"
  :ensure t
  :hook (completion-list-mode-hook . consult-preview-at-point-mode)
  :defun consult-line
  :preface
  (defun c/consult-line (&optional at-point)
    "Consult-line uses things-at-point if set C-u prefix."
    (interactive "P")
    (if at-point
        (consult-line (thing-at-point 'symbol))
      (consult-line)))
  :custom ((xref-show-xrefs-function . #'consult-xref)
           (xref-show-definitions-function . #'consult-xref)
           (consult-line-start-from-top . t))
  :bind (;; C-c bindings (mode-specific-map)
         ([remap switch-to-buffer] . consult-buffer) ; C-x b
         ([remap project-switch-to-buffer] . consult-project-buffer) ; C-x p b
         ("C-x C-b" . consult-buffer-other-tab)
         ;; M-g bindings (goto-map)i
         ([remap goto-line] . consult-goto-line)    ; M-g g
         ([remap imenu] . consult-imenu)            ; M-g i

         ;; C-M-s bindings
         ("C-M-s" . nil)                ; isearch-forward-regexp
         ("C-M-s s" . isearch-forward)
         ("C-M-s C-s" . isearch-forward-regexp)
         ("C-M-s r" . consult-ripgrep)

         (minibuffer-local-map
          :package emacs
          ("C-r" . consult-history))))

(leaf affe
  :doc "Asynchronous Fuzzy Finder for Emacs"
  :ensure t
  :custom ((affe-highlight-function . 'orderless-highlight-matches)
           (affe-regexp-function . 'orderless-pattern-compiler)))

(leaf orderless
  :doc "Completion style for matching regexps in any order"
  :ensure t
  :custom ((completion-styles . '(orderless partial-completion basic))
           (completion-category-defaults . nil)
           (completion-category-overrides . nil)))


(leaf embark-consult
  :doc "Consult integration for Embark"
  :ensure t
  :bind ((("M-." . embark-dwim)
          ("C-." . embark-act))))

(leaf tempel
  :ensure t
  :doc "template engine"
  :init
  (defun tempel-setup-capf ()
    (setq-local completion-at-point-functions
                (cons #'tempel-complete
                      completion-at-point-functions)))
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf)
  (add-hook 'org-mode-hook 'tempel-setup-capf))

(leaf yasnippet
  :ensure t
  :doc "snippet engine"
  :init
  (yas-global-mode +1)
  :bind ((yas-keymap
         ("<tab>" . nil)
         ("TAB" . nil)
         ("<backtab>" . nil)
         ("S-TAB" . nil)
         ("M-}" . yas-next-field-or-maybe-expand)
         ("M-{" . yas-prev-field))))

(leaf shell-pop
  :ensure t
  :bind (("C-c s" . shell-pop)))

(leaf corfu
  :doc "COmpletion in Region FUnction"
  :ensure t
  :global-minor-mode global-corfu-mode corfu-popupinfo-mode
  :custom ((corfu-auto . t)
           (corfu-auto-delay . 0)
           (corfu-cycle . t)
           (corfu-auto-prefix . 3)
           (text-mode-ispell-word-completion . nil))
  :bind ((corfu-map
          ("C-s" . corfu-insert-separator))))

(leaf corfu-popupinfo
  :ensure nil
  :after corfu
  :hook (corfu-mode-hook . corfu-popupinfo-mode)
  :config
  (setq-local corfu-popupinfo-delay 0.2))

(leaf nerd-icons-corfu
  :ensure t
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(leaf cape
  :doc "Completion At Point Extensions"
  :ensure t
  :hook
  ((prog-mode
     text-mode
     conf-mode
     lsp-completion-mode
     yatex-mode))
  :config
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'tempel-complete)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-keyword))

(leaf org-bullets
  :vc (:url "https://github.com/sabof/org-bullets")
  :hook (org-mode-hook . (lambda () (org-bullets-mode t))))

(leaf org
  :init
  (setq org-directory "~/Documents/org-mode"
        org-daily-tasks-file (format "%s/tasks.org" org-directory)
        org-memo-file (format "%s/memo.org" org-directory)
        org-main-file (format "%s/main.org" org-directory)
        org-exp-file (format "%s/exp.org" org-directory)
        org-memo-dir (format "%s/memo/" org-directory))
  (setq org-agenda-files (list org-directory))
  (defun my:org-goto-inbox ()
    (interactive)
    (find-file org-main-file))
  (defun my:org-goto-memo ()
    (interactive)
    (find-file org-memo-file))
  (defun my:org-goto-exp ()
    (interactive)
    (find-file org-exp-file))
  :bind
  (("C-c e" . my:org-goto-exp)
   ("C-c a" . org-agenda)
   ("C-c c" . org-capture)
   ("C-c i" . my:org-goto-inbox)
   ("C-c m" . my:org-goto-memo))
  :config
  (setq org-startup-folded 'content)
  (setq org-startup-indented "indent")
  (setq org-capture-templates
    '(("m" "Memo" entry (file org-memo-file) "** %U\n%?\n" :empty-lines 1)
      ("t" "Tasks" entry (file org-main-file) "** TODO %?")
      ("e" "Experiment" entry (file org-exp-file) "\n* %? \n** 目的 \n- \n** やること\n*** \n** 結果\n-")))
  (setq org-startup-folded nil)
  (setq org-refile-targets '((org-agenda-files :maxlevel . 1)))
  (setq org-todo-keywords
        '((sequence "TODO" "DOING" "|" "DONE" "WAIT"))))

  (leaf org-agenda
  :commands org-agenda
  :config
  (setq org-agenda-custom-commands
        '(("x" "Unscheduled Tasks" tags-todo
           "-SCHEDULED>=\"<today>\"-DEADLINE>=\"<today>\"" nil)
          ("d" "Daily Tasks" agenda ""
           ((org-agenda-span 1)))))
  (setq org-agenda-skip-scheduled-if-done t)
  (setq org-return-follows-link t)  ;; RET to follow link
  (setq org-agenda-columns-add-appointments-to-effort-sum t)
  (setq org-agenda-time-grid
        '((daily today require-timed)
          (0900 1200 1300 1800) "......" "----------------"))
  (setq org-columns-default-format
        "%68ITEM(Task) %6Effort(Effort){:} %6CLOCKSUM(Clock){:}")
  (defadvice org-agenda-switch-to (after org-agenda-close)
    "Close a org-agenda window when RET is hit on the window."
    (progn (delete-other-windows)
           (recenter-top-bottom)))
  (ad-activate 'org-agenda-switch-to)
  :bind
  (org-agenda-mode-map
        ("s" . org-agenda-schedule)
        ("S" . org-save-all-org-buffers)))

(leaf org-journal
  :ensure t
  :bind
  ("C-c j" . org-journal-new-entry)
  :init
  (setq org-journal-dir "~/Documents/org-mode/journal")
  (setq org-journal-file-format "week-%V-%Y%m%d.org")
  (setq org-journal-file-type 'weekly)
  (setq org-journal-start-on-weekday 3))

(leaf ox-gfm
  :ensure t)

; lsp client
(leaf eglot
  :doc "The Emacs Client for LSP servers"
  :pretty-hydra
  ((:title "LSP" :color blue :quit-key "q" :foreign-keys warn :separator "╌")
   ("ref"
    (("d" xref-find-definitions "goto definitions")
     ("r" xref-find-references "find references")
     ("b" xref-go-back "go back to previous location"))))
  :bind
  (("C-c l" . eglot/body))
  :hook
  ((python-mode-hook
    js-mode-hook) . eglot-ensure)
  :custom ((eldoc-echo-area-use-multiline-p . nil)
           (eglot-connect-timeout . 600))
  :config
  (defun my/eglot-capf ()
    (setq-local completion-at-point-functions
                (list (cape-capf-super
                       #'tempel-complete
                       #'eglot-completion-at-point)
                      #'cape-keyword
                      #'cape-dabbrev
                      #'cape-file)
                ))
  (add-hook 'eglot-managed-mode-hook #'my/eglot-capf))


(leaf emacs-lsp-booster
  :vc (:url "https://github.com/blahgeek/emacs-lsp-booster")
  :ensure t)

(leaf eglot-booster
  :when (executable-find "emacs-lsp-booster")
  :ensure t
  :vc ( :url "https://github.com/jdtsmith/eglot-booster")
  :global-minor-mode t)

;(defun my/lsp-mode-completion ()
;    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
;          '(orderless)))

;(leaf lsp-mode
;  :ensure t
;  :hook
;  (python-mode-hook . lsp-mode)
;  :bind
;  (("C-c d" . xref-find-definitions)
;   ("C-c r" . xref-find-references))
;  :hook
;  (lsp-completion-mode-hook . my/lsp-mode-completion)
;  :config
;  (setq lsp-enable-file-watchers nil)
;  (setq lsp-file-watch-threshold 500)
;  (setq lsp-completion-provider :none))
; 
;(leaf lsp-ui
;  :ensure t
;  :hook (lsp-mode-hook . lsp-ui-mode)
;  :config
;  (setq lsp-ui-doc-enable nil)
;  (setq lsp-ui-doc-include-signature nil)
;  (setq lsp-ui-doc-position 'at-point) ;; top, bottom, or at-point
;  (setq lsp-ui-doc-max-width 120)
;  (setq lsp-ui-doc-max-height 30)
;  (setq lsp-ui-doc-use-childframe t)
;  (setq lsp-ui-doc-use-webkit t)
;;setq ; lsp-ui-flycheck
;  (setq lsp-ui-flycheck-enable nil)
;;setq ; lsp-ui-sideline
;  (setq lsp-ui-sideline-enable nil)
;  (setq lsp-ui-sideline-ignore-duplicate t)
;  (setq lsp-ui-sideline-show-symbol t)
;  (setq lsp-ui-sideline-show-hover t)
;  (setq lsp-ui-sideline-show-diagnostics nil)
;  (setq lsp-ui-sideline-show-code-actions t)
;  (setq lsp-ui-sideline-code-actions-prefix "")
;;setq ; lsp-ui-imenu
;  (setq lsp-ui-imenu-enable t)
;  (setq lsp-ui-imenu-kind-position 'top)
;;setq ; lsp-ui-peek
;  (setq lsp-ui-peek-enable t)
;  (setq lsp-ui-peek-peek-height 20)
;  (setq lsp-ui-peek-list-width 50)
;  (setq lsp-ui-peek-fontify 'on-demand))

;(leaf dap-mode
;  :ensure t
;  :init
;  (dap-mode t))
;
;(leaf dap-ui
;  :hook
;  (dap-mode-hook . dap-ui-mode))

; grammar check
(leaf flycheck
  :ensure t
  :global-minor-mode global-flycheck-mode)

(leaf highlight-indent-guides
  :ensure t
  :hook ((prog-mode-hook yaml-mode-hook) . highlight-indent-guides-mode))

; Python
(leaf python-mode
  :ensure t)

(leaf pet
  :ensure t
  :hook
  (python-mode-hook . (lambda () (pet-mode -10)
  (setq-local python-shell-interpreter (pet-executable-find "python"))
  (setq-local python-shell-virtualenv-root (pet-virtualenv-root))
  (pet-flycheck-setup)
  (setq-local lsp-pyright-venv-path python-shell-virtualenv-root)
  (setq-local lsp-pyright-python-executable-cmd python-shell-interpreter)
  (setq-local python-black-command (pet-executable-find "black"))
  (setq-local blacken-executable python-black-command)
  (pet-eglot-setup))))

(leaf lsp-pyright
  :ensure t)

(leaf python-black
  :ensure t
  :hook (python-mode-hook . python-black-on-save-mode-enable-dwim))

;(leaf ein
;  :ensure t)
;;; undoを有効化 (customizeから設定しておいたほうが良さげ)
;(setq ein:worksheet-enable-undo t)
;;; 画像をインライン表示 (customizeから設定しておいたほうが良さげ)
;(setq ein:output-area-inlined-images t)
;(declare-function ein:format-time-string "ein-utils")
;(declare-function smartrep-define-key "smartrep")
; yaml
(leaf yaml-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode)))

;docker
(leaf dockerfile-mode
  :ensure t)

(leaf git-modes
  :ensure t)

; Latex
(leaf yatex
  :doc "new latex mode"
  :ensure t
  :commands (yatex-mode)
  :mode (("\\.tex$" . yatex-mode)
           ("\\.ltx$" . yatex-mode)
           ("\\.cls$" . yatex-mode)
           ("\\.sty$" . yatex-mode)
           ("\\.clo$" . yatex-mode)
           ("\\.bbl$" . yatex-mode)
           ("\\.bib$" . yatex-mode))
    :init
    (setq YaTeX-inhibit-prefix-letter t)
    (setq YaTeX-dvi2-command-ext-alist
    '(("Skim" . ".pdf")))
  (setq dvi2-command "open -a Skim")
  (setq tex-pdfview-command "open -a Skim"))

(leaf flyspell
  ;; flyspellをインストールする
  :ensure t
  ;; YaTeXモードでflyspellを使う
  :hook (yatex-mode-hook . flyspell-mode))

(leaf reftex
    :ensure t
    :after yatex
    :hook (yatex-mode-hook . reftex-mode)
    :bind (reftex-mode-map
                ("C-c (" . reftex-reference)
                ("C-c )" . nil)
                ("C-c >" . YaTeX-comment-region)
                ("C-c <" . YaTeX-uncomment-region))
    :config
    (print (projectile-project-root))
    (setq reftex-default-bibliography (directory-files-recursively
                                       (projectile-project-root) "\\.bib$")))

(leaf ispell
    :ensure t
    :after yatex
    :init
    (setq ispell-local-dictionary "en_US")
    ;; スペルチェッカとしてaspellを使う
    (setq ispell-program-name "aspell")
    :config
    ;; 日本語の部分を飛ばす
    (add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))


(leaf *hydra-goto2
  :doc "Search and move cursor"
  :bind ("M-j" . *hydra-goto2/body)
  :pretty-hydra
  ((:title "↗ Goto" :color blue :quit-key "q" :foreign-keys warn :separator "╌")
   ("Got"
    (("i" avy-goto-char       "char")
     ("t" avy-goto-char-timer "timer")
     ("l" avy-goto-line       "line")
     ("j" avy-resume          "resume"))
    "Line"
    (("h" avy-goto-line        "head")
     ("e" avy-goto-end-of-line "end")
     ("n" consult-goto-line    "number"))
    "Topic"
    (("o"  consult-outline      "outline")
     ("m"  consult-imenu        "imenu")
     ("gm" consult-global-imenu "global imenu"))
    "Error"
    ((","  lsp-bridge-diagnostic-jump-prev "previous")
     ("."  lsp-bridge-diagnostic-jump-next "next")
     ("L"  lsp-bridge-diagnostic-list "list"))
    "Spell"
    ((">"  flyspell-goto-next-error "next" :exit nil)
     ("cc" flyspell-correct-at-point "correct" :exit nil)))))

(leaf *hydra-toggle2
  :doc "Toggle functions"
  :bind ("M-t" . *hydra-toggle2/body)
  :pretty-hydra
  ((:title " Toggle" :color blue :quit-key "q" :foreign-keys warn :separator "-")
   ("Basic"
    (("v" view-mode "view mode" :toggle t)
     ("w" whitespace-mode "whitespace" :toggle t)
     ("W" whitespace-cleanup "whitespace cleanup")
     ("r" rainbow-mode "rainbow" :toggle t)
     ("b" beacon-mode "beacon" :toggle t))
    "Line & Column"
    (("l" toggle-truncate-lines "truncate line" :toggle t)
     ("n" display-line-numbers-mode "line number" :toggle t)
     ("F" display-fill-column-indicator-mode "column indicator" :toggle t)
     ("f" visual-fill-column-mode "visual column" :toggle t)
     ("c" toggle-visual-fill-column-center "fill center"))
    "Highlight"
    (("h" highlight-symbol "highligh symbol" :toggle t)
     ("L" hl-line-mode "line" :toggle t)
     ("t" hl-todo-mode "todo" :toggle t)
     ("g" git-gutter-mode "git gutter" :toggle t)
     ("i" highlight-indent-guides-mode "indent guide" :toggle t))
    "Window"
    (("t" toggle-window-transparency "transparency" :toggle t)
     ("m" toggle-window-maximize "maximize" :toggle t)
     ("p" presentation-mode "presentation" :toggle t)))))
(leaf *hydra-toggle-markdown1
  :doc "Toggle functions for Markdown"
  :bind
  (:markdown-mode-map
   :package markdown-mode
   ("M-t" . *hydra-toggle-markdown1/body))
  :pretty-hydra
  ((:title " Toggle" :color blue :quit-key "q" :foreign-keys warn :separator "╌")
   ("Basic"
    (("w" whitespace-mode "whitespace" :toggle t)
     ("W" whitespace-cleanup "whitespace cleanup")
     ("l" hl-line-mode "line" :toggle t)
     ("g" git-gutter-mode "git gutter" :toggle t))
    "Markdown"
    (("v" markdown-view-mode "view mode")
     ("u" markdown-toggle-markup-hiding "markup hiding" :toggle t)
     ("l" markdown-toggle-url-hiding "url hiding" :toggle t))
    "Line & Column"
    (("l" toggle-truncate-lines "truncate line" :toggle t)
     ("i" display-fill-column-indicator-mode "column indicator" :toggle t)
     ("c" visual-fill-column-mode "visual column" :toggle t))
    "Window"
    (("t" toggle-window-transparency "transparency" :toggle t)
     ("m" toggle-window-maximize "maximize" :toggle t)
     ("p" presentation-mode "presentation" :toggle t)))))

(leaf *hydra-search
  :doc "Search functions"
  :bind
  ("C-s" . *hydra-search/body)
  :pretty-hydra
  ((:title "🔍 Search" :color blue :quit-key "q" :foreign-keys warn :separator "╌")
   ("Buffer"
    (("l" consult-line "line")
     ("o" consult-outline "outline")
     ("m" consult-imenu "imenu"))
    "Project"
    (("f" affe-find "find")
     ("r" consult-ripgrep "grep")
     ("R" affe-grep "affe"))
    "Document"
    (("df" consult-find-doc "find")
     ("dd" consult-grep-doc "grep")))))

(leaf *hydra-git
  :bind
  ("M-g" . *hydra-git/body)
  :pretty-hydra
  ((:title " Git" :color blue :quit-key "q" :foreign-keys warn :separator "╌")
   ("Basic"
    (("w" magit-checkout "checkout")
     ("s" magit-status "status")
     ("b" magit-branch "branch")
     ("F" magit-pull "pull")
     ("f" magit-fetch "fetch")
     ("A" magit-apply "apply")
     ("c" magit-commit "commit")
     ("P" magit-push "push"))
    ""
    (("d" magit-diff "diff")
     ("l" magit-log "log")
     ("r" magit-rebase "rebase")
     ("z" magit-stash "stash")
     ("!" magit-run "run shell command")
     ("y" magit-show-refs "references"))
    "Hunk"
    (("," git-gutter:previous-hunk "previous" :exit nil)
     ("." git-gutter:next-hunk "next" :exit nil)
     ("g" git-gutter:stage-hunk "stage")
     ("v" git-gutter:revert-hunk "revert")
     ("p" git-gutter:popup-hunk "popup"))
    " GitHub"
    (("C" checkout-gh-pr "checkout PR")
     ("o" browse-at-remote-or-copy"browse at point")
     ("k" browse-at-remote-kill "copy url")
     ("O" (shell-command "hub browse") "browse repository")))))

(leaf ddskk
  :ensure t
  :doc "japanese IME works in emacs"
  :bind (("C-x C-j" . skk-mode))
  :hook (skk-load-hook . (lambda () (corfu-mode -1)))
  :init
    ;(setq skk-server-portnum 1178)
    ;(setq skk-server-host "localhost")
    (setq skk-jisyo "~/Google Drive/マイドライブ/skk-jisyo.utf-8")
    ;(setq skk-user-directory "~/.cache/skk")
    (setq skk-large-jisyo "~/.cache/skk/SKK-JISYO.L")
    (setq skk-use-azik t)
    (setq skk-search-katakana t)
    (setq skk-preload t)
    (setq skk-share-private-jisyo t))
;; </leaf-install-code>
)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(lsp-completion-provider :none)
 '(package-selected-packages
   '(affe avy avy-zap cape consult corfu ddskk dockerfile-mode
          eglot-booster emacs-lsp-booster embark-consult
          exec-path-from-shell expand-region flycheck flyspell
          git-gutter git-modes highlight-indent-guides iflipb ispell
          lsp-booster lsp-pyright magit marginalia multiple-cursors
          nerd-icons-corfu one-tab-per-project orderless org-bullets
          org-journal otpp ox-gfm pet puni python-black python-mode
          rainbow-delimiters reftex shell-pop smerge-mode spaceline
          tempel undohist vertico volatile-highlights which-key
          yaml-mode yasnippet yatex))
 '(package-vc-selected-packages
   '((one-tab-per-project :url
                          "https://github.com/abougouffa/one-tab-per-project")
     (lsp-booster :vc-backend Git :url
                  "https://github.com/blahgeek/emacs-lsp-booster")
     (eglot-booster :url "https://github.com/jdtsmith/eglot-booster")
     (emacs-lsp-booster :url
                        "https://github.com/blahgeek/emacs-lsp-booster")
     (org-bullets :url "https://github.com/sabof/org-bullets")))
 '(skk-jisyo-edit-user-accepts-editing t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
