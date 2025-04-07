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
(setq create-lockfiles nil)

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
   '(("<%[^%]*%>" 0 'ef-themes-heading-4 t) "<% %>"
     ("\$\{[^}]+\}" 0 'ef-themes-heading-4 t) "${ }"))
  )

(use-package html-mode
  :mode "\\.ejs\\'"
  :hook (html-mode . custom-face)
  )

(use-package js
 :config (setq js-indent-level 2)
 :hook ((js-mode . custom-face))
)

(use-package css-mode
 :config (setq css-indent-offset 2)
)

(use-package eglot
 :init (setq eglot-autoshutdown t)
 :mode ("\\.js\\'" . js-mode)
 :hook ((js-mode . eglot-ensure))
)

(use-package ediff
  :config
  (setq ediff-split-window-function 'split-window-horizontally)
  (setq ediff-window-setup-function 'ediff-setup-windows-plain)
  :bind
  (("<f12>" . ediff)
   ("<f6>" . ediff-previous-difference)
   ("<f7>" . ediff-next-difference))
)

(use-package corfu
  :custom
  (corfu-preview-current nil)
  (corfu-on-exact-match 'show)
  :config
  (setq corfu-max-width 200)
  :bind
  (:map corfu-map
	("C-n" . corfu-next)
	("C-p" . corfu-previous))
  :init
  (global-corfu-mode)
  (corfu-history-mode))

(use-package sql
  :bind
  (:map sql-mode-map
	("<f5>" . 'sql-send-region)))

(use-package cape
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
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  (add-to-list 'completion-at-point-functions #'cape-history)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-abbrev)
 )

;; keybinding
(xah-fly-keys t)
(define-key xah-fly-insert-map (kbd "<f8>") nil)
(define-key xah-fly-insert-map (kbd "C-p") 'xah-fly-command-mode-activate)
(define-key xah-fly-insert-map (kbd "C-SPC") 'dabbrev-completion)

(define-key xah-fly-command-map (kbd "SPC SPC") nil)
(define-key xah-fly-command-map (kbd "=") nil)
(define-key xah-fly-command-map (kbd "-") nil)
(define-key xah-fly-command-map (kbd "'") nil)

(define-key xah-fly-command-map (kbd "C-SPC") 'dabbrev-completion)
(define-key xah-fly-command-map (kbd "SPC w j") 'xref-find-references)
(define-key xah-fly-command-map (kbd "g") 'xah-select-line)

(define-key xah-fly-command-map (kbd "SPC l s") 'flymake-goto-next-error)
(define-key xah-fly-command-map (kbd "SPC l d") 'flymake-show-project-diagnostics)
(define-key xah-fly-command-map (kbd "SPC l c") 'eldoc)
(define-key xah-fly-command-map (kbd "SPC l z") 'eglot-code-actions)

(define-key xah-fly-command-map (kbd "SPC / s") 'diff-split-hunk)
(define-key xah-fly-command-map (kbd "SPC / x") 'diff-hunk-kill)

(define-key isearch-mode-map (kbd "<f8>") 'isearch-repeat-forward)
(define-key isearch-mode-map (kbd "<f9>") 'isearch-repeat-backward)

(define-key minibuffer-local-map (kbd "C-r") 'next-history-element)
(define-key minibuffer-local-map (kbd "C-t") 'previous-history-element)

(eval-after-load "IBuffer"
  '(progn
     (define-key ibuffer-mode-map [remap xah-smart-delete] 'ibuffer-mark-for-delete)
     (define-key ibuffer-mode-map [remap xah-backward-left-bracket] 'ibuffer-mark-forward)
     (define-key ibuffer-mode-map [remap backward-word] 'ibuffer-unmark-forward)
     (define-key ibuffer-mode-map [remap xah-cut-line-or-region] 'ibuffer-do-kill-on-deletion-marks)
     (define-key ibuffer-mode-map (kbd "<f5>") 'ibuffer-update)))

;; (setenv "LC_COLLATE" "C") ;; for sorting _file and _folders
(setq dired-listing-switches "-lah --group-directories-first") ;; sorting Dired
(eval-after-load "Dired"
  '(progn
     (define-key dired-mode-map [remap xah-smart-delete] 'dired-flag-file-deletion)
     (define-key dired-mode-map [remap xah-backward-left-bracket] 'dired-mark)
     (define-key dired-mode-map [remap backward-word] 'dired-unmark)     
     (define-key dired-mode-map [remap xah-cut-line-or-region] 'dired-do-flagged-delete)
     (define-key dired-mode-map (kbd "<f5>") 'revert-buffer)
     ;; (define-key dired-mode-map [remap xah-copy-line-or-region] 'dired-do-compress-to)
     ))

(eval-after-load "Bookmark"
  '(progn
     (define-key bookmark-bmenu-mode-map [remap xah-smart-delete] 'bookmark-bmenu-delete)
     (define-key bookmark-bmenu-mode-map [remap xah-backward-left-bracket] 'bookmark-bmenu-mark)
     (define-key bookmark-bmenu-mode-map [remap backward-word] 'bookmark-bmenu-unmark)
     (define-key bookmark-bmenu-mode-map [remap xah-cut-line-or-region] 'bookmark-bmenu-execute-deletions)
     (define-key bookmark-bmenu-mode-map (kbd "<f5>") 'revert-buffer)
     (define-key bookmark-bmenu-mode-map [remap forward-word] 'bookmark-bmenu-other-window)
     (define-key bookmark-bmenu-mode-map [remap kill-word] 'bookmark-bmenu-rename)
     (define-key bookmark-bmenu-mode-map [remap xah-paste-or-paste-previous] 'bookmark-bmenu-select)))

(eval-after-load "VC-Dir"
  '(progn
     (define-key vc-dir-mode-map (kbd "+") nil)
     (define-key vc-dir-mode-map (kbd "<f5>") 'vc-dir-refresh)
     (define-key vc-dir-mode-map [remap xah-backward-left-bracket] 'vc-dir-mark)
     (define-key vc-dir-mode-map [remap backward-word] 'vc-dir-unmark)))

(custom-set-variables
 '(auth-source-save-behavior nil)
 '(blink-cursor-mode nil)
 '(tool-bar-mode nil)
 '(menu-bar-mode nil)
 '(tooltip-mode nil)
 '(scroll-bar-mode nil)
 '(fringe-mode '(13 . 13) nil (fringe))
 
 '(custom-enabled-themes '(ef-maris-dark))
 '(custom-safe-themes
   '("97283a649cf1ffd7be84dde08b45a41faa2a77c34a4832d3884c7f7bba53f3f5" "ed1b7b4db911724b2767d4b6ad240f5f238a6c07e98fff8823debcfb2f7d820a" default))
 '(package-selected-packages '(web-mode cape corfu ef-themes xah-fly-keys))
 '(size-indication-mode t)
 '(sql-postgres-options '("-P" "pager=off"))
 '(vc-annotate-background-mode t))

(custom-set-faces
  '(default ((t (:family "Adwaita Mono" :foundry "UKWN" :slant normal :weight regular :height 113 :width normal))))
 ;; '(default ((t (:family "Noto Sans Mono" :foundry "GOOG" :slant normal :weight regular :height 113 :width normal))))
 '(cursor ((t (:background "gold1")))))
