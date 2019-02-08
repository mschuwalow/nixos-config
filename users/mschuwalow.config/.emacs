;;================== Add Sources =======================
(require 'package)
(push '("melpa" . "http://melpa.milkbox.net/packages/") package-archives)
(package-initialize)
;; ===================== Require =======================
(add-to-list 'load-path "~/.emacs.d/elisp/")
(set-face-attribute 'default nil :family "Fantasque Sans Mono" :foundry "PfEd" :height 140)

(require 'use-package)
(setq use-package-always-ensure t)

(use-package noctilux-theme
  :config
  (load-theme 'noctilux t))

(use-package powerline
  :config
  (powerline-center-theme))

(use-package helm
  :config
  (setq helm-split-window-in-side-p           t
        helm-buffers-fuzzy-matching           t
        helm-move-to-line-cycle-in-source     t
        helm-ff-search-library-in-sexp        t
        helm-ff-file-name-history-use-recentf t)
  (helm-mode 1)
  :bind
  (("C-c h" . helm-command-prefix)
   ("M-x" . helm-M-x)
   ("C-x C-m" . helm-M-x)
   ("M-y" . helm-show-kill-ring)
   ("C-x b" . helm-mini)
   ("C-x C-b" . helm-buffers-list)
   ("C-x C-f" . helm-find-files)
   ("C-h f" . helm-apropos)
   ("C-h r" . helm-info-emacs)
   ("C-h C-l" . helm-locate-library)
   ("C-C l" . helm-locate)))

(use-package company
  :config
  (setq company-idle-delay 0.3)
  (setq company-tooltip-limit 10)
  (setq company-minimum-prefix-length 2)
  ;; invert the navigation direction if the the completion popup-isearch-match
  ;; is displayed on top (happens near the bottom of windows)
  (setq company-tooltip-flip-when-above t)
  (global-company-mode 1))

(use-package magit)

;; (use-package smooth-scrolling
;;   :config
;;   (setq smooth-scroll-margin 5))
  
(use-package undo-tree
  :config
  (global-undo-tree-mode))

(use-package hiwin
  :config
  (hiwin-mode 1))

;; (use-package ediprolog)

(use-package zop-to-char)

(use-package smartparens
  :config
  (smartparens-global-mode))

(use-package yasnippet
  :config
  (yas-reload-all)
  (yas-global-mode 1))

;;(use-package java-snippets)

(use-package yalinum
  :config
  (yas-reload-all)
  (set-face-attribute 'yalinum-bar-face nil :background "gray20" :foreground "gray85" :height 120)
  (set-face-attribute 'yalinum-face nil :background "black" :foreground "gray70" :height 120)
  (add-hook 'prog-mode-hook 'yalinum-mode)
  (add-hook 'text-mode-hook 'yalinum-mode))

(use-package rainbow-delimiters
  :config
  (rainbow-delimiters-mode)
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package fish-mode
  :mode "\\.fish\\'")

(use-package auctex
  :config
  :mode ("\\.tex\\'" . TeX-latex-mode))

(use-package org)

(use-package ox-reveal)

(use-package projectile
  :config
  (projectile-global-mode))

(use-package helm-projectile
  :config
  (helm-projectile-on))

(use-package auto-complete
  :config
  (global-auto-complete-mode 1)
  (ac-config-default))

;; (use-package ac-ispell
;;   :config
;;   (ac-ispell-setup)
;;   (setq ac-auto-show-menu 0.3
;;         ac-auto-start t
;;         ))

;; (defun my-ac-ispell-complete ()
;;   (interactive)
;;   (auto-complete (list ac-source-ispell)))
;; (global-set-key (kbd "C-M-i") #'my-ac-ispell-complete)
;; (defun enable-my-complete ()
;;   (interactive)
;;   (local-set-key (kbd "C-M-i") #'my-ac-ispell-complete))
;; (add-hook 'text-mode-hook #'enable-my-complete)
;; (add-hook 'prog-mode-hook #'enable-my-complete)
;; (add-hook 'TeX-mode-hook #'enable-my-complete)

(use-package fontawesome)

;;=================== Minor Modes =====================

(setq auto-mode-alist (cons '(".*\\.pl$" . prolog-mode) auto-mode-alist))
;;(setq auto-mode-alist (cons '(".*\\.tex$" . TeX-mode) auto-mode-alist))

;;=================== Custom Settings =================

;; Hide Start Screen
(setq inhibit-startup-message t)

;; Remove fringes
(fringe-mode '(3 . 0))

;; Set the highlight current line minor mode
(global-hl-line-mode 1)

;; Disable Menubar
(menu-bar-mode 0)

;;Disable Toolbar
(tool-bar-mode 0)

;; Disable Scrollbar
(scroll-bar-mode 0)

;;Highlight matching parens
(show-paren-mode 1)

;; Smooth Scrolling
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-conservatively 101)

;; Enable global auto-revert-mode
(global-auto-revert-mode 1)

;; set tab size to 4
(setq-default tab-width 4)

;; Show line-number in the mode line
(line-number-mode 1)

;; Show column-number in the mode line
(column-number-mode 1)

;; Make Text mode the default mode for new buffers
(setq default-major-mode 'text-mode)

;; ========== Set Custom Backup Directory ==========
;; Place Backup Files in Specific Directory
(setq
 backup-by-copying t      ; don't clobber symlinks
 backup-directory-alist
 '(("." . "~/.emacs.d/saves"))    ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)

;;=================== Fabian File Openener (Needs custom-set-variables block) ===================
(defvar external-file-types (list "pdf" "mkv" "mp4" "avi"))
(defcustom external-file-types (list "pdf" "mkv" "mp4" "avi") "Files to open externally")
(defun emacs-or-external-viewer (file)
  (let ( (extensions (mapcar #'(lambda (ext) (concat "^.*\\." ext "$")) external-file-types)) )
    (find file extensions :test #'(lambda (f regex) (string-match-p regex file) ))
    )
  )

(defun sane-open-file (file)
  (if (emacs-or-external-viewer file)
      (helm-open-file-externally file)
    (helm-find-file-or-marked file)))

;;====== Reload .emacs =================

(defun reload-dotemacs-file ()
  "reload your .emacs file without restarting Emacs"
  (interactive)
  (load-file "~/.emacs") )

;;====== Switch to Root =================

(defun sudired ()
  (interactive)
  (require 'tramp)
  (let ((dir (expand-file-name default-directory)))
    (if (string-match "^/sudo:" dir)
        (user-error "Already in sudo")
      (dired (concat "/sudo::" dir)))))
(define-key dired-mode-map "!" 'sudired)

;; ===== Function to delete a line =====

;; First define a variable which will store the previous column position
(defvar previous-column nil "Save the column position")

;; Define the nuke-line function. The line is killed, then the newline
;; character is deleted. The column which the cursor was positioned at is then
;; restored. Because the kill-line function is used, the contents deleted can
;; be later restored by usibackward-delete-char-untabifyng the yank commands.
(defun nuke-line()
  "Kill an entire line, including the trailing newline character"
  (interactive)

  ;; Store the current column position, so it can later be restored for a more
  ;; natural feel to the deletion
  (setq previous-column (current-column))

  ;; Now move to the end of the current line
  (end-of-line)

  ;; Test the length of the line. If it is 0, there is no need for a
  ;; kill-line. All that happens in this case is that the new-line character

  ;; is deleted.
  (if (= (current-column) 0)
      (delete-char 1)

    ;; This is the 'else' clause. The current line being deleted is not zero
    ;; in length. First remove the line by moving to its start and then
    ;; killing, followed by deletion of the newline character, and then
    ;; finally restoration of the column position.
    (progn
      (beginning-of-line)
      (kill-line)
      (delete-char 1)
      (move-to-column previous-column))))

;; Now bind the delete line function to the F8 key
(global-set-key [f8] 'nuke-line)

;;======================= Launch terminal in Current Dir ========================
(setq async-shell-command-buffer (quote rename-buffer))
(setq display-buffer-alist
 (quote
  ((".*Async Shell Command.*" display-buffer-no-window
    (nil)))))
(defun start-term ()
  (interactive)
  (async-shell-command "sakura")
  )
(global-set-key (kbd "C-x +") 'start-term)

;;======================== Set Spellchecker ========================
(setq ispell-program-name "hunspell")
;; below two lines reset the the hunspell to it STOPS querying locale!
(setq ispell-local-dictionary "en_US") ; "en_US" is key to lookup in `ispell-local-dictionary-alist`

;;=========================== Additional Keybindings =============================
;; Align your code in a pretty way.
(global-set-key (kbd "C-x \\") 'align-regexp)

;; Font size
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; Window switching. (C-x o goes to the next window)
(global-set-key (kbd "C-x O") (lambda ()
                                (interactive)
                                (other-window -1))) ;; back one

(global-set-key (kbd "C-x -") 'eshell)

;; A complementary binding to the apropos-command (C-h a)
(define-key 'help-command "A" 'apropos)

;; A quick major mode help with discover-my-major
(define-key 'help-command (kbd "C-m") 'discover-my-major)
(define-key 'help-command (kbd "C-f") 'find-function)
(define-key 'help-command (kbd "C-k") 'find-function-on-key)
(define-key 'help-command (kbd "C-v") 'find-variable)
(define-key 'help-command (kbd "C-l") 'find-library)
(define-key 'help-command (kbd "C-i") 'info-display-manual)

;; replace zap-to-char functionality with the more powerful zop-to-char
(global-set-key (kbd "M-z") 'zop-up-to-char)
(global-set-key (kbd "M-Z") 'zop-to-char)

;; Movement Commands
(global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "<home>") 'beginning-of-buffer)
(global-set-key (kbd "<end>") 'end-of-buffer)

;; kill lines backward
(global-set-key (kbd "C-<backspace>") (lambda ()
                                        (interactive)
                                        (kill-line 0)
                                        (indent-according-to-mode)))

;; Activate occur easily inside isearch
(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)

;; use hippie-expand instead of dabbrev
(global-set-key (kbd "M-/") 'hippie-expand)

;; replace buffer-menu with ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; toggle menu-bar visibility
(global-set-key (kbd "<f12>") 'menu-bar-mode)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "C-c j") 'avy-goto-word-or-subword-1)
(global-set-key (kbd "s-.") 'avy-goto-word-or-subword-1)
(global-set-key (kbd "s-w") 'ace-window)

;;============== load customizations ==============

(setq custom-file "~/.emacs-custom")
(load custom-file)
