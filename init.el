;;; init.el --- Init file for Netsight development. -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Initialize Emacs configuration.
;;

;;; Code:

;; Setup package management (Cask)
(require 'cask "~/.cask/cask.el")
(cask-initialize)
(setq package-enable-at-startup nil)
(package-initialize)

(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)
(require 'pallet)
(require 'f)
(require 's)

;; Package configuration

(use-package netsight
  :load-path "lisp"
  :diminish netsight-mode
  :config
  (declare-function global-netsight-mode netsight nil)
  (add-hook 'after-init-hook #'global-netsight-mode)
  ;; Turn off UI clutter
  (mapc
   (lambda (mode)
     (when (fboundp mode)
       (funcall mode -1)))
   '(menu-bar-mode tool-bar-mode scroll-bar-mode))

  ;; Set misc settings.
  (setq-default indent-line-function 'insert-tab)
  (setq indent-tabs-mode nil)
  (setq tab-always-indent nil)

  ;; scrolling - do not add newlines when cursoring past last line in file
  (setq scroll-step 1)
  (setq next-line-add-newlines nil)

  ;; Display
  (global-linum-mode 0)
  (setq fill-column 79)
  (setq transient-mark-mode 't)
  (setq column-number-mode t)
  (setq inhibit-startup-message t)
  (setq search-highlight t)
  (setq query-replace-highlight t)

  ;; Desktop mode
  ;; Useful for remembering a set of file you're working on -
  ;;  - enables switching between projects and keeping state.
  (setq desktop-save-mode t)

  ;; Misc settings
  (setq mail-interactive t)

  ;; Annoyance factor
  (fset 'yes-or-no-p 'y-or-n-p)
  (setq redisplay-dont-pause 't)
  (setq font-lock-verbose nil)
  (setq confirm-nonexistent-file-or-buffer nil)

  ;; Un-disable some 'dangerous!' commands
  (put 'upcase-region 'disabled nil)
  (put 'downcase-region 'disabled nil)
  (put 'narrow-to-region 'disabled nil)
  (put 'narrow-to-page 'disabled nil))

(use-package bookmark
  :config
  (define-key global-map [menu-bar bookmarks]
    (cons "Bookmarks" (make-sparse-keymap "Bookmarks")))
  (define-key global-map
    [menu-bar bookmarks bookmark-insert]
    '("Insert bookmark into buffer" . bookmark-insert))
  (define-key global-map
    [menu-bar bookmarks bookmark-delete]
    '("Delete bookmark" . bookmark-delete))
  (define-key global-map
    [menu-bar bookmarks bookmark-save]
    '("Save bookmarks" . bookmark-save))
  (define-key global-map
    [menu-bar bookmarks list-bookmarks]
    '("List bookmarks" . list-bookmarks))
  (define-key global-map
    [menu-bar bookmarks bookmark-set]
    '("Add bookmark" . bookmark-sebt))
  (define-key global-map
    [menu-bar bookmarks bookmark-jump]
    '("Goto bookmark" . bookmark-jump)))

(use-package browse-kill-ring
  :bind ("<kp-8>" . browse-kill-ring))

(use-package conf-mode
  :mode (("\\.conf" . conf-mode)
         ("\\.cfg" . conf-mode)
         ("\\.ini" . conf-mode)))

(use-package css-mode
  :mode (("\\.kss$" . css-mode)
         ("\\.css.dtml$". css-mode)))

(use-package dired
  :config
  (defadvice dired-readin
      (after dired-after-updating-hook first () activate)
    "Sort dired listings with directories first before adding mark."
    (netsight-sort-directories-first)))

(use-package dired-x
  :config
  (setq-default dired-omit-files-p nil)
  (setq dired-omit-files
	(concat dired-omit-files "\\|^\\..+$")))


(use-package ediff
  :config
  (setq ediff-shell (getenv "$SHELL"))
  (setq-default ediff-split-window-function
		(quote split-window-vertically)))

(use-package editorconfig)

(use-package flycheck
  :bind ("<kp-7>" . flycheck-next-error)
  :preface
  (declare-function flycheck-next-error flycheck nil)
  (add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode)
  (fringe-mode (quote (4 . 0)))
  (global-flycheck-mode 1)
  :config
  (setq flycheck-python-flake8-executable "flake8")
  (setq flycheck-flake8-maximum-line-length 79)
  (setq flycheck-highlighting-mode 'lines))

(use-package flymake :disabled 't)

(use-package gist)

(use-package git-gutter+)

(use-package google-this)

(use-package js2-mode
  :mode (("\\.js$" . js2-mode))
  :config
  (setq-default indent-tabs-mode nil))

(use-package java-mode
  :mode (("\\.js.dtml$" . java-mode)))

(use-package jedi
  :preface
  (declare-function jedi:goto-definition jedi nil)
  (declare-function jedi:related-names jedi nil)
  (declare-function jedi:show-doc jedi nil)
  :bind (("C-." . jedi:goto-definition)
	 ("C-c r" . jedi:related-names)
	 ("C-?" . jedi:show-doc)))

(use-package ls-lisp
  :config (setq ls-lisp-use-insert-directory-program nil))

(use-package magit
  :diminish magit-auto-revert-mode
  :config
  (setq magit-last-seen-setup-instructions "1.4.0"))

(use-package mardown-mode
  :mode (("\\.md$" . markdown-mode)))

(use-package mule
  :config (setq locale-coding-system 'utf-8)
  :init
  (set-language-environment 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-selection-coding-system 'utf-8)
  (prefer-coding-system 'utf-8))

(use-package nxml-mode
  :mode (("\\.xml$" . nxml-mode)
         ("\\.zcml$" . nxml-mode))
  :config
  (add-hook 'nxml-mode-hook
	    (lambda ()
	      (setq indent-tabs-mode nil))))

(use-package paren
  :config (setq show-paren-style 'expression)
  :init (show-paren-mode 1))

(use-package python
  :ensure pungi
  :bind (("<kp-5>" . py-insert-debug)
         ("<f9>" . py-insert-debug))
  :mode (("\\.py$" . python-mode)
         ("\\.cpy$" . python-mode)
         ("\\.vpy$" . python-mode))
  :config
  (declare-function py-insert-debug netsight nil)
  (setq-default flycheck-flake8rc "~/.config/flake8rc")
  (setq python-check-command "flake8")
  (setq tab-width 4)
  (pungi:setup-jedi)
  (sphinx-doc-mode t))

(use-package pyvenv)

(use-package rst
  :config
  (set-fill-column 79)
  (setq rst-adornment-faces-alist
	(quote ((nil . font-lock-keyword-face)
		(nil . font-lock-keyword-face)
		(nil . rst-level-1-face)
		(2 . rst-level-2-face)
		(3 . rst-level-3-face)
		(4 . rst-level-4-face)
		(5 . rst-level-5-face)
		(nil . rst-level-5-face))))
  :mode (("\\.rst$" . rst-mode)))

(use-package sass-mode
  :config (setq sass-indent-offset 2))

(use-package sendmail)

(use-package sphinx-doc)

;; Emacs server configuration
;; Allows use with screen
;; Start either gnuserv or emacsserver for external access
(use-package server
  :config
  (setq server-socket-dir
	(format "%semacs%d"
		temporary-file-directory
		(user-uid)))
  (setq server-use-tcp 't)
  :init
  (when (not (or
	      (window-system)
	      (eq 'windows-nt system-type)))
    (server-start)))

(use-package sgml-mode
  :config (setq sgml-basic-offset 4)
  :mode (("\\.pt$" . sgml-mode)
         ("\\.cpt$" . sgml-mode)
         ("\\.html" . sgml-mode)
         ("\\.htm" . sgml-mode)))

(use-package shell
  :config (setq shell-prompt-pattern "\\u@\\h: \\w $ "))

(use-package sql-mode
  :mode (("\\.zsql$" . sql-mode)
         ("\\.sql$" . sql-mode)))

(use-package text
  :mode (("\\.po$" . text-mode)
	 ("\\.pot$" . text-mode)))

(use-package vc)

(use-package vcl
  :mode (("\\.vcl" . vcl-mode)))

;; Ensure PATH is preserved from shell.
(exec-path-from-shell-initialize)

;;; custom user Lisp (from template on first load)
(defvar user-custom-file "~/.emacs-custom.el")
(unless (file-exists-p user-custom-file)
  (with-current-buffer (get-buffer-create "user-custom-file")
    (insert-file-contents
     (locate-user-emacs-file "user-custom-file-template.el") nil 0)
     (write-region (buffer-string) nil user-custom-file)))
(load user-custom-file)

;; Code generated by using the Emacs *cusomize* interfaces goes to its own file.
(setq custom-file "~/.emacs-customize.el")
(load custom-file)

(provide 'init)
;;; init.el ends here
