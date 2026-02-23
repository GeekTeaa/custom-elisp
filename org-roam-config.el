;;; org-roam-config.el --- Configuration for Org-roam -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2026 Skye Scott
;;
;; Author: Skye Scott <skyenet@dev-dsk-skyenet-2b-24c153d9.us-west-2.amazon.com>
;; Maintainer: Skye Scott <skyenet@dev-dsk-skyenet-2b-24c153d9.us-west-2.amazon.com>
;; Created: February 20, 2026
;; Modified: February 20, 2026
;; Version: 0.0.1
;; Package-Requires: ((emacs "30.2") (org-roam "2.0"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;; Configuration for org-roam buffer naming.
;;
;;; Code:

;; (require 'org-roam)
;; 
;; (defun org-roam-buffer-name ()
;;   "Rename org-roam buffer to roam/FILENAME_WITHOUT_ID.org.
;; Only applies to files with an org-roam ID property."
;;   (when (and buffer-file-name
;;              (org-roam-file-p)
;;              (org-roam-id-at-point))
;;     (let* ((filename (file-name-nondirectory buffer-file-name))
;;            (name-without-id (replace-regexp-in-string
;;                              "^[0-9]+-" ""
;;                              filename)))
;;       (rename-buffer (concat "roam/" name-without-id) t))))
;; 
;; (add-hook 'org-mode-hook #'org-roam-buffer-name)

;;; org-roam-config.el ends here
