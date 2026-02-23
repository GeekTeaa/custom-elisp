;;; vulpea-config.el Just Configuration for Vulpea -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2026 Skye Scott
;;
;; Author: Skye Scott <skyenet@dev-dsk-skyenet-2b-24c153d9.us-west-2.amazon.com>
;; Maintainer: Skye Scott <skyenet@dev-dsk-skyenet-2b-24c153d9.us-west-2.amazon.com>
;; Created: February 19, 2026
;; Modified: February 19, 2026
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/skyenet/vulpea-config
;; Package-Requires: ((emacs "30.2"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  
;;
;;; Code:

(require 'vulpea)
(require 'org)

;; Blatant stealing of the Org-Agenda Vulpea configuration
;; ref: https://www.d12frosted.io/posts/2020-06-23-task-management-with-roam-vol1
(defun vulpea-agenda-category (&optional len)
  "Get category of item at point for agenda.

Category is defined by one of the following items:

- CATEGORY property
- TITLE keyword
- TITLE property
- filename without directory and extension

When LEN is a number, resulting string is padded right with
spaces and then truncated with ... on the right if result is
longer than LEN.

Usage example:

  (setq org-agenda-prefix-format
        '((agenda . \" %(vulpea-agenda-category) %?-12t %12s\")))

Refer to `org-agenda-prefix-format' for more information."
  (let* ((file-name (when buffer-file-name
                      (file-name-sans-extension
                       (file-name-nondirectory buffer-file-name))))
         (title (vulpea-buffer-prop-get "title"))
         (category (org-get-category))
         (result
          (or (if (and
                   title
                   (string-equal category file-name))
                  title
                category)
              "")))
    (if (numberp len)
        (s-truncate len (s-pad-right len " " result))
      result)))
                                                                                                                                                                                                                                                                                                                                                                                               
(defun vulpea-ensure-filetag ()
  "Add respective file tag if it's missing in the current note."
  (interactive)
  (let ((tags (vulpea-buffer-tags-get))
        (tag (vulpea--title-as-tag)))
    (when (and (seq-contains-p tags "people")
               (not (seq-contains-p tags tag)))
      (vulpea-buffer-tags-add tag))))

(defun vulpea--title-as-tag ()
  "Return title of the current note as tag."
  (vulpea--title-to-tag (vulpea-buffer-title-get)))

(defun vulpea--title-to-tag (title)
  "Convert TITLE to tag."
  (concat "@" (s-replace " " "" title)))

(defun vulpea-tags-add ()
  "Add a tag to current note."
  (interactive)
  ;; since https://github.com/org-roam/org-roam/pull/1515
  ;; `org-roam-tag-add' returns added tag, we could avoid reading tags
  ;; in `vulpea-ensure-filetag', but this way it can be used in
  ;; different contexts while having simple implementation.
  (when (call-interactively #'org-roam-tag-add)
    (vulpea-ensure-filetag)))


;; Not super thrilled with the "people" popping up all the time. I think this
;; hard coding is bad.
(defun org-roam-node-insert-wrapper (fn &rest args)
  "Insert a link to the note using FN.

If inserted node has PEOPLE tag on it, tag the current outline
accordingly."
  (when-let* ((node (org-roam-node-read))
         (title (org-roam-node-title node))
         (tags (org-roam-node-tags node)))
    ;; The cl-letf temporarily overrides org-roam-node-read to always return the
    ;; node you already selected, so when org-roam-node-insert internally calls
    ;; org-roam-node-read, it gets your pre-selected nodewithout prompting
    ;; again. This is a cludge.
    (cl-letf (((symbol-function 'org-roam-node-read)
               (lambda (&rest _) node)))
      (apply fn args))
    (when (seq-contains-p tags "people")
      (save-excursion
        (ignore-errors
          (org-back-to-heading)
          (org-set-tags
           (seq-uniq
            (cons
             (vulpea--title-to-tag title)
             (org-get-tags nil t)))))))))



(advice-add
 #'org-roam-node-insert
 :around
 #'org-roam-node-insert-wrapper)

(defun my-vulpea-insert-handle (note)
  "Hook to be called on NOTE after `vulpea-insert'."
  (when-let* ((title (vulpea-note-title note))
              (tags (vulpea-note-tags note)))
    (when (seq-contains-p tags "people")
      (save-excursion
        (ignore-errors
          (org-back-to-heading)
          (when (eq 'todo (org-element-property
                           :todo-type
                           (org-element-at-point)))
            (org-set-tags
             (seq-uniq
              (cons
               (vulpea--title-to-tag title)
               (org-get-tags nil t))))))))))

(add-hook 'vulpea-insert-handle-functions
          #'my-vulpea-insert-handle)



;;; vulpea-config.el ends here
