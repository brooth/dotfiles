(require 'package)

(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))

(setq package-enable-at-startup nil)
(package-initialize)

(defun ensure-package-installed (&rest packages)
    (mapcar
     (lambda (package)
       (if (package-installed-p package)
       nil
       (package-install package)
     ))
     packages))

;; Make sure to have downloaded archive description.
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

;; TODO:
; Plug 'tpope/vim-surround'
; "stay same position on insert mode exit
; inoremap <silent> <Esc> <Esc>`^
; indent with tab
; dim inactive windows

;;---------------------------------------------------------------
;;                            base
;;---------------------------------------------------------------
(ensure-package-installed
  'evil
  'evil-leader
  'evil-multiedit   ;; edit matching text at the time
  'flx-ido          ;; fuzzy matching
  'smartparens      ;; close brackets
  'which-key        ;; popup with available key bindings
  'expand-region    ;; select regions (inside blocks, methods, stuff)
  )

;; startup emacs directory
(setq root-dir default-directory)

;; evil-leader
(global-evil-leader-mode)
(evil-leader/set-leader "<SPC>")

;; evil mode
(setq evil-want-C-u-scroll t)
;; vi undo
(setq evil-want-fine-undo t)

(require 'evil-multiedit)
(evil-multiedit-default-keybinds)

(require 'evil)
(evil-mode t)

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

(require 'smartparens-config)
(add-hook 'python-mode-hook #'smartparens-mode)
(add-hook 'emacs-lisp-mode-hook #'smartparens-mode)

;; short messages
(defalias 'yes-or-no-p 'y-or-n-p)

;; expand-region keys
(global-set-key (kbd "C-=") 'er/expand-region)

;;---------------------------------------------------------------
;;                    files, find, locate
;;---------------------------------------------------------------
(ensure-package-installed
  'ag
  'helm
  'helm-ag
  )

(require 'helm-config)

;; always at the bottom
(add-to-list 'display-buffer-alist
                    `(,(rx bos "*helm" (* not-newline) "*" eos)
                         (display-buffer-in-side-window)
                         (inhibit-same-window . t)
                         (window-height . 0.4)))

;;---------------------------------------------------------------
;;                       sessions
;;---------------------------------------------------------------
(ensure-package-installed
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
(defun exit-emacs ()
  "save some buffers, then exit unconditionally"
  (interactive)
  (save-some-buffers nil t)
  (kill-emacs))
(global-set-key (kbd "C-x C-c") 'exit-emacs)

(evil-leader/set-key
  "q q" 'exit-emacs
  "q r" 'restart-emacs
  "q b" 'kill-this-buffer
  "q w" 'delete-window
  )

(which-key-add-key-based-replacements "SPC q" "quit")

;;---------------------------------------------------------------
;;                      windows, frames
;;---------------------------------------------------------------
(ensure-package-installed
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
(setq tab-width 4)

;;---------------------------------------------------------------
;;                         ui, theme
;;---------------------------------------------------------------
(ensure-package-installed
  'rainbow-delimiters
  'linum-relative
  'gruvbox-theme
  'eyebrowse
  ; 'powerline-evil
  'spaceline
  ; 'persp-mode
  ; 'anzu             ;; search matching info in modeline
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

;; color delimeters in diff colors
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; smooth scrolling?
(setq scroll-conservatively 0)
(setq scroll-margin 5)

;; (setq inhibit-startup-message t) ;; hide the startup message
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq use-dialog-box     nil) ;; никаких графических диалогов и окон - все через минибуфер
(setq redisplay-dont-pause t)  ;; лучшая отрисовка буфера
(setq ring-bell-function 'ignore) ;; отключить звуковой сигнал

;; relative line numbers
(linum-relative-mode)
;; enable line numbers globally
(global-linum-mode t)

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
(ensure-package-installed
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

(setq-default ac-sources '(
  ac-source-words-in-buffer
  ac-source-words-in-same-mode-buffers
  ac-source-yasnippet
  ac-source-abbrev
  ac-source-filename
  ))

(global-set-key (kbd "TAB") 'ac-start) ;; start ac with TAB

;; yasnippet
(require 'yasnippet)
(yas-reload-all)

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

;;---------------------------------------------------------------
;;                           python
;;---------------------------------------------------------------
(ensure-package-installed
  'jedi
;;  'py-autopep8      ;; add the autopep8 package
  )

(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

(add-hook 'python-mode-hook (lambda () (
   add-to-list 'ac-sources 'ac-source-jedi-direct)))

(evil-leader/set-key
  "G" 'jedi:goto-definition
  "K" 'jedi:show-doc
  "U" 'helm-jedi-related-names
  )

(add-hook 'python-mode-hook 'yas-minor-mode)

(add-hook 'python-mode-hook 'flycheck-mode)

(with-eval-after-load 'flycheck
  (flycheck-add-next-checker 'python-flake8 'python-pylint))

(add-to-list 'projectile-globally-ignored-files "*.py")
(add-to-list 'projectile-globally-ignored-files "#*")
(add-to-list 'projectile-globally-ignored-directories ".env")
(add-to-list 'projectile-globally-ignored-directories "__pycache__")
(add-to-list 'projectile-globally-ignored-directories "node_modules")

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
