;;; -*- coding: utf-8; lexical-binding: t; -*-
;;; majestic-mode.el --- Major mode for Majestic Lisp.

;; Copyright © 2020, Lucas S. Vieira

;; Author: Lucas S. Vieira ( lucasvieira@protonmail.com )
;; Version: 0.1
;; Created: 02 Dec 2020
;; Keywords: languages lisp
;; Homepage:

;; This file is not part of GNU Emacs.

;;; License:

;; This file is distributed under the MIT License. See the `LICENSE` file
;; for details.

;;; Commentary:

;; Major mode for editing Majestic Lisp.

;; inspired by shen-mode
;; https://github.com/eschulte/shen-mode/blob/master/shen-mode.el

(require 'lisp-mode)
(require 'imenu)

(defcustom majestic-mode-hook '(turn-on-eldoc-mode)
  "Normal hook run when entering `majestic-mode'."
  :type 'hook
  :group 'majestic)


(defvar majestic-mode-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map lisp-mode-shared-map)
    map)
  "Inherited modemap from `lisp-mode-shared-map'.")

(defconst majestic-functions
  '((symbolp "x" "Check if object is symbol.")
    (eq "x y" "Compare two symbols for equality.")
    (nilp "x" "Check if object is `nil'.")
    (consp "x" "Check if object is a cons cell.")
    (atomp "x" "Check if object is atomic.")
    (charp "x" "Check if object is a character.")
    (char\= "x y" "Compare two characters for equality.")
    (streamp "x" "Check if object is a stream.")
    (numberp "x" "Check if object is a number.")
    (integerp "x" "Check if object is a number of subtype `integer'.")
    (floatp "x" "Check if object is a number of subtype `floatp'.")
    (fractionp "x" "Check if object is a number of subtype `fraction'.")
    (complexp "x" "Check if object is a number of subtype `complex'.")
    (id "x y" "Compare two objects for their memory addresses.")
    (proper-list-p "x" "Check if object is a proper list.")
    (stringp "x" "Check if object is a string.")
    (literalp "x" "Check if object is a literal.")
    (primitivep "x" "Check if object is a primitive function.")
    (closurep "x" "Check if object is a closure.")
    (functionp "x" "Check if object is a function of any kind.")
    (errorp "x" "Check if object is an error object.")
    (cons "x y" "Make cons cell from two objects.")
    (car "x" "Get first part of cons cell.")
    (cdr "x" "Get second part of cons cell.")
    (copy "x" "Make shallow copy of object.")
    (length "x" "Get length of list.")
    (depth "x" "Get greatest nesting level of list.")
    (type "x" "Get symbol representing the type of an object.")
    (intern "x" "Make new symbol from a string.")
    (name "x" "Get string name of symbol.")
    (open-stream "x dir" "Open stream path `x' with direction `dir'.")
    (close-stream "x" "Close stream.")
    ;; wrs, rds
    (stat "x" "Get open/close status of stream.")
    (coin "" "Get random `t' or `nil' symbols.")
    (sys "com . args" "Execute console command from OS.")
    (format "fmt . rest" "Make formatted string")
    (err "fmt . rest" "Raise formatted error condition.")
    (list ". rest" "Create list from objects.")
    (append ". rest" "Append all lists to eachother in the given order.")
    (last "x" "Get last cons cell of list.")
    (reverse "x" "Reverse order of list elements.")
    (macroexpand-1 "x" "Expand macro expression once, if it is a macro.")
    ;;macroexpand
    (not "x" "Negate object.")
    (gensym "" "Generate a new symbol.")
    (terpri "" "Print newline to `*stdout*'.")
    (display "x" "Print object to `*stdout*'.")
    ;; pretty-display
    (print "fmt . rest" "Print formatted output to `*stdout*'")
    (load "path" "Evaluate source code from file.")
    (number-coerce "x subtype" "Coerce number `x' to `subtype'.")
    (real-part "x" "Real part of complex number.")
    (imag-part "x" "Imaginary part of complex number.")
    (numer "x" "Numerator of fraction number.")
    (denom "x" "Denominator of fraction number.")
    (richest-number-type "x y" "Get symbol of richest number type between two numbers.")
    (rich-number-coerce "x y" "Coerce two numbers to the richest type among theirs.")
    (\+ ". rest" "Neutral sum element; complex conjugate; sum numbers.")
    (\- ". rest" "Neutral difference element; number negation; subtract numbers.")
    (\* ". rest" "Neutral multiplication element; number signum; multiply numbers.")
    (\/ ". rest" "Neutrla division element; number reciprocal; divide numbers.")
    (zerop "x" "Check if number is zero.")
    (iota "n" "Generate list of numbers ranging from 0 (inclusive) to `n' (exclusive).")
    (1\+ "x" "Increase number by one.")
    (1\- "x" "Decrease number by one.")
    (\= "x y . rest" "Compare numbers for equality.")
    (float\= "x y" "Compare float numbers for equality, given `*ulps*'.")
    (\> "x y . rest" "Greater than.")
    (\< "x y . rest" "Smaller than.")
    (\>\= "x y . rest" "Greater or equal to.")
    (\<\= "x y . rest" "Smaller or equal to.")
    ;; abs
    ;; div
    ;; expt
    
    ;; car, cdr variations
    
    (map "f (x . xs)" "Map function over list, collecting results.")
    (mapc "f (x . xs)" "Map function over list, ignoring results.")
    (assp "proc (x . xs)" "Get association from alist where the first element befits `proc'.")
    (assoc "sym alist" "Get association from alist where the first element equals `sym', given `*default-compare-fn*'."))
  "Majestic Lisp functions, taken from its specification.")

