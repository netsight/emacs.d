;;; init.el --- Init file for Netsight development. -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Initialize Emacs configuration.
;;

;;; Code:

;; Setup load-path
(add-to-list 'load-path (locate-user-emacs-file "lisp"))

;; Turn off UI clutter
(mapc
 (lambda (mode)
   (when (fboundp mode)
     (funcall mode -1)))
 '(menu-bar-mode tool-bar-mode scroll-bar-mode))

;; Setup package management (Cask)
(require 'cask "~/.cask/cask.el")
(cask-initialize)
(setq package-enable-at-startup nil)
(package-initialize)

(require 'pallet)
(require 'f)
(require 's)
(require 'use-package)

;; Package configuration
(use-package netsight-defuns :load-path "lisp")
(use-package netsight
  :load-path "lisp"
  :config
  (progn
    (declare-function global-netsight-mode netsight nil)
    (add-hook 'after-init-hook #'global-netsight-mode)))

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
    (setq flycheck-python-flake8-executable "flake8")
    (setq flycheck-flake8-maximum-line-length 79)
    (setq flycheck-highlighting-mode 'lines))
  :init
  (progn
    (declare-function flycheck-next-error flycheck nil)
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
  :init (progn
	  (declare-function jedi:goto-definition jedi nil)
	  (declare-function jedi:related-names jedi nil)
	  (declare-function jedi:show-doc jedi nil))
  :bind (("C-." . jedi:goto-definition)
	 ("C-c r" . jedi:related-names)
	 ("C-?" . jedi:show-doc)))

(use-package ls-lisp
  :config (setq ls-lisp-use-insert-directory-program nil))

(use-package magit
  :diminish magit-auto-revert-mode)

(use-package mardown-mode
  :mode (("\\.md$" . markdown-mode)))

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
  :mode (("\\.xml$" . nxml-mode)
         ("\\.zcml$" . nxml-mode))
  :config
  (progn
    (add-hook 'nxml-mode-hook
	      (lambda ()
		(setq indent-tabs-mode nil)))))

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
  (progn
    (declare-function py-insert-debug netsight nil)
    (setq-default flycheck-flake8rc "~/.config/flake8rc")
    (setq python-check-command "flake8")
    (setq tab-width 4)
    (add-hook 'python-mode-hook
	      (lambda ()
		(pungi:setup-jedi)
		(sphinx-doc-mode t)))))

(use-package pyvenv)

(use-package rst
  :config
  (progn
    (set-fill-column 79)
    (setq rst-adornment-faces-alist
          (quote ((nil . font-lock-keyword-face)
                  (nil . font-lock-keyword-face)
                  (nil . rst-level-1-face)
                  (2 . rst-level-2-face)
                  (3 . rst-level-3-face)
                  (4 . rst-level-4-face)
                  (5 . rst-level-5-face)
                  (nil . rst-level-5-face)))))
  :mode (("\\.rst$" . rst-mode)))

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
  :config (setq sgml-basic-offset 4)
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
