;; kill-some-buffers - go through buffers and delete if needed
;; C-x C-b - buffer list, d - mark to delete, x - delete marked

(require 'package)

(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))

(setq package-enable-at-startup nil)
(package-initialize)

(defun use-package (&rest packages)
    (mapcar
     (lambda (package)
       (if (package-installed-p package)
       nil
       (package-install package)
     ))
     packages))

;; TODO:
; Plug 'tpope/vim-surround'
; "stay same position on insert mode exit
; inoremap <silent> <Esc> <Esc>`^
; indent with tab
; dim inactive windows

;;---------------------------------------------------------------
;;                            base
;;---------------------------------------------------------------
(use-package
  'evil
  'evil-leader
  'evil-multiedit   ;; edit matching text at the time
  'flx-ido          ;; fuzzy matching
  'smartparens      ;; close brackets
  'which-key        ;; popup with available key bindings
  ;;???
  'expand-region    ;; select regions (inside blocks, methods, stuff)
  )

;; startup emacs directory
(setq root-dir default-directory)

(setq evil-want-C-i-jump nil)   ;; fix TAB behavior????
(setq evil-want-C-u-scroll t)   ;; C-u = scroll up
(setq evil-want-fine-undo t)    ;; vi undo

(require 'evil)
(evil-mode t)

;; evil-leader
(global-evil-leader-mode)
(evil-leader/set-leader "<SPC>")

(require 'evil-multiedit)
(evil-multiedit-default-keybinds)

;; which-key-mode
(require 'which-key)
(which-key-mode)

;; flx-ido-mode
(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)

(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

;; smartparents
(require 'smartparens-config)
(add-hook 'python-mode-hook #'smartparens-mode)
(add-hook 'emacs-lisp-mode-hook #'smartparens-mode)

;; short 'yes' 'no' messages
(defalias 'yes-or-no-p 'y-or-n-p)

;; expand-region keys
(global-set-key (kbd "M-5") 'er/expand-region)

;;---------------------------------------------------------------
;;                      windows, frames
;;---------------------------------------------------------------
(use-package
  'popwin           ;; open popups (help, etc) in bottom popup window
  'window-numbering ;; window number in modeline
  )

(require 'popwin)
(popwin-mode 1)

(window-numbering-mode)

(evil-leader/set-key
  "TAB" 'other-window
  "<backtab>" 'previous-multiframe-window
  "1" 'select-window-1
  "2" 'select-window-2
  "3" 'select-window-3
  "4" 'select-window-4
  "5" 'select-window-5
  ;; delete windows
  "!" '(lambda () (interactive) (select-window-1) (delete-window))
  "@" '(lambda () (interactive) (select-window-2) (delete-window))
  "#" '(lambda () (interactive) (select-window-3) (delete-window))
  "$" '(lambda () (interactive) (select-window-4) (delete-window))
  "%" '(lambda () (interactive) (select-window-5) (delete-window))
  )

(which-key-add-key-based-replacements "SPC !" "delete-window-1")
(which-key-add-key-based-replacements "SPC @" "delete-window-2")
(which-key-add-key-based-replacements "SPC #" "delete-window-3")
(which-key-add-key-based-replacements "SPC $" "delete-window-4")
(which-key-add-key-based-replacements "SPC %" "delete-window-5")

;;---------------------------------------------------------------
;;                     intent, tabs, spaces
;;---------------------------------------------------------------
;; tabs => 4 spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;;---------------------------------------------------------------
;;                    files, find, locate
;;---------------------------------------------------------------
(use-package
  'ag
  'helm
  'swiper       ;; isearch replacement
  )

(require 'helm-config)

;; always at the bottom
(add-to-list 'display-buffer-alist
                    `(,(rx bos "*helm" (* not-newline) "*" eos)
                         (display-buffer-in-side-window)
                         (inhibit-same-window . t)
                         (window-height . 0.4)))