(defconst majestic-keywords
  '((cond ". clauses" "Perform control flow for more than one predicate.")
    (defn "name lambda-list . body" "Define global function.")
    (defmac "name lambda-list . body" "Define global macro.")
    (letrec "bindings . body" "Create local mutually recursive functions.")
    (letfn\* "bindings . body" "Create sequentially-dependent local functions.")
    (letfn "bindings . body" "Create local functions.")
    (let\* "bindings . body" "Create sequentially-dependent local variables.")
    (let "bindings . body" "Create local variables.")
    (quote "x" "Explicit quotation.")
    (def "sym val" "Attribute value to symbol.")
    (if "pred conseq altern" "Perform control flow.")
    (fn "lambda-list . body" "Make closure.")
    (mac "lambda-list . body" "Make macro object.")
    (quasiquote "x" "Explicit quasiquotation.")
    (unquote-splice "x" "Explicit unquote splicing.")
    (unquote "x" "Explicit unquoting.")
    (do ". rest" "Evaluate set of expressions, get result of last.")
    (apply "fun args" "Apply function to list of arguments.")
    (set-car "x val" "Set new value for first part of cons cell.")
    (set-cdr "x val" "Set new value for second part of cons cell.")
    (set "sym val" "Set new value for symbol.")
    (and ". rest" "Evaluate set of expressions while they are true.")
    (or ". rest" "Evaluate set of expressions until they are true.")
    (when "pred . body" "Evaluate expressions if predicate is true.")
    (unless "pred . body" "Evaluate expressions if predicate is false."))
  "Majestic Lisp keywords.")

(defconst majestic-constants
  '((;; gscope, lscope
     (\*stdin\* "Standard input stream.")
     (\*stdout\* "Standard output stream.")
     (\*ulps\* "Units of least precision for float comparison.")
     (\*default-compare-fn\* "Default comparison function for various functions.")))
  "Majestic Lisp constants.")

(defun majestic--into-string-list (wordlist)
  (mapcar (lambda (x) (format "%s" (car x)))
          wordlist))

(defun majestic--into-symbol-regexp (wordlist)
  (regexp-opt
   (majestic--into-string-list wordlist)
   'symbols))

(defconst majestic-font-lock-keywords
  (let ((keywords-regexp
         (majestic--into-symbol-regexp majestic-keywords))
        (functions-regexp
         (majestic--into-symbol-regexp majestic-functions))
        (constants-regexp
         (majestic--into-symbol-regexp majestic-constants)))
    `((,keywords-regexp . font-lock-keyword-face)
      (,functions-regexp . font-lock-function-name-face)
      (,constants-regexp . font-lock-constant-face))))

;; Eldoc
(defconst majestic-eldoc-lookup-list
  (append majestic-keywords
          majestic-functions)
  "Majestic Lisp Eldoc lookup table.")

(defun majestic-current-function ()
  (ignore-errors
    (save-excursion
      (backward-up-list)
      (forward-char 1)
      (thing-at-point 'word))))

(defun majestic-mode-eldoc ()
  (let ((func (assoc (intern (or (majestic-current-function) ""))
                     majestic-eldoc-lookup-list)))
    (when func
      (format "(%s %s):%s"
              (propertize (symbol-name (car func))
                          'face 'face-font-lock-function-face-name-face)
              (or (cadr func) "")
              (if (caddr func) (concat " " (caddr func)) "")))))

(defvar majestic-imenu-generic-expression
  '(("Functions" "^\\s-*(\\(def\\)" 1)))

;; Fix Emacs versions without a `prog-mode'
(unless (fboundp 'prog-mode)
  (defalias 'prog-mode 'fundamental-mode))

;;;###autoload
(define-derived-mode majestic-mode prog-mode "majestic"
  "Major mode for editing Majestic Lisp code."
  :syntax-table lisp-mode-syntax-table ; todo?
  ;; Local variables
  ((lambda (local-vars)
     (dolist (pair local-vars)
       (set (make-local-variable (car pair))
            (cdr pair))))
   `((adaptive-fill-mode . nil)
     (fill-paragraph-function . lisp-fill-paragraph)
     (indent-line-function . lisp-indent-line)
     (lisp-indent-function . lisp-indent-function) ; todo!
     (parse-sexp-ignore-comments . t)
     (comment-start . ";")
     (comment-start-skip . "\\(\\(^\\|[^\\\n]\\)\\(\\\\\\\\\\)*\\)\\(;+\\|#|\\) *")
     (comment-add . 1)
     (comment-use-syntax . t)
     (comment-column . 40)
     (eldoc-documentation-function . majestic-mode-eldoc)
     (imenu-case-fold-search . t)
     (imenu-generic-expression . ,majestic-imenu-generic-expression)
     (mode-name . "Majestic")
     (font-lock-defaults . ((majestic-font-lock-keywords))))))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.maj\\'" . majestic-mode))

(provide 'majestic-mode)


