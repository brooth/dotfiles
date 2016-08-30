(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

(defun ensure-package-installed (&rest packages)
    "Assure every package is installed, ask for installation if it’s not.
     Return a list of installed packages or nil for every skipped package."
    (mapcar
     (lambda (package)
       (if (package-installed-p package)
       nil
     (if (y-or-n-p (format "Package %s is missing. Install it? " package))
         (package-install package)
       package)))
     packages))

;; Make sure to have downloaded archive description.
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

;; Activate installed packages
(package-initialize)

(ensure-package-installed 
  'evil
  'helm
  'gruvbox-theme    ;; gruvbox theme
  'powerline
  'spaceline
  'flx-ido          ;; fuzzy matching
  'projectile       ;; manage projects
  'flycheck         ;; add the flycheck package
  'py-autopep8      ;; add the autopep8 package
  'elpy             ;; python mode
  'magit            ;; git 
  )

;;---------------------------------------------------------------
;;                          base 
;;---------------------------------------------------------------
(require 'evil)
(evil-mode t)

;;---------------------------------------------------------------
;;                        python
;;---------------------------------------------------------------
(elpy-enable)

(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;;---------------------------------------------------------------
;;                     intent, tabs, spaces
;;---------------------------------------------------------------
(setq-default
 tab-width 4)


;;---------------------------------------------------------------
;;                         ui, theme
;;---------------------------------------------------------------
;; (setq inhibit-startup-message t) ;; hide the startup message
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(display-time-mode)
(rich-minority-mode 1)

(load-theme 'gruvbox t)

(global-linum-mode t) ;; enable line numbers globally

;; powerline
(require 'powerline)
; (setq powerline-default-separator-dir '(right . left))
(setq powerline-arrow-shape 'arrow) ;; mirrored arrows, 
(setq powerline-default-separator 'utf-8)

;; spacemacs power line theme
(require 'spaceline-config)
(spaceline-emacs-theme)

