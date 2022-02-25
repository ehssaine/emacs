(defconst sys/win32p
  (eq system-type 'windows-nt)
  "Are we running on a WinTel system?")

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    flycheck ; syntax/grammar checker
    py-autopep8 ; allow autopep 8 reformating upon save

ansible
ansible-doc
ansible-vault

0blayout ; window layout
ac-etags
ac-html
ac-html-csswatcher
ac-php
ace-window
all-the-icons
anzu ; display search number of matching occurences
desktop+
dtrt-indent
doom-modeline
emojify ; display emojis
fill-column-indicator
fontawesome
ggtags
git-gutter
git-messenger
helm
helm-swoop
ido
lv
magit ; git support
magit-gitflow
org-bullets
paradox ; better melpa browsing
phpunit
projectile
rainbow-delimiters ; matching parentheses colorization
sphinx-doc
treemacs
treemacs-projectile
use-package
use-package-ensure-system-package
which-key
ztree ; Directory tree diff

badger-theme
zerodark-theme
monokai-theme
material-theme
zenburn-theme
gruvbox-theme
doom-themes
doom-modeline
spacemacs-theme
atom-one-dark-theme

;;markdown-preview-mode
anaconda-mode
angular-mode
apache-mode
csv-mode
demangle-mode
docker
dotenv-mode
elpy ; python tool
groovy-mode
jinja2-mode
markdown-mode
nasm-mode
nginx-mode
npm-mode
php-mode
rainbow-mode
yaml-mode
))

(mapc #'(lambda (package)
	  (unless (package-installed-p package)
	    (package-install package)))
      myPackages)

;; Don't miss the trailing "/"
(setq my-themes-dir "~/.emacs.d/themes/")
(unless (file-directory-p my-themes-dir)
  (dired-create-directory my-themes-dir))

(defun clone-theme(git-url dst-dir-name)
  (shell-command
   (concat "git clone " git-url " " my-themes-dir dst-dir-name " 2> /dev/null || true")))

(let ((github-themes-url
       '(
	 ("https://github.com/ianpan870102/Emacs-Tron-Legacy-Theme" . "Emacs-Tron-Legacy-Theme")
	 )))

  (mapcar (lambda (element)
	    (let ((url (car element))
		  (dest (cdr element)))
	      (unless (file-directory-p dest)
		(clone-theme url dest)))
	    ) github-themes-url))