;; swiper
(global-set-key (kbd "C-s") 'swiper)

;; .emacs
(defun edit-dot-emacs()
  (interactive)
  (find-file user-init-file))

(defun reload-dot-emacs()
  (interactive)
  (load-file "~/.emacs"))

(evil-leader/set-key
  "f d e" 'edit-dot-emacs
  "f d r" 'reload-dot-emacs
  )

(which-key-add-key-based-replacements "SPC f" "files")
(which-key-add-key-based-replacements "SPC f d" ".emacs")

;;---------------------------------------------------------------
;;                       sessions
;;---------------------------------------------------------------
(use-package
  'desktop          ;; save sessions
  'restart-emacs
  'saveplace        ;; remember cursor position
  )

;; save commands history
(savehist-mode 1)

(require 'saveplace)
(setq-default save-place t)

;; recent files
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)

;; desktop (saving sessions)
(require 'desktop)
;; an error w/out next 3 lines...
(setq desktop-restore-frames t)
(setq desktop-restore-in-current-display t)
(setq desktop-restore-forces-onscreen nil)

;; save/restore sessions
(setq session-dir root-dir)
(setq session-path (concat root-dir ".emacs.desktop"))

(defun session-saved()
  (file-exists-p session-path))

(defun save-session()
  (interactive)
  (if (session-saved)
    (if (y-or-n-p (concat "Override session? [" session-path "]"))
      (desktop-save session-dir)
      nil)
    (desktop-save session-dir)))

(defun restore-session ()
  (interactive)
  (if (session-saved)
    (desktop-read session-dir)
    (message "No seved session")))

;; session
(evil-leader/set-key
  "s s" 'save-session
  "s r" 'restore-session
  )

(which-key-add-key-based-replacements "SPC s" "session")

;; quit
(evil-leader/set-key
  "q q" 'save-buffers-kill-emacs
  "q r" 'restart-emacs
  "q b" 'kill-this-buffer
  "q w" 'delete-window
  )

(which-key-add-key-based-replacements "SPC q" "quit")

;;---------------------------------------------------------------
;;                     lines, scrolling, avy
;;---------------------------------------------------------------
(use-package
  'avy
  )

;; hl current line
(global-hl-line-mode 1)

(defun hl-evil-insert-state()
  (interactive)
  (set-face-background 'hl-line "OrangeRed4"))

(defun nohl-evil-insert-state()
  (interactive)
  (set-face-background 'hl-line "color-237"))

(add-hook 'evil-insert-state-entry-hook 'hl-evil-insert-state)
(add-hook 'evil-insert-state-exit-hook 'nohl-evil-insert-state)

(setq scroll-margin 5)

;; enable line numbers globally
(global-linum-mode t)

;; avy
(evil-leader/set-key
  "g L" 'avy-goto-line-above
  "g l" 'avy-goto-line-below
  "g W" 'avy-goto-word-1-above
  "g w" 'avy-goto-word-1-below
  "g g" 'avy-goto-word-or-subword-1
  )
(which-key-add-key-based-replacements "SPC g" "goto/avy")

;;---------------------------------------------------------------
;;                         ui, theme
;;---------------------------------------------------------------
(use-package
  'rainbow-delimiters
  'gruvbox-theme
  'eyebrowse
  'spaceline
  )

;; color delimeters in diff colors
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; (setq inhibit-startup-message t) ;; hide the startup message
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq redisplay-dont-pause t)  ;; dont pause keys while redrawing

;; theme
(load-theme 'gruvbox t)

;;  powerline
(setq powerline-default-separator-dir '(right . left)
      powerline-arrow-shape 'arrow
      powerline-default-separator 'utf-8)

;; spaceline
(eyebrowse-mode)

(require 'spaceline-config)
(setq spaceline-toggle-workspace-number-on nil
      ; spaceline-workspace-numbers-unicode t
      ; spaceline-window-numbers-unicode t
      spaceline-highlight-face-func 'spaceline-highlight-face-evil-state)
(spaceline-spacemacs-theme)
(spaceline-toggle-minor-modes-off)  ;; hide minor modes
(spaceline-toggle-projectile-root-on) ;; not working?
; (spaceline-toggle-anzu-on)

;;---------------------------------------------------------------
;;                           dev
;;---------------------------------------------------------------
(use-package
  'projectile           ;; manage projects
  'helm-projectile
  'magit                ;; git
  'yasnippet            ;; code snippets
  'auto-complete
  'flycheck
  )

;; auto-complete
(ac-config-default)

(setq ac-auto-start 1)      ;; chars to start ac
(setq ac-menu-height 30)    ;; popup window height
(setq ac-ignore-case nil)   ;; respect case
(setq ac-use-menu-map t)    ;; show popup while C-p C-n
(setq ac-candidate-limit 30)
(setq ac-max-width 0.5)     ;; max menu width (window ratio)

;;(setq ac-use-comphist nil)
;;(setq ac-use-fuzzy t)

(setq-default ac-sources '(
  ac-source-words-in-buffer
  ac-source-yasnippet
  ))

(global-set-key (kbd "C-@") 'ac-start)
;;(global-set-key (kbd "TAB") 'ac-start) ;; start ac with TAB

;; yasnippet
(require 'yasnippet)
(yas-reload-all)
;; Remove Yasnippet's default tab key binding
(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)

(require 'projectile)
(setq projectile-indexing-method 'alien)
(setq projectile-enable-caching t)
(projectile-global-mode)

(require 'helm-projectile)
(helm-projectile-on)

(add-to-list 'projectile-globally-ignored-directories ".git")

(evil-leader/set-key
  "p p" 'helm-projectile
  "p g" 'helm-projectile-ag
  "p f" 'helm-projectile-find-file
  "p d" 'helm-projectile-find-dir
  "p s" 'helm-projectile-switch-project
  "p I" 'projectile-invalidate-cache
  "p d" 'projectile-dired
  )

(which-key-add-key-based-replacements "SPC p" "projectile")

;; flycheck
(evil-leader/set-key
  "c n" 'flycheck-next-error
  "c p" 'flycheck-previous-error
  "c l" 'flycheck-list-errors
  "c f" 'flycheck-first-error
  )
(which-key-add-key-based-replacements "SPC c" "flycheck")

;; error list at the bottom
(push '("\*Flycheck errors*" :position bottom) popwin:special-display-config)

;; dont check in insert-mode
(add-hook 'evil-insert-state-entry-hook '(lambda ()
  (if flycheck-mode
    (setq flycheck-check-syntax-automatically '(mode-enabled save)))))
(add-hook 'evil-insert-state-exit-hook '(lambda ()
  (if flycheck-mode
    (flycheck-buffer)
    (setq flycheck-check-syntax-automatically '(mode-enabled idle-change)))))

;;---------------------------------------------------------------
;;                           python
;;---------------------------------------------------------------
(use-package
  'jedi
  'helm-pydoc           ;; browes package docs
;;  'py-autopep8        ;; add the autopep8 package
  )

;; add 'async' and 'await' keywords
(font-lock-add-keywords 'python-mode '(("async\s" . font-lock-keyword-face)))
(font-lock-add-keywords 'python-mode '(("\sawait\s" . font-lock-keyword-face)))

(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

(add-hook 'python-mode-hook (lambda () (
   add-to-list 'ac-sources 'ac-source-jedi-direct t)))

(evil-leader/set-key
  "G" 'jedi:goto-definition
  "K" 'jedi:show-doc
  "U" 'helm-jedi-related-names
  )

(add-hook 'python-mode-hook 'yas-minor-mode)

(add-hook 'python-mode-hook 'flycheck-mode)

(with-eval-after-load 'flycheck
  (flycheck-add-next-checker 'python-flake8 'python-pylint))

(setq-default flycheck-flake8-maximum-line-length 100)

(add-to-list 'projectile-globally-ignored-files "*.pyc")
(add-to-list 'projectile-globally-ignored-files "#*#")
(add-to-list 'projectile-globally-ignored-directories ".env")
(add-to-list 'projectile-globally-ignored-directories "__pycache__")
(add-to-list 'projectile-globally-ignored-directories "node_modules")

;;---------------------------------------------------------------
;;                       elisp
;;---------------------------------------------------------------

;;---------------------------------------------------------------
;;                       customize
;;---------------------------------------------------------------

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-header ((t (:background "magenta" :foreground "brightwhite" :underline nil))))
 '(helm-selection ((t (:background "color-239" :foreground "brightmagenta"))))
 '(isearch ((t (:background "blue")))))
