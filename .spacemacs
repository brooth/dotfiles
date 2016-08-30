;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  (setq-default
   dotspacemacs-configuration-layer-path '()

   dotspacemacs-configuration-layers '(
     ;; better-defaults
     emacs-lisp
     ;; completion
     (auto-completion :variables
                      auto-completion-return-key-behavior 'complete
                      auto-completion-tab-key-behavior 'complete
                      auto-completion-complete-with-key-sequence "jk"
                      auto-completion-complete-with-key-sequence-delay 0.0
                      auto-completion-private-snippets-directory nil
                      auto-completion-enable-snippets-in-popup t
                      )

     company
     git
     markdown
     org
     shell
     (shell :variables
            shell-default-height 30
            shell-default-position 'bottom)
     spell-checking
     syntax-checking
     version-control
     python
     typescript
     )

   dotspacemacs-additional-packages '(
     ;; solarized-theme
     gruvbox-theme
   )

   dotspacemacs-excluded-packages '(
    company
    ;; neotree
   )))

(defun dotspacemacs/init ()
  (setq-default
   ;; known
   dotspacemacs-mode-line-unicode-symbols nil
   dotspacemacs-colorize-cursor-according-to-state t
   dotspacemacs-loading-progress-bar nil
   dotspacemacs-themes '(gruvbox monokai spacemacs-dark zenburn solarized-dark)
   dotspacemacs-default-font '("Ubuntu Mono" :size 16 :weight normal
                               :width normal :powerline-scale 1.1)
   dotspacemacs-active-transparency nil
   dotspacemacs-inactive-transparency nil

   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil

   dotspacemacs-editing-style 'vim
   dotspacemacs-line-numbers 'relative
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")

   dotspacemacs-startup-banner nil
   dotspacemacs-startup-lists '(recents bookmarks projects)
   dotspacemacs-startup-recent-list-size 5
   dotspacemacs-check-for-update t
   dotspacemacs-maximized-at-startup t
   dotspacemacs-smooth-scrolling nil
   dotspacemacs-auto-resume-layouts t

   dotspacemacs-leader-key "SPC"
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m)
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"

   dotspacemacs-elpa-https t
   dotspacemacs-elpa-timeout 5

   ;; unknown

   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs C-i, TAB and C-m, RET.
   ;; Setting it to a non-nil value, allows for separate commands under <C-i>
   ;; and TAB or <C-m> and RET.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil
   ;; (Not implemented) dotspacemacs-distinguish-gui-ret nil
   ;; If non nil `Y' is remapped to `y$'. (default t)
   dotspacemacs-remap-Y-to-y$ t
   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"
   ;; If non nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil
   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5

   ;; If non nil then `ido' replaces `helm' for some commands. For now only
   ;; `find-files' (SPC f f), `find-spacemacs-file' (SPC f e s), and
   ;; `find-contrib-file' (SPC f e c) are replaced. (default nil)
   dotspacemacs-use-ido nil
   ;; If non nil, `helm' will try to minimize the space it uses. (default nil)
   dotspacemacs-helm-resize t
   ;; if non nil, the helm header is hidden when there is only one source.
   ;; (default nil)
   dotspacemacs-helm-no-header nil
   ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
   ;; several times cycle between the kill ring content. (default nil)
   dotspacemacs-enable-paste-micro-state nil
   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all
   ;; If non nil advises quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now. (default nil)
   dotspacemacs-default-package-repository nil
   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed'to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil
   ))

(defun dotspacemacs/user-init ()

)

(defun dotspacemacs/user-config ()
  (setq-default
   tab-width 4

   ;; Ranger
   ranger-override-dired t

   evil-shift-round nil

   ;; ?
   ;; evil-move-beyond-eol t

   ;; show helm's prompt at the bottom
   helm-echo-input-in-header-line nil
   powerline-default-separator (quote utf-8))

  ;; save sessions
  (desktop-save-mode 1)

  (evil-leader/set-key
    "os" 'just-one-space)

  (set-default 'truncate-lines t)

  ;; move visual lines
  (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)

  (define-key evil-insert-state-map (kbd "C-SPC") 'auto-complete)

  (setq projectile-globally-ignored-directories '(".*", "node_modules"))

  ;; undo all in insert mode
  (setq evil-want-fine-undo t)

  ;; save undo history
  (setq undo-tree-auto-save-history t)
  (setq undo-tree-history-directory-alist
        `(("." . ,(concat user-emacs-directory ".cache/undo"))))

   ;; run in eval mode
   (with-eval-after-load 'proced
     (evilified-state-evilify-map proced-mode-map
       :mode proced-mode))
)

(custom-set-faces
 '(font-lock-type-face ((t (:foreground "#ffaf20"))))
 '(warning ((t (:foreground "DarkOrange")))))

