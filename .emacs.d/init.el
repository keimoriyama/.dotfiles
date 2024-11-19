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

(server-start)
(column-number-mode -1)
(scroll-bar-mode -1)
(size-indication-mode t)
(setq display-time-24hr-format t)
(display-time-mode t)

(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

(setq frame-title-format "%f")


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
)

(leaf tab-bar-mode
  :custom
  ((tab-bar-new-button-show . nil)
   (tab-bar-close-button-show . nil)))

(leaf bufferlo
  :ensure t
  :global-minor-mode bufferlo-mode t)

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

(leaf centaur-tabs
  :ensure t
  :global-minor-mode centaur-tabs-mode
  :custom
  ((centaur-tabs-set-icons . t)
   (centaur-tabs-cycle-scope . 'tabs)))

(leaf *hydra-moves
  :bind ("C-c m" . *hydra-moves/body)
  :pretty-hydra
  ((:title "Moves":color blue :quit-key "q":foreign-keys warn :separator "╌" )
   ("Buffer"
    (("f" centaur-tabs-forward "forward" :exit nil)
     ("b" centaur-tabs-backward "backward" :exit nil))
    "Tabs"
    (("n" tab-next "next" :exit nil)
     ("p" tab-previous "previous" :exit nil)))))

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
  :custom
  ((projectile-sort-order . 'recently-active))
  :bind (("C-c p" . projectile-command-map)))

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
    mark^^ skip^^^ un-mk^   [_s_] sort
     ^↓^    ^↓^     ^↓^
     _j_    _J_    _M-j_
  ╭──────────────────────────────────────────────────────────────────────────────╯
                           [_q_]: quit, [Click]: point
"
          ("l" mc/edit-lines :exit t)
          ("m" mc/mark-all-like-this :exit t)
          ("j" mc/mark-next-symbol-like-this)
          ("J" mc/skip-to-next-like-this)
          ("M-j" mc/unmark-next-like-this)
          ("k" mc/mark-previous-symbol-like-this)
          ("K" mc/skip-to-previous-like-this)
          ("M-k" mc/unmark-previous-like-this)
          ("s" mc/mark-all-in-region-regexp :exit t)
          ("i" mc/insert-numbers :exit t)
          ("a" mc/insert-letters :exit t)
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
  :bind ("C-c b" . hydra-puni/body)
  :global-minor-mode puni-global-mode
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
           (exec-path-from-shell-variables . '("PATH" "GOPATH" "JAVA_HOME" "PKG_CONFIG_PATH" "CPPFLAGS" "LDFLAGS")))
  :config
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "PATH"))

(leaf corfu
  :doc "COmpletion in Region FUnction"
  :ensure t
  :global-minor-mode global-corfu-mode corfu-popupinfo-mode
  :custom ((corfu-auto . t)
           (corfu-auto-delay . 0.1)
           (corfu-cycle . t)
           (corfu-auto-prefix . 3)
           (text-mode-ispell-word-completion . nil))
  :bind ((corfu-map
          ("C-s" . corfu-insert-separator))))

(leaf corfu-popupinfo
  :ensure nil
  :after corfu
  :config
  (setq-local corfu-popupinfo-delay 0))

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

(defvar my-consult--source-local-buffer
  `(:name "Local Buffers"
    :narrow   ?l
    :category buffer
    :face     consult-buffer
    :history  buffer-name-history
    :state    ,#'consult--buffer-state
    :default  t
    :items ,(lambda () (consult--buffer-query
                        :predicate #'bufferlo-local-buffer-p
                        :sort 'visibility
                        :as #'buffer-name)))
  "Local buffer candidate source for `consult-buffer'.")

(leaf consult
  :doc "Consulting completing-read"
  :ensure t
  :hook (completion-list-mode-hook . consult-preview-at-point-mode)
  :defun consult-line
  :bind ("C-x b" . consult-buffer)
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
  :config
  (setq consult-buffer-sources '(consult--source-hidden-buffer
                                 my-consult--source-local-buffer)))

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
         ("M-{" . yas-prev-field)))
  :bind
  ("C-c y" . yasnippet/body)
  :pretty-hydra
  ((:title "snippet" :color blue :quit-key "q" :foreign-keys warn :separator "╌")
   ("Basic"
    (("a" yas-new-snippet "add new snippet")
     ("i" yas-insert-snippet "insert snippet")
     ("e" yas-visit-snippet-file "edit snippet")))))

(leaf shell-pop
  :ensure t
  :bind (("C-c s" . shell-pop)))

