;;;  SCCS: @(#)90/12/12 qprolog.el    2.3
;;;		    Quintus Prolog - GNU Emacs Interface
;;;                         Support Functions
;;;
;;;	            Consolidated by Sitaram Muralidhar
;;;
;;;		           sitaram@quintus.com
;;;		      Quintus Computer Systems, Inc.
;;;			      2 May 1989	   
;;;
;;; This file defines functions that support the Quintus Prolog - GNU Emacs
;;; interface.
;;;
;;;			       Acknowledgements
;;;
;;;
;;; This interface was made possible by contributions from Fernando
;;; Pereira and various customers of Quintus Computer Systems, Inc.,
;;; based on code for Quintus's Unipress Emacs interface.
;;; Functions for moving around a prolog source buffer

(provide 'prolog)
(defmacro first-line ()
  (save-excursion (beginning-of-line) (bobp)))

(defmacro last-line ()
  (save-excursion (end-of-line) (eobp)))

(defun skip-prolog-comment (range)
  (let ((current-location (point)))
  (if (save-excursion 
	(beginning-of-line)
	(search-forward "%" current-location t))
      (progn (skip-prolog-%-comment range) t)
    (not (skip-prolog-/*-*/-comment range)))))

(defun skip-prolog-%-comment (range)
  "Skip to the beginning or end of a prolog comment depending
on if the range is before or after the point in"
  (let* ((forward (> (point) range))
	 (line-skip (if forward -1 1))
	 (in-comment t))
    (while (and in-comment (not (bobp)) (not (eobp)))
      (previous-line line-skip)
      (beginning-of-line)
      (setq in-comment (= (following-char) ?%)))))

(defun skip-prolog-/*-*/-comment (range)
"Skip to the beginning or end of a prolog comment depending
on if the range is before or after the point"
  (let* ((current-point (point))
         (forward (> current-point range)))
      (if forward
	  (if (search-backward "\/*" range t)
	      (not (search-forward "*\/"))
	    t)
	(if (search-forward "*\/" range t)
	    (not (search-backward "\/*"))
	  t))))


(defun beginning-of-clause (&optional arg)
  "Move backward to next beginning-of-clause.
With argument, do this that many times.
Returns t unless search stops due to end of buffer."
  (interactive "p")
  (and arg (< arg 0) (forward-char 1))
  (let ((clause-point (point)) (not-done t) (command-point (point)))
    (while (and not-done (not (bobp)))
      (if (and arg (< arg 0))
      (skip-chars-forward " \t\n")
      (skip-chars-backward " \t\n"))
      (if (re-search-backward "^\\S-" nil 'move (or arg 1))
	  (if (= (following-char) ?%)
	      (skip-prolog-%-comment clause-point)
	    (setq not-done (not (skip-prolog-/*-*/-comment clause-point)))))
      (setq clause-point (point)))
    )
  )

(defun end-of-clause (&optional arg)
  "Move forward to next end of prolog clause."
  (interactive "p")
  (and arg (< arg 0) (forward-char 1))
  (let ((clause-point (point)) (not-done t) (command-point (point)))
    (while (and not-done (not (eobp)))
      (re-search-forward "[^.]\\.\\(\\s-\\)*$" nil 'move (or arg 1))
      (setq not-done (skip-prolog-comment clause-point))
      (setq clause-point (point)))
    (if not-done (progn (goto-char command-point) (beep)))))

(defun mark-clause ()
  (interactive)
  (end-of-clause)
  (set-mark (point))
  (beginning-of-clause)
  (message "Clause marked")
)

(defun kill-clause ()
"Kill the prolog clause that the point in currently in"
  (interactive)
  (mark-clause)
  (kill-region (point) (mark)))

(defun insert-rcs-header ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (insert-string *rcs-header*)
    ))

(defvar *rcs-header*
"/*
   jan
   1992/05/26 11:51:43
   1.1.1.1
   qprolog.el,v
; Revision 1.1.1.1  1992/05/26  11:51:43  jan
; Initial CVS
;
; Revision 1.1.1.1  1992/05/25  18:50:48  jan
; Initial cvs version
;
*/
:- add_rcsid(
	    '/staff/jan/CVS/pl/lisp/qprolog.el,v',
	    '/staff/jan/CVS/pl/lisp/qprolog.el,v 1.1.1.1 1992/05/26 11:51:43 jan Exp'
	    ).
"
)

(defun check-for-module-change (start end) 
  (save-excursion
    (goto-char start)
    (if (looking-at " *module(\\(.*\\))")
	(let ((module-name (buffer-substring (match-beginning 1) (match-end 1)))
	      (module-elm (assq 'prolog-module minor-mode-alist)))
	  (message "Switching to module %s" module-name)
	  (setq mode-name (concat "Inferior Prolog: " module-name))
	  (set-buffer-modified-p (buffer-modified-p)) ;No-op, but updates mode line.
	  )
      )
    )
  )

(defun module-name ()
  (save-excursion
    (goto-char (point-min))
    (if (search-forward "module(" nil t)
	(let ((module-start (point)))
	  (if (search-forward "," nil t)
	      (progn
		(backward-char 1)
		(buffer-substring module-start (point)))
	    (error "Ill formed module definition"))))))
