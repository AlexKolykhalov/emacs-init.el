(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Auto completion
(setq completion-ignore-case t)
(setq tab-always-indent 'complete)

;; Eldoc
(setq eldoc-echo-area-use-multiline-p nil)

;; google-chrome browser by default (open html file C-v)
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome-stable")

;; disable lockfiles & disable emacs autosave & lockfiles
(setq tramp-auto-save-directory "~/.emacs.d/auto-save-list")
(setq make-backup-files nil)
;; (setq create-lockfiles nil)

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  (corfu-history-mode)
  :custom
  (corfu-preview-current nil)
  (corfu-on-exact-match 'show)
  :config
  (setq corfu-max-width 200)
  :bind
  (:map corfu-map
	("C-n" . corfu-next)
	("C-p" . corfu-previous))
  )

(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  (add-to-list 'completion-at-point-functions #'cape-history)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-abbrev)
  ;; Bind dedicated completion commands
  ;; Alternative prefix keys: C-c p, M-p, M-+, ...
  :bind (("C-c p p" . completion-at-point) ;; capf
         ("C-c p t" . complete-tag)        ;; etags
         ("C-c p d" . cape-dabbrev)        ;; or dabbrev-completion
         ("C-c p h" . cape-history)
         ("C-c p f" . cape-file)
         ("C-c p k" . cape-keyord)
         ("C-c p s" . cape-elisp-symbol)
         ("C-c p e" . cape-elisp-block)
         ("C-c p a" . cape-abbrev)
         ("C-c p l" . cape-line)
         ("C-c p w" . cape-dict)
         ("C-c p :" . cape-emoji)
         ("C-c p \\" . cape-tex)
         ("C-c p _" . cape-tex)
         ("C-c p ^" . cape-tex)
         ("C-c p &" . cape-sgml)
         ("C-c p r" . cape-rfc1345))
  )

(use-package xah-fly-keys
  :ensure t
  :init
  (xah-fly-keys t)
  :bind
  (:map xah-fly-insert-map
	("<f8>"  . nil)
	("C-p"   . xah-fly-command-mode-activate)
	("C-SPC" . dabbrev-completion))
  (:map xah-fly-command-map
	("SPC SPC" . nil)
	("="       . nil)
	("-"       . nil)
	("'"       . nil)
	("C-SPC"   . dabbrev-completion)
	("SPC w j" . xref-find-references)
	("SPC w l" . xref-go-back) 
	("g"       . xah-select-line)
	("SPC i l" . rename-buffer)
	("SPC l s" . flymake-goto-next-error)
	("SPC l d" . flymake-show-project-diagnostics)
	("SPC l c" . eldoc)
	("SPC l z" . eglot-code-actions)
	("SPC / s" . 'diff-split-hunk)
	("SPC / x" . 'diff-hunk-kill))
  )

(use-package css-mode
  :config (setq css-indent-offset 2)
  )

(use-package dired
  :config
  (setq dired-listing-switches "-lah --group-directories-first") ;; sorting Dired
  (define-key dired-mode-map [remap xah-smart-delete] 'dired-flag-file-deletion)
  (define-key dired-mode-map [remap xah-backward-left-bracket] 'dired-mark)
  (define-key dired-mode-map [remap backward-word] 'dired-unmark)
  (define-key dired-mode-map [remap xah-cut-line-or-region] 'dired-do-flagged-delete)
  :bind
  (:map dired-mode-map
	("<f5>" . revert-buffer)
	)
  )

(use-package eglot
  :init (setq eglot-autoshutdown t)
  :mode (("\\.js\\'" . js-mode)
	 ("\\.go\\'" . go-ts-mode))
  :hook ((js-mode . eglot-ensure)
	 (go-ts-mode . eglot-ensure))
  )

(use-package ediff
  :config
  (setq ediff-split-window-function 'split-window-horizontally)
  (setq ediff-window-setup-function 'ediff-setup-windows-plain)
  :bind
  (("<f12>" . ediff)
   ("<f6>"  . ediff-previous-difference)
   ("<f7>"  . ediff-next-difference))
  )

(use-package ibuffer
  :config
  (define-key ibuffer-mode-map [remap xah-smart-delete] 'ibuffer-mark-for-delete)
  (define-key ibuffer-mode-map [remap xah-backward-left-bracket] 'ibuffer-mark-forward)
  (define-key ibuffer-mode-map [remap backward-word] 'ibuffer-unmark-forward)
  (define-key ibuffer-mode-map [remap xah-cut-line-or-region] 'ibuffer-do-kill-on-deletion-marks)
  :bind
  (:map ibuffer-mode-map
	("<f5>" . ibuffer-update)
	)
  )

(use-package isearch
  :bind
  (:map isearch-mode-map
	("<f8>" . isearch-repeat-forward)
	("<f9>" . isearch-repeat-backward)
	)
  )

;; position of the buffers
;; (BUFFER-MATCHING-RULE
;;  LIST-OF-DISPLAY-BUFFER-FUNCTIONS
;;  OPTIONAL-PARAMETERS)
(setq display-buffer-alist
      '(
	("\\*Help\\*"
	 (display-buffer-reuse-mode-window display-buffer-below-selected)
	 (dedicated . t))
	("\\*vc-git.*\\*"
	 (display-buffer-reuse-mode-window display-buffer-below-selected)
	 (window-height . 10)
	 (dedicated . t))
	("\\*Warnings\\*"
	 (display-buffer-reuse-mode-window display-buffer-at-bottom)
	 (dedicated . t)
	 (window-height . 5))
	("\\*eldoc\\*"
	 (display-buffer-reuse-mode-window display-buffer-below-selected)
	 (window-height . 10)
	 (dedicated . t))
	("\\*Shell Command Output\\*"
	 (display-buffer-reuse-mode-window display-buffer-below-selected)
	 (window-height . 10)
	 (dedicated . t))
	))

;; custom color of ejs templates and `${ }` in js files
(defun custom-face ()
  (font-lock-add-keywords
   nil
   '(("<%[^%]*%>"   0 'ef-themes-heading-4 t) "<% %>"
     ("\$\{[^}]+\}" 0 'ef-themes-heading-4 t) "${ }")
   )
  )

(use-package js
  :config (setq js-indent-level 2)
  :hook ((js-mode . custom-face))
  )

(use-package sql
  :bind
  (:map sql-mode-map
	("<f5>" . 'sql-send-region))
  )

(use-package minibuffer
  :bind
  (:map minibuffer-local-map
	("C-r" . next-history-element)
	("C-t" . previous-history-element)
	)
  )

(use-package vc-dir
  :config
  (define-key vc-dir-mode-map [remap xah-backward-left-bracket] 'vc-dir-mark)
  (define-key vc-dir-mode-map [remap backward-word] 'vc-dir-unmark)
  :bind
  (:map vc-dir-mode-map
	("+"    . nil)
	("<f5>" . vc-dir-refresh)
	)
  )

(custom-set-variables
 '(auth-source-save-behavior nil)
 '(blink-cursor-mode nil)
 '(custom-enabled-themes '(ef-maris-dark))
 '(custom-safe-themes
   '("01a9797244146bbae39b18ef37e6f2ca5bebded90d9fe3a2f342a9e863aaa4fd"
     "aff0396925324838889f011fd3f5a0b91652b88f5fd0611f7b10021cc76f9e09"
     "97283a649cf1ffd7be84dde08b45a41faa2a77c34a4832d3884c7f7bba53f3f5"
     "ed1b7b4db911724b2767d4b6ad240f5f238a6c07e98fff8823debcfb2f7d820a"
     default))
 '(fringe-mode '(13 . 13) nil (fringe))
 '(menu-bar-mode nil)
 '(package-selected-packages '(cape cape- corfu ef-themes xah-fly-keys))
 '(scroll-bar-mode nil)
 '(size-indication-mode t)
 '(sql-postgres-options '("-P" "pager=off"))
 '(tool-bar-mode nil)
 '(tooltip-mode nil)
 '(vc-annotate-background-mode t))

(custom-set-faces
 '(default ((t (:family "Adwaita Mono" :foundry "UKWN" :slant normal :weight regular :height 113 :width normal))))
 '(cursor ((t (:background "gold1")))))