;; (leaf org-bullets
;;   :vc (:url "https://github.com/sabof/org-bullets")
;;   :hook (org-mode-hook . (lambda () (org-bullets-mode t))))
(leaf org-modern
  :vc (:url "https://github.com/jdtsmith/org-modern-indent")
  :ensure t
  :hook (org-mode-hook . org-modern-mode))

(leaf org-pomodoro
  :ensure t)

(setq org-directory "~/Documents/org-mode"
        org-memo-file (format "%s/memo.org" org-directory)
        org-main-file (format "%s/main.org" org-directory)
        org-exp-file (format "%s/exp.org" org-directory)
        org-memo-dir (format "%s/memo/" org-directory))

(defun my:org-goto-inbox ()
    (interactive)
    (find-file org-main-file))
(defun my:org-goto-memo ()
    (interactive)
    (find-file org-memo-file))
(defun my:org-goto-exp ()
    (interactive)
    (find-file org-exp-file))

(leaf org
  :init
  (setq org-agenda-files (list org-directory))
  :custom
  (org-startup-folded . 'content)
  (org-startup-indented . "indent")
  (org-capture-templates .
    '(("m" "Memo" entry (file org-memo-file) "** %U\n%?\n" :empty-lines 1)
      ("t" "Tasks" entry (file org-main-file) "** TODO %?")
      ("e" "Experiment" entry (file org-exp-file) "\n* %? \n** 目的 \n- \n** やること\n*** \n** 結果\n-")))
  (org-startup-folded . nil)
  (org-refile-targets . '((org-agenda-files :maxlevel . 1)))
  (org-todo-keywords .
                     '((sequence "TODO" "DOING" "|" "DONE" "WAIT"))))
  
  (leaf org-agenda
  :commands org-agenda
  :custom
  ((org-agenda-custom-commands .
        '(("x" "Unscheduled Tasks" tags-todo
           "-SCHEDULED>=\"<today>\"-DEADLINE>=\"<today>\"" nil)
          ("d" "Daily Tasks" agenda ""
           ((org-agenda-span 1)))))
  (org-agenda-start-on-weekday . 3)
  (org-agenda-span . 'week)
  (org-agenda-skip-scheduled-if-done . t)
  (org-return-follows-link . t)  ;; RET to follow link
  (org-agenda-columns-add-appointments-to-effort-sum . t)
  (org-agenda-time-grid .
                        '((daily today require-timed)
                          (0900 1200 1300 1800) "......" "----------------"))
  (org-columns-default-format . 
                              "%68ITEM(Task) %6Effort(Effort){:} %6CLOCKSUM(Clock){:}")
  (org-clock-out-remove-zero-time-clocks . t)
  (org-clock-clocked-in-display          . 'both)
  (org-agenda-start-with-log-mode        . t))
  :bind
  (org-agenda-mode-map
        ("s" . org-agenda-schedule)
        ("S" . org-save-all-org-buffers)))

(leaf org-journal
  :ensure t
  :bind
  ("C-c j" . org-journal-new-entry)
  :custom
  ((org-journal-dir . "~/Documents/org-mode/journal")
  (org-journal-file-format . "week-%V-%Y%m%d.org")
  (org-journal-file-type . 'weekly)
  (org-journal-start-on-weekday . 3)))

(leaf ox-gfm
  :ensure t
  :after org)

(leaf *hydra-org
  :bind ("C-c o". *hydra-org/body)
  :pretty-hydra
  ((:title "org mode":color blue :quit-key "q" :foreign-keys warn :separator "╌")
   ("visit file"
    (("e" my:org-goto-exp "experiment")
     ("i" my:org-goto-main "inbox")
     ("m" my:org-goto-memo "memo")
     ("j" org-journal-open-current-journal-file "current journal"))
    "agenda"
    (("a" org-agenda "open agenda")
     ("c" org-capture "capture")))))

; lsp client
;; (leaf eglot
;;   :doc "The Emacs Client for LSP servers"
;;   :hook
;;   ((js-mode-hook) . eglot-ensure)
;;   :custom ((eldoc-echo-area-use-multiline-p . nil)
;;            (eglot-connect-timeout . 600))
;;   :config
;;   (defun my/eglot-capf ()
;;     (setq-local completion-at-point-functions
;;                 (list (cape-capf-super
;;                        #'tempel-complete
;;                        #'eglot-completion-at-point)
;;                       #'cape-keyword
;;                       #'cape-dabbrev
;;                       #'cape-file)))
;;  (add-hook 'eglot-managed-mode-hook #'my/eglot-capf))

;; (leaf *hydra-eglot
;;   :bind
;;   (("C-c l" . hydra-eglot/body))
;;   :pretty-hydra
;;   ((:title "LSP" :color blue :quit-key "q" :foreign-keys warn :separator "╌")
;;    ("ref"
;;     (("d" xref-find-definitions "goto definitions")
;;      ("r" xref-find-references "find references")
;;      ("b" xref-go-back "go back to previous location")))))


(leaf emacs-lsp-booster
  :vc (:url "https://github.com/blahgeek/emacs-lsp-booster")
  :ensure t)

;; (leaf eglot-booster
;;   :when (executable-find "emacs-lsp-booster")
;;   :ensure t
;;   :vc ( :url "https://github.com/jdtsmith/eglot-booster")
;;   :global-minor-mode t)

(defun my/lsp-mode-completion ()
   (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
         '(orderless)))

(leaf lsp-mode
 :ensure t
 :hook
 (python-mode-hook . lsp-mode)
 :hook
 (lsp-completion-mode-hook . my/lsp-mode-completion)
 :custom
 (lsp-enable-file-watchers . nil)
 (lsp-file-watch-threshold . 500)
 (lsp-completion-provider . :none))

(leaf lsp-ui
 :ensure t
 :hook (lsp-mode-hook . (lsp-ui-mode lsp-ui-imenu-mode))
 :bind
 ("C-c l" . lsp-ui/body)
 :pretty-hydra
  ((:title "LSP" :color blue :quit-key "q" :foreign-keys warn :separator "╌")
   ("peek"
    (("d" lsp-ui-peek-find-definitions "definitions")
     ("r" lsp-ui-peek-find-references "references")
     ("b" xref-go-back "go back to previous location"))))
 :custom
 (lsp-ui-sideline-show-diagnostics . t)
 (lsp-ui-sideline-show-code-actions . t)
 (lsp-ui-sideline-update-mode . t)
 (lsp-ui-doc-enable . nil)
 (lsp-ui-imenu-auto-refresh . t))

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
  (python-mode-hook . (lambda () (pet-mode)
                       (setq-local python-shell-interpreter (pet-executable-find "python"))
                       (setq-local python-shell-virtualenv-root (pet-virtualenv-root))
                       (setq-local lsp-pyright-venv-path python-shell-virtualenv-root)
                       (setq-local lsp-pyright-python-executable-cmd python-shell-interpreter)
                       (setq-local python-black-command (pet-executable-find "black"))
                       (setq-local blacken-executable python-black-command)
                       (pet-flycheck-setup)
                       ;(eglot-ensure)
                       ;(pet-eglot-setup)
                       )))
                        
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
  :custom
    (( YaTeX-inhibit-prefix-letter . t)
     ( YaTeX-dvi2-command-ext-alist .
     '(("Skim" . ".pdf")))
     ( dvi2-command . "open -a Skim")
     ( tex-pdfview-command . "open -a Skim")))

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
    ( reftex-default-bibliography (directory-files-recursively
                                       (projectile-project-root) "\\.bib$")))

;; (leaf ispell
;;     :ensure t
;;     :after yatex
;;     :init
;;     ( ispell-local-dictionary "en_US")
;;     ;; スペルチェッカとしてaspellを使う
;;     ( ispell-program-name "aspell")
;;     :config
;;     ;; 日本語の部分を飛ばす
;;     (add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))

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
;  :hook (skk-load-hook . (lambda () (corfu-mode -1)))
  :init
    ;(setq skk-server-portnum 1178)
    ;(setq skk-server-host "localhost")
    (setq skk-jisyo "~/Documents/skk-jisyo.utf-8")
    ;(setq skk-user-directory "~/.cache/skk")
    (setq skk-large-jisyo "~/.cache/skk/SKK-JISYO.L")
    (setq skk-use-azik t)
    (setq skk-search-katakana t)
    (setq skk-preload t)
    (setq skk-share-private-jisyo t))

;; </leaf-install-code>)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(org-modern-indent ddskk reftex flyspell yatex dockerfile-mode yaml-mode python-black lsp-pyright pet python-mode highlight-indent-guides flycheck eglot-booster emacs-lsp-booster ox-gfm org-journal org-bullets shell-pop yasnippet tempel embark-consult orderless affe consult avy-zap avy marginalia vertico cape nerd-icons-corfu corfu exec-path-from-shell smerge-mode magit which-key spaceline iflipb puni rainbow-delimiters git-gutter multiple-cursors expand-region projectile undohist volatile-highlights centaur-tabs kanagawa-themes nerd-icons-completion f dash blackout el-get pretty-hydra hydra leaf-keywords leaf))
 '(package-vc-selected-packages
   '((eglot-booster :url "https://github.com/jdtsmith/eglot-booster")
     (emacs-lsp-booster :url "https://github.com/blahgeek/emacs-lsp-booster")
     (org-bullets :url "https://github.com/sabof/org-bullets"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
