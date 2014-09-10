;;; init.el --- Init file for Netsight development. -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Initialize Emacs configuration.
;;

;;; Code:

;; Setup load-path
(add-to-list 'load-path (locate-user-emacs-file "lisp"))
(add-to-list 'load-path (locate-user-emacs-file "experimental"))

;; Turn off UI clutter
(mapc
 (lambda (mode)
   (when (fboundp mode)
     (funcall mode -1)))
 '(menu-bar-mode tool-bar-mode scroll-bar-mode))

;; Setup package management
(require 'cask "~/.cask/cask.el")
(cask-initialize)
(package-initialize)
(require 'pallet)
(require 'f)
(require 's)
(require 'use-package)

;; Package configuration
(use-package netsight-defuns :load-path "lisp")
(use-package netsight :load-path "lisp")

(use-package bookmark
  :init
  (progn
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
      '("Goto bookmark" . bookmark-jump))))

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
  (progn
    (defadvice dired-readin
      (after dired-after-updating-hook first () activate)
      "Sort dired listings with directories first before adding mark."
      (netsight-sort-directories-first))))

(use-package dired-x
  :config
  (progn
    (setq-default dired-omit-files-p nil)
    (setq dired-omit-files
          (concat dired-omit-files "\\|^\\..+$"))))


(use-package ediff
  :config
  (progn
    (setq ediff-shell (getenv "$SHELL"))
    (setq-default ediff-split-window-function
                  (quote split-window-vertically))))

(use-package editorconfig)

(use-package flycheck
  :bind ("<kp-7>" . flycheck-next-error)
  :config
  (progn
    (setq flycheck-python-flake8-executable "pycheckers.py")
    (setq flycheck-highlighting-mode 'lines))
  :init
  (progn
    (add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode)
    (fringe-mode (quote (4 . 0)))
    (global-flycheck-mode 1)))

(use-package flymake disabled: 't)

(use-package gist)

(use-package git-gutter+)

(use-package google-this)

(use-package js2-mode
  :mode (("\\.js$" . js2-mode))
  :config
  (progn
    (setq-default indent-tabs-mode nil)))

(use-package java-mode
  :mode (("\\.js.dtml$" . java-mode)))

(use-package jedi
  :bind (("C-." . jedi:goto-definition)
	 ("C-c r" . jedi:related-names)
	 ("C-?" . jedi:show-doc)))

(use-package ls-lisp
  :config (setq ls-lisp-use-insert-directory-program nil))

(use-package mule
  :config (setq locale-coding-system 'utf-8)
  :init
  (progn
    (set-language-environment 'utf-8)
    (set-default-coding-systems 'utf-8)
    (set-terminal-coding-system 'utf-8)
    (set-selection-coding-system 'utf-8)
    (prefer-coding-system 'utf-8)))

(use-package nxml-mode
  :config (setq nxml-child-indent 2)
  :mode (("\\.xml$" . nxml-mode)
         ("\\.zcml$" . nxml-mode)))

(use-package paren
  :config (setq show-paren-style 'expression)
  :init (show-paren-mode 1))

(use-package python
  :ensure pungi
  :bind (("<kp-5>" . py-insert-debug)
         ("<f9>" . py-insert-debug)
         ("C-c C-c" . comment-dwim))
  :config
  (progn
	(setq python-check-command "pycheckers.py")
	(setq tab-width 4))
  :mode (("\\.py$" . python-mode)
         ("\\.cpy$" . python-mode)
         ("\\.vpy$" . python-mode)))

(use-package rst
  :config
  (progn
    (setq rst-adornment-faces-alist
          (quote ((nil . font-lock-keyword-face)
                  (nil . font-lock-keyword-face)
                  (nil . rst-level-1-face)
                  (2 . rst-level-2-face)
                  (3 . rst-level-3-face)
                  (4 . rst-level-4-face)
                  (5 . rst-level-5-face)
                  (nil . rst-level-5-face))))))

(use-package sass-mode
  :config (setq sass-indent-offset 2))

(use-package sendmail
  config: (setq-default mail-interactive 't))

(use-package sphinx-doc)

;; Emacs server configuration
;; Allows use with screen
;; Start either gnuserv or emacsserver for external access
(use-package server
  :config
  (progn
    (setq server-socket-dir
          (format "%semacs%d"
                  temporary-file-directory
                  (user-uid)))
    (setq server-use-tcp 't))
  :init
  (progn
    (when (not (or
                (window-system)
                (eq 'windows-nt system-type)))
      (server-start))))

(use-package sgml-mode
  :config (setq sgml-basic-offset 2)
  :mode (("\\.pt$" . sgml-mode)
         ("\\.cpt$" . sgml-mode)
         ("\\.html" . sgml-mode)
         ("\\.htm" . sgml-mode)))

(use-package shell
  config: (setq shell-prompt-pattern "\\u@\\h: \\w $ "))

(use-package sql-mode
  :mode (("\\.zsql$" . sql-mode)
         ("\\.sql$" . sql-mode)))

(use-package text
  :mode (("\\.po$" . text-mode)
	 ("\\.pot$" . text-mode)))

(use-package vc)

;; Ensure PATH is preserved from shell.
(exec-path-from-shell-initialize)

;; Setup hooks for various modes.
(add-hook 'python-mode-hook
	  (lambda ()
	    (require 'pungi)
	    (require 'sphinx-doc)
	    (sphinx-doc-mode t)))


(add-hook 'after-init-hook
	  '(lambda ()
	     (global-netsight-mode)
	     (message "Welcome to netsight-emacs")))

;;; custom user Lisp (from template on first load)
(setq custom-file "~/.emacs-custom.el")
(unless (file-exists-p custom-file)
  (with-current-buffer (get-buffer-create "custom-file")
    (insert-file-contents (locate-user-emacs-file "user-custom-file-template.el") nil 0)
     (write-region (buffer-string) nil custom-file)))
(load custom-file)

(message "Welcome to netsight-emacs")

(provide 'init)
;;; init.el ends here