(when (file-directory-p my-themes-dir)
  (dolist (f (directory-files my-themes-dir))
    (if (and (not (or (equal f ".") (equal f "..")))
             (file-directory-p (concat my-themes-dir f)))
        (add-to-list 'custom-theme-load-path (concat my-themes-dir f)))))

(use-package github-theme
  :ensure t
  :defer t
  )

(use-package kaolin-themes
  :ensure t
  :defer t
  )

(use-package color-theme-approximate
  :ensure t
  :if (not (window-system))
  :init
  (autoload 'color-theme-approximate-on "color-theme-approximate")
  (color-theme-approximate-on)
  )

(defun load-theme--disable-old-theme(theme &rest args)
  "Disable current theme before loading new one."
  (mapcar #'disable-theme custom-enabled-themes))
(advice-add 'load-theme :before #'load-theme--disable-old-theme)

(load-theme 'doom-acario-dark t)

(global-set-key [f9] 'kill-this-buffer)

(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)

(use-package balanced-windows
  :ensure t
  :config
  (balanced-windows-mode)
)

(windmove-default-keybindings 'meta)
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

(defun toggle-maximize-buffer () "Maximize buffer"
       (interactive)
       (if (= 1 (length (window-list)))
           (jump-to-register '_)
         (progn
           (window-configuration-to-register '_)
           (delete-other-windows))))
(global-set-key [(ctrl f11)] 'toggle-maximize-buffer)

;; https://www.emacswiki.org/emacs/TransparentEmacs
(defun toggle-transparency ()
  (interactive)
  (let ((alpha (frame-parameter nil 'alpha)))
    (set-frame-parameter nil 'alpha
			 (if (eql (cond ((numberp alpha) alpha)
					((numberp (cdr alpha)) (cdr alpha))
					;; Also handle undocumented (<active> <inactive>) form.
					((numberp (cadr alpha)) (cadr alpha)))
				  100)
			     '(90 . 90) '(100 . 100))))) ;;active/inactive frame transparency
(global-set-key (kbd "C-c T") 'toggle-transparency)

;; Set transparency of emacs
(defun transparency (value)
  "Sets the transparency of the frame window. 0=transparent/100=opaque"
  (interactive "nTransparency Value 0 - 100 opaque:")
  (set-frame-parameter (selected-frame) 'alpha value))

(defun x-setface-height (number)
  "Face height is set to NUMBER."
  (interactive "nInsert number: ")
  (set-face-attribute 'default (selected-frame) :height number))

(global-set-key (kbd "C-c o") (lambda() (interactive) (x-setface-height 80)))
(global-set-key (kbd "C-c O") (lambda() (interactive) (x-setface-height 100)))

(use-package ace-window
  :ensure t
  :init
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  :bind ("M-o" . ace-window)
)

;; Scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq scroll-step 1
      scroll-margin 0
      scroll-conservatively 100000)

;; Display Time
(use-package time
  :ensure nil
  :unless (display-graphic-p)
  :hook (after-init . display-time-mode)
  :init
  (setq display-time-24hr-format t)
  (setq display-time-day-and-date t))

(custom-set-variables
 '(flycheck-python-flake8-executable "/usr/bin/python3.9")
 '(flycheck-python-pycompile-executable "/usr/bin/python3.9")
 '(flycheck-python-pylint-executable "/usr/bin/python3.9"))

(setq use-file-dialog nil)
(setq use-dialog-box nil)
(setq inhibit-startup-screen t)

(setq visible-bell t)

(size-indication-mode 1)

;; (blink-cursor-mode -1)

(setq line-move-visual nil)
(setq track-eol t)                      ; Keep cursor at end of lines. Require line-move-visual is nil.

(setq inhibit-compacting-font-caches t) ; Don’t compact font caches during GC.

;; Don't open a file in a new frame
(when (boundp 'ns-pop-up-frames)
(setq ns-pop-up-frames nil))

;; Don't use GTK+ tooltip
(when (boundp 'x-gtk-use-system-tooltips)
(setq x-gtk-use-system-tooltips nil))

(setq inhibit-startup-message t)

(tool-bar-mode -1)
(menu-bar-mode -1)
;; Scroll bar mode is not defined depending on emacs build option
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(setq ring-bell-function 'ignore)

(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(when window-system (add-hook 'prog-mode-hook 'hl-line-mode))

(when window-system
  (use-package pretty-mode
    :ensure t
    :config
    (global-pretty-mode t)))

(setq make-backup-files nil)
(setq auto-save-default nil)

(defalias 'yes-or-no-p 'y-or-n-p)

(use-package async
  :ensure t
  :init (dired-async-mode 1))

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "C-c t s") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if (executable-find "python3") 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-follow-delay             0.2
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-desc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-width                         35)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null (executable-find "python3"))))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("C-x t s"   . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag))
  )

(use-package treemacs-icons-dired
  :after treemacs dired
  :ensure t
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after treemacs magit
  :ensure t)

(use-package treemacs-projectile
  :after treemacs magit
  :ensure t
  )


(use-package pyimport
  :ensure t
  :init
  (define-key python-mode-map (kbd "C-c C-i") #'pyimport-insert-missing)
  )


(use-package projectile
  :ensure t
  :init
  (projectile-mode 1)
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  :config
  (setq projectile-completion-system 'helm
        projectile-switch-project-action 'helm-projectile)
  )

;; (global-set-key (kbd "<f5>") 'projectile-compile-project)

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  ;; (setq dashboard-startup-banner "~/.emacs.d/img/apero.png")
  (setq dashboard-items '((recents  . 5)
                          (projects . 5)))
  (setq dashboard-banner-logo-title "")
  (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
)

(use-package mood-line
  :ensure t
  :init
  (mood-line-mode)
  )

(setq powerline-default-separator nil)

(setq line-number-mode t)
(setq column-number-mode t)

(setq display-time-24hr-format t)
(setq display-time-format "%H:%M - %d %B %Y")

(display-time-mode 1)

(use-package fancy-battery
  :ensure t
  :config
  (setq fancy-battery-show-percentage t)
  (setq battery-update-interval 15)
  (if window-system
      (fancy-battery-mode)
    (display-battery-mode)))

(use-package symon
  :ensure t
  :bind
  ("s-h" . symon-mode))

(defvar my-term-shell "/usr/bin/zsh")
(defadvice ansi-term (before force-bash)
  (interactive (list my-term-shell)))
(ad-activate 'ansi-term)

(global-set-key (kbd "<s-return>") 'ansi-term)

;; Shell Pop
(use-package shell-pop
  :ensure t
  :bind ([f12] . shell-pop)
  :init (let ((val
               (if sys/win32p
                   '("eshell" "*eshell*" (lambda () (eshell)))
                 '("ansi-term" "*ansi-term*"
                   (lambda () (ansi-term shell-pop-term-shell))))))
          (setq shell-pop-shell-type val)
          (setq shell-pop-full-span 1)))

(use-package ivy
  :ensure t)

(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package switch-window
  :ensure t
  :config
  (setq switch-window-input-style 'minibuffer)
  (setq switch-window-increase 4)
  (setq switch-window-threshold 2)
  (setq switch-window-shortcut-style 'qwerty)
  (setq switch-window-qwerty-shortcuts
        '("a" "s" "d" "f" "j" "k" "l" "i" "o"))
  (setq switch-window-auto-resize-window nil)
  :bind
  ([remap other-window] . switch-window))

(defun split-and-follow-horizontally ()
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

(setq split-window-preferred-function (lambda nil (nil)))

(use-package swiper
  :ensure t
  :bind (("C-s" . 'swiper)
         :map swiper-map
         ("M-%" . swiper-query-replace))
  :config
  (setq swiper-action-recenter t)
)

(defun kill-current-buffer ()
  "Kills the current buffer."
  (interactive)
  (kill-buffer (current-buffer)))
(global-set-key (kbd "C-x k") 'kill-current-buffer)

(setq kill-buffer-query-functions (delq 'process-kill-buffer-query-function kill-buffer-query-functions))

(global-set-key (kbd "C-x b") 'ibuffer)

(setq ibuffer-expert t)

(defun close-all-buffers ()
  "Kill all buffers without regard for their origin."
  (interactive)
  (mapc 'kill-buffer (buffer-list)))
(global-set-key (kbd "C-M-k") 'close-all-buffers)

;; (use-package linum-relative
;;   :ensure t
;;   :config
;;     (setq linum-relative-current-symbol "")
;; (add-hook 'prog-mode-hook 'linum-relative-mode))

(use-package helm
  :ensure t
  :bind
  ("C-x C-f" . 'helm-find-files)
  ("C-x C-b" . 'helm-buffers-list)
  ("M-x" . 'helm-M-x)
  ("C-c M-y" . 'helm-show-kill-ring)
  :config
  (defun daedreth/helm-hide-minibuffer ()
    (when (with-helm-buffer helm-echo-input-in-header-line)
      (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
        (overlay-put ov 'window (selected-window))
        (overlay-put ov 'face
                     (let ((bg-color (face-background 'default nil)))
                       `(:background ,bg-color :foreground ,bg-color)))
        (setq-local cursor-type nil))))
  (add-hook 'helm-minibuffer-set-up-hook 'daedreth/helm-hide-minibuffer)
  (setq helm-autoresize-max-height 0
        helm-autoresize-min-height 40
        helm-M-x-fuzzy-match t
        helm-buffers-fuzzy-matching t
        helm-recentf-fuzzy-match t
        helm-semantic-fuzzy-match t
        helm-imenu-fuzzy-match t
        helm-split-window-in-side-p t
        helm-move-to-line-cycle-in-source nil
        helm-ff-search-library-in-sexp t
        helm-scroll-amount 8
        helm-echo-input-in-header-line t)
  :init
  (helm-mode 1))

(require 'github-pullrequest)

(require 'helm-config)
(helm-autoresize-mode 1)

(use-package helm-projectile
  :ensure t
  :after 'projectile
  :config
  (helm-projectile-on)
  )

(use-package avy
  :ensure t
  :bind
  ("M-s" . avy-goto-char))

(use-package mark-multiple
  :ensure t
  :bind ("C-c q" . 'mark-next-like-this))

(defun daedreth/kill-inner-word ()
  "Kills the entire word your cursor is in. Equivalent to 'ciw' in vim."
  (interactive)
  (forward-char 1)
  (backward-word)
  (kill-word 1))
(global-set-key (kbd "C-c w k") 'daedreth/kill-inner-word)

(defun daedreth/copy-whole-word ()
  (interactive)
  (save-excursion
    (forward-char 1)
    (backward-word)
    (kill-word 1)
    (yank)))
(global-set-key (kbd "C-c w c") 'daedreth/copy-whole-word)

(defun daedreth/copy-whole-line ()
  "Copies a line without regard for cursor position."
  (interactive)
  (save-excursion
    (kill-new
     (buffer-substring
      (point-at-bol)
      (point-at-eol)))))
(global-set-key (kbd "C-c l c") 'daedreth/copy-whole-line)

(global-set-key (kbd "C-c l k") 'kill-whole-line)

(defun config-visit ()
  (interactive)
  (find-file "~/.emacs.d/settings.org"))
(global-set-key (kbd "C-c e") 'config-visit)

(defun config-reload ()
  "Reloads ~/.emacs.d/config.org at runtime"
  (interactive)
  (org-babel-load-file (expand-file-name "~/.emacs.d/config.org")))
(global-set-key (kbd "C-c r") 'config-reload)

(global-subword-mode 1)

(setq electric-pair-pairs '(
                            (?\{ . ?\})
                            (?\( . ?\))
                            (?\[ . ?\])
                            (?\" . ?\")
                            ))

(electric-pair-mode t)

(use-package beacon
  :ensure t
  :config
  (beacon-mode 1))

(use-package rainbow-mode
  :ensure t
  :init
  (add-hook 'prog-mode-hook 'rainbow-mode))

(show-paren-mode 1)

(use-package rainbow-delimiters
  :ensure t
  :init
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package expand-region
  :ensure t
  :bind ("C-q" . er/expand-region))

(use-package smart-hungry-delete        ;
  :ensure t
  :bind (("<DEL>" . smart-hungry-delete-backward-char)
         ("C-d" . smart-hungry-delete-forward-char)
         ("<backspace>" . smart-hungry-delete-backward-char)
         )
  :defer nil ;; dont defer so we can add our functions to hooks
  :config (smart-hungry-delete-add-default-hooks)
  )

(use-package zzz-to-char
  :ensure t
  :bind ("M-z" . zzz-up-to-char))

(setq kill-ring-max 100)

(use-package popup-kill-ring
  :if window-system
  :ensure t
  :bind ("M-y" . popup-kill-ring))

(use-package yasnippet
  :ensure t
  :hook (after-init . yas-global-mode)
  :config (use-package yasnippet-snippets
            :ensure t)
  (yas-reload-all))

(use-package flycheck
  :ensure t)

(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 0))

(with-eval-after-load 'company
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous))

  ;;; Prevent suggestions from being triggered automatically. In particular,
  ;;; this makes it so that:
  ;;; - TAB will always complete the current selection.
  ;;; - RET will only complete the current selection if the user has explicitly
  ;;;   interacted with Company.
  ;;; - SPC will never complete the current selection.
  ;;;
  ;;; Based on:
  ;;; - https://github.com/company-mode/company-mode/issues/530#issuecomment-226566961
  ;;; - https://emacs.stackexchange.com/a/13290/12534
  ;;; - http://stackoverflow.com/a/22863701/3538165
  ;;;
  ;;; See also:
  ;;; - https://emacs.stackexchange.com/a/24800/12534
  ;;; - https://emacs.stackexchange.com/q/27459/12534

  ;; <return> is for windowed Emacs; RET is for terminal Emacs
  (dolist (key '("<return>" "RET"))
    ;; Here we are using an advanced feature of define-key that lets
    ;; us pass an "extended menu item" instead of an interactive
    ;; function. Doing this allows RET to regain its usual
    ;; functionality when the user has not explicitly interacted with
    ;; Company.
    (define-key company-active-map (kbd key)
      `(menu-item nil company-complete
                  :filter ,(lambda (cmd)
                             (when (company-explicit-action-p)
                               cmd)))))
  (define-key company-active-map (kbd "TAB") #'company-complete-selection)
  (define-key company-active-map (kbd "SPC") nil)

  ;; Company appears to override the above keymap based on company-auto-complete-chars.
  ;; Turning it off ensures we have full control.
  (setq company-auto-complete-chars nil)

(define-key company-active-map (kbd "C-n") #'company-select-next)
(define-key company-active-map (kbd "C-p") #'company-select-previous)

(add-hook 'c++-mode-hook 'yas-minor-mode)
(add-hook 'c-mode-hook 'yas-minor-mode)

(use-package flycheck-clang-analyzer
  :ensure t
  :config
  (with-eval-after-load 'flycheck
    (require 'flycheck-clang-analyzer)
    (flycheck-clang-analyzer-setup)))

(with-eval-after-load 'company
  (add-hook 'c++-mode-hook 'company-mode)
  (add-hook 'c-mode-hook 'company-mode))

(use-package company-c-headers
  :ensure t)

;; (use-package company-irony
;;   :ensure t
;;   :config
;;   (setq company-backends '((company-c-headers
;;                             company-dabbrev-code
;;                             company-irony))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package irony                                                  ;;
;;   :ensure t                                                         ;;
;;   :config                                                           ;;
;;   (add-hook 'c++-mode-hook 'irony-mode)                             ;;
;;   (add-hook 'c-mode-hook 'irony-mode)                               ;;
;;   (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)) ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'python-mode-hook 'yas-minor-mode)
(add-hook 'python-mode-hook 'flycheck-mode)

(with-eval-after-load 'company
  (add-hook 'python-mode-hook 'company-mode))

(defun python-mode-company-init ()
  (setq-local company-backends '((company-jedi
                                  company-etags
                                  company-dabbrev-code))))

(use-package company-jedi
  :ensure t
  :config
  (require 'company)
  (add-hook 'python-mode-hook 'python-mode-company-init))

(use-package elpy
:ensure t
:defer t
:init
(setq elpy-rpc-timeout 30)
(setq elpy-rpc-python-command "python3")
(advice-add 'python-mode :before 'elpy-enable)
:config
(progn
  (setq python-shell-interpreter "python3"
        python-shell-interpreter-args "-i")
  (when (require 'flycheck nil t)
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    (add-hook 'elpy-mode-hook 'flycheck-mode))
)
:bind (:map elpy-mode-map
            ("<f6>" . elpy-black-fix-code))
;; :hook
;; (python-mode . 'elpy-enable)
)

(setq python-shell-interpreter "python3"
      python-shell-interpreter-args "-i")

(with-eval-after-load 'python
  (defun python-shell-completion-native-try ()
    "Return non-nil if can trigger native completion."
    (let ((python-shell-completion-native-enable t)
          (python-shell-completion-native-output-timeout
           python-shell-completion-native-try-output-timeout))
      (python-shell-completion-native-get-completions
       (get-buffer-process (current-buffer))
       nil "_"))))

(use-package python-pytest
  :ensure t
  :init
  (global-set-key (kbd "C-c y t") 'python-pytest-popup)
  (global-set-key (kbd "C-c y r") 'python-pytest-repeat)
  (global-set-key (kbd "C-c y F") 'python-pytest-file)
  (global-set-key (kbd "C-c y f") 'python-pytest-function)
  )

(use-package py-autopep8
  :hook(elpy-mode . 'py-autopep8-enable-on-save))

(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
(add-hook 'emacs-lisp-mode-hook 'yas-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'company-mode)

(use-package slime
  :ensure t
  :config
  (setq inferior-lisp-program "/usr/bin/sbcl")
  (setq slime-contribs '(slime-fancy)))

(use-package slime-company
  :ensure t
  :init
  (require 'company)
  (slime-setup '(slime-fancy slime-company)))

(add-hook 'shell-mode-hook 'yas-minor-mode)
(add-hook 'shell-mode-hook 'flycheck-mode)
(add-hook 'shell-mode-hook 'company-mode)

(defun shell-mode-company-init ()
  (setq-local company-backends '((company-shell
                                  company-shell-env
                                  company-etags
                                  company-dabbrev-code))))

(use-package company-shell
  :ensure t
  :config
  (require 'company)
  (add-hook 'shell-mode-hook 'shell-mode-company-init))

(use-package web-mode
  :ensure t
  )

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (smart-semicolon-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

 ;; allow support of tsx files
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
;; enable typescript-tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)

 ;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)


 ;;lint
(setq tide-format-options '(
:insertSpaceAfterFunctionKeywordForAnonymousFunctions t
:placeOpenBraceOnNewLineForFunctions nil )
)
(setq-default indent-tabs-mode nil)
(setq typescript-indent-level 2)
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)
(setq web-mode-indent-style 2)
(add-hook 'html-mode-hook
          (lambda()
            (setq sgml-basic-offset 2)
            (setq tab-width 2)
            (setq indent-tabs-mode t)
            (setq web-mode-enable-current-column-highlight t)
            (setq web-mode-enable-current-element-highlight t)))

(use-package fill-column-indicator
  :ensure t
  )

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq-default fill-column 79)

(if (fboundp 'display-line-numbers-mode)
    (use-package display-line-numbers
      :ensure nil
      :hook
      (prog-mode . display-line-numbers-mode)
      (org-mode . display-line-numbers-mode)))

;; --------------------------------------
(global-anzu-mode +1)
(global-set-key [remap query-replace] 'anzu-query-replace)
(global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp)
;; (add-hook 'after-init-hook ;;'global-emojify-mode 1)

;; HELM

;; helm from https://github.com/emacs-helm/helm
(require 'helm)

(require 'helm-config)
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x r b") 'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") 'helm-find-files)


(require 'helm-swoop)

;; Change the keybinds to whatever you like :)
(global-set-key (kbd "M-i") 'helm-swoop)
(global-set-key (kbd "M-I") 'helm-swoop-back-to-last-point)
(global-set-key (kbd "C-c M-i") 'helm-multi-swoop)
(global-set-key (kbd "C-x M-i") 'helm-multi-swoop-all)

;; When doing isearch, hand the word over to helm-swoop
(define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
;; From helm-swoop to helm-multi-swoop-all
(define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)
;; When doing evil-search, hand the word over to helm-swoop
;; (define-key evil-motion-state-map (kbd "M-i") 'helm-swoop-from-evil-search)

;; Instead of helm-multi-swoop-all, you can also use helm-multi-swoop-current-mode
(define-key helm-swoop-map (kbd "M-m") 'helm-multi-swoop-current-mode-from-helm-swoop)

;; Move up and down like isearch
(define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
(define-key helm-swoop-map (kbd "C-s") 'helm-next-line)
(define-key helm-multi-swoop-map (kbd "C-r") 'helm-previous-line)
(define-key helm-multi-swoop-map (kbd "C-s") 'helm-next-line)

;; Save buffer when helm-multi-swoop-edit complete
(setq helm-multi-swoop-edit-save t)

;; If this value is t, split window inside the current window
(setq helm-swoop-split-with-multiple-windows nil)

;; Split direcion. 'split-window-vertically or 'split-window-horizontally
(setq helm-swoop-split-direction 'split-window-horizontally)

;; If nil, you can slightly boost invoke speed in exchange for text color
(setq helm-swoop-speed-or-color nil)

;; ;; Go to the opposite side of line from the end or beginning of line
(setq helm-swoop-move-to-line-cycle t)

;; Optional face for line numbers
;; Face name is `helm-swoop-line-number-face`
(setq helm-swoop-use-line-number-face t)

;; If you prefer fuzzy matching
(setq helm-swoop-use-fuzzy-match t)

(global-set-key [f8] 'neotree-toggle)

(require 'rainbow-mode)
(add-hook 'prog-mode-hook 'rainbow-mode)

(use-package sphinx-doc)
(add-hook 'prog-mode-hook 'sphinx-doc-mode)

(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
              (ggtags-mode 1))))

(add-hook 'php-mode-hook '
	  (lambda () (setq c-basic-offset 2)))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(defun split-and-follow-horizontally ()
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

(use-package magit
  :ensure t
  :config
  (setq magit-push-always-verify nil)
  (setq git-commit-summary-max-length 50)
  :bind
  ("<f5>" . magit-status)
  ("C-<f5>" . magit-log-all)
  )

(use-package magit-gitflow
  :hook (magit-mode-hook . turn-on-magit-gitflow)
)

(use-package git-gutter
  :ensure t
  :diminish git-gutter-mode
  :config (global-git-gutter-mode))

(use-package sudo-edit
  :ensure t
  :bind
  ("C-c s e" . sudo-edit))

(setq org-ellipsis " ")
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
(setq org-confirm-babel-evaluate nil)
(setq org-export-with-smart-quotes t)
(setq org-src-window-setup 'current-window)
(setq org-catch-invisible-edits 'show-and-error)
(setq org-cycle-separator-lines 0)
(add-hook 'org-mode-hook 'org-indent-mode)

(use-package htmlize
  :ensure t)

(add-hook 'org-mode-hook
	  '(lambda ()
	     (visual-line-mode 1)))

(global-set-key (kbd "C-c '") 'org-edit-src-code)

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode))))

(add-to-list 'org-structure-template-alist
             '("el" "#+BEGIN_SRC emacs-lisp\n?\n#+END_SRC"))

(when (file-directory-p "/usr/share/emacs/site-lisp/tex-utils")
  (add-to-list 'load-path "/usr/share/emacs/site-lisp/tex-utils")
  (require 'xdvi-search))

(defun todo-visit ()
  (interactive)
  (find-file "~/notes.org"))
(global-set-key (kbd "C-c t") 'todo-visit)

(setq org-todo-keywords '((sequence "TODO" "WIP" "BLOCKED" "DONE")))

(use-package diminish
  :ensure t
  :init
  (diminish 'which-key-mode)
  (diminish 'linum-relative-mode)
  (diminish 'hungry-delete-mode)
  (diminish 'visual-line-mode)
  (diminish 'subword-mode)
  (diminish 'beacon-mode)
  (diminish 'irony-mode)
  (diminish 'page-break-lines-mode)
  (diminish 'auto-revert-mode)
  (diminish 'rainbow-delimiters-mode)
  (diminish 'rainbow-mode)
  (diminish 'yas-minor-mode)
  (diminish 'flycheck-mode)
  (diminish 'helm-mode))

(defun copy-to-clipboard ()
  (interactive)
  (if (display-graphic-p)
      (progn
        (message "Yanked region to x-clipboard!")
        (call-interactively 'clipboard-kill-ring-save)
        )
    (if (region-active-p)
        (progn
          (shell-command-on-region (region-beginning) (region-end) "xsel -i -b")
          (message "Yanked region to clipboard!")
          (deactivate-mark))
      (message "No region active; can't yank to clipboard!"))))
(setq x-select-enable-clipboard nil)
(defun paste-from-clipboard ()
  (interactive)
  (setq x-select-enable-clipboard t)
  (yank)
  (setq x-select-enable-clipboard nil))

(global-set-key (kbd "M-c") 'copy-to-clipboard)
(global-set-key (kbd "M-v") 'paste-from-clipboard)

(use-package fill-column-indicator
  :ensure t
  :diminish ""
  )

(setq-default indent-tabs-mode nil)
(use-package dtrt-indent
  :ensure t
  :diminish ""
  :config
  (progn
    (add-hook 'prog-mode-hook (lambda ()  (dtrt-indent-mode 1)))))

(use-package dumb-jump
  :ensure t
  :init
  (dumb-jump-mode)
  :bind (("M-g o" . dumb-jump-go-other-window)
         ("M-g j" . dumb-jump-go)
         ("M-g x" . dumb-jump-go-prefer-external)
         ("M-g z" . dumb-jump-go-prefer-external-other-window))
  :config (setq dumb-jump-selector 'helm)
  )

(use-package key-chord
  :ensure t
  :config
  (key-chord-define-global "JJ" 'avy-goto-word-1)
  (key-chord-define-global "JL" 'avy-goto-line)
  (key-chord-define-global "JK" 'avy-goto-char)
  (key-chord-define-global "JJ" 'crux-switch-to-previous-buffer)
  (key-chord-define-global "XX" 'execute-extended-command)
  (key-chord-define-global "YY" 'browse-kill-ring)
  (key-chord-define-global "VV" 'helm-M-x)
  (key-chord-define-global "FF" 'helm-find-files)
  (key-chord-define-global "PP" 'projectile-switch-project)
  (key-chord-define-global "PF" 'projectile-find-file)
  (key-chord-define-global "PS" 'projectile-ag)
  (key-chord-define-global "PR" 'projectile-replace)

  (key-chord-mode +1))

(use-package restclient
  :ensure t
  :defer t
)

(use-package pretty-mode
  :ensure t
  :config
  (global-pretty-mode t)
)

(use-package log4j-mode
  :ensure t
  :defer t
)

(use-package epoch-view
  :ensure t
  :defer t
)

(use-package theme-magic
  :ensure t
  :defer t
)

(use-package github-review
  :ensure t
  :defer t
)

(use-package forge
  :ensure t
  :defer t
)
