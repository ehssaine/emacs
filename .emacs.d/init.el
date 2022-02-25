;; init.el --- Emacs configuration

;; EMACS AUTO AUTH PROXY
;; --------------------------------------
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

(setenv "PYTHONPATH" "/usr/bin/python3.9")

(use-package elpy
  :init (advice-add 'python-mode :before 'elpy-enable)
  :hook (elpy-mode . (lambda () (add-hook 'before-save-hook 'elpy-format-code)))
  :config (setq elpy-modules (delq 'elpy-module-flymake elpy-modules)))

(use-package flycheck
  :hook (after-init . global-flycheck-mode))

(require 'flymake-python-pyflakes)
(add-hook 'python-mode-hook 'flymake-python-pyflakes-load)

(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

(require 'highlight-symbol)
(global-set-key [(control f3)] 'highlight-symbol)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-query-replace)

(use-package importmagic
    :ensure t
    :config
    (add-hook 'python-mode-hook 'importmagic-mode))

(defadvice ansi-term (after advise-ansi-term-coding-system)
    (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))
(ad-activate 'ansi-term)

(require 'unicode-fonts)
(unicode-fonts-setup)

(require 'auto-virtualenv)
(add-hook 'python-mode-hook 'auto-virtualenv-set-virtualenv)

(add-hook 'python-mode-hook
 (lambda () (define-key python-mode-map (kbd "C-c >") 'indent-tools-hydra/body))
 )

(require 'indent-tools)
(global-set-key (kbd "C-c >") 'indent-tools-hydra/body)
(global-set-key (kbd "C-c i b") 'indent-tools-indent)
(global-set-key (kbd "C-c n s") 'indent-tools-goto-next-sibling)

(setq jit-lock-defer-time 0)
(setq fast-but-imprecise-scrolling t)

(if (version<= "27.1" emacs-version)
    (global-so-long-mode 1))


;; (setq ps-multibyte-buffer :bdf-font-except-latin)

;; (setq bdf-directory-list "/usr/share/emacs/fonts/bdf")

(setq package-check-signature nil)

;; (add-to-list 'load-path              "/home/ehssaine/.emacs.d/elpa/lush-theme-20180816.2200")
;; (add-to-list 'custom-theme-load-path "/home/ehssaine/.emacs.d/elpa/lush-theme-20180816.2200/lush-theme-autoloads.el")

(use-package forge
  :after magit)

;; Load path
;; Optimize: Force "lisp"" and "site-lisp" at the head to reduce the startup time.
;; Create site-lisp directory if it does not exist
(if (not (file-directory-p "~/.emacs.d/site-lisp"))
    (make-directory "~/.emacs.d/site-lisp"))

(defun update-load-path (&rest _)
  "Update `load-path'."
  (dolist (dir '("site-lisp" "lisp"))
    (push (expand-file-name dir user-emacs-directory) load-path)))

(defun add-subdirs-to-load-path (&rest _)
  "Add subdirectories to `load-path'."
  (let ((default-directory (expand-file-name "site-lisp" user-emacs-directory)))
    (normal-top-level-add-subdirs-to-load-path)))

(advice-add #'package-initialize :after #'update-load-path)
(advice-add #'package-initialize :after #'add-subdirs-to-load-path)

(update-load-path)

;; Print welcome message
(defvar current-user
  (getenv
   (if (equal system-type 'windows-nt) "USERNAME" "USER")))

(message "Emacs is powering up... Be patient, Master %s!" current-user)

;; Load proxy settings
(setq proxy-file "~/.emacs.d/site-lisp/proxy.el")
(when (file-exists-p proxy-file)
  (load proxy-file))

;; Make emacs start in fullscreen mode (usefull for EXWM)
(set-frame-parameter nil 'fullscreen 'fullboth)

;;; This fixed garbage collection, makes emacs start up faster ;;;;;;;
(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)

(defvar startup/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(defun startup/revert-file-name-handler-alist ()
  (setq file-name-handler-alist startup/file-name-handler-alist))

(defun startup/reset-gc ()
  (setq gc-cons-threshold 16777216
	gc-cons-percentage 0.1))

(add-hook 'emacs-startup-hook 'startup/revert-file-name-handler-alist)
(add-hook 'emacs-startup-hook 'startup/reset-gc)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; This is all kinds of necessary
(require 'package)
(setq package-enable-at-startup nil)

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;;; remove SC if you are not using sunrise commander and org if you like outdated packages
(setq package-archives '(("ELPA"  . "http://tromey.com/elpa/")
			 ("gnu"   . "http://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(package-refresh-contents)
(package-install 'use-package)

(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

;; Load configuration from settings.org file
(require 'org)
(setq org-src-fontify-natively t
      org-src-tab-acts-natively t
      org-confirm-babel-evaluate nil
      org-edit-src-content-indentation 0)

(org-babel-load-file
 (expand-file-name "settings.org" user-emacs-directory))
(put 'dired-find-alternate-file 'disabled nil)

(add-hook 'after-init-hook (lambda () (load-theme 'spacemacs-dark)))
