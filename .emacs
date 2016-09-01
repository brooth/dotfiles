(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

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

;;---------------------------------------------------------------
;;                            base
;;---------------------------------------------------------------
(ensure-package-installed
  'evil
  'evil-leader
  'helm
  'helm-ag
  'flx-ido          ;; fuzzy matching
  'hideshowvis
  )

;; startup emacs directory
(setq root-dir default-directory)


(setq evil-want-C-u-scroll t)
;; vi undo
(setq evil-want-fine-undo t)

(require 'evil)
(evil-mode t)

;; helm

;;---------------------------------------------------------------
;;                       sessions
;;---------------------------------------------------------------
(ensure-package-installed
  'desktop          ;; save sessions
  )
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

;;---------------------------------------------------------------
;;                      windows, frames
;;---------------------------------------------------------------
(global-evil-leader-mode)
(evil-leader/set-leader "<SPC>")
(evil-leader/set-key
  "1" 'select-window-1
  "2" 'select-window-2
  "3" 'select-window-3
  "4" 'select-window-4
  "5" 'select-window-5
  "S" 'save-session
  "R" 'restore-session
  )


;;---------------------------------------------------------------
;;                     intent, tabs, spaces
;;---------------------------------------------------------------
;; tabs => 4 spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)


;;---------------------------------------------------------------
;;                         ui, theme
;;---------------------------------------------------------------
(ensure-package-installed
  'linum-relative
  'gruvbox-theme
  'eyebrowse
  'window-numbering ;; window number in modeline
  ; 'powerline-evil
  'spaceline
  ; 'persp-mode
  ; 'anzu             ;; search matching info in modeline
  )

;; show matching parentheses
; (show-smartparens-global-mode t)

;; smooth scrolling?
(setq scroll-step 1
      scroll-conservatively  10000
      scroll-margin 5)

;; (setq inhibit-startup-message t) ;; hide the startup message
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

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
(window-numbering-mode)

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
  'projectile       ;; manage projects
  'magit            ;; git
  )

(require 'projectile)

;;---------------------------------------------------------------
;;                           python
;;---------------------------------------------------------------
; (ensure-package-installed
;   'flycheck         ;; add the flycheck package
;   'py-autopep8      ;; add the autopep8 package
;   'elpy             ;; python mode
;   )

; (elpy-enable)

; (when (require 'flycheck nil t)
;   (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
;   (add-hook 'elpy-mode-hook 'flycheck-mode))
