;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-328) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
; An Atom is one of:
; - Number
; - String
; - Symbol

; An S-expr is one of:
; - Atom
; - SL

; An SL is one of:
; - '()
; - (cons S-expr SL)

;; ex-328
;; Copy and paste fig-120 into DrRacket; include your test suite.
;; Validate the test suite. As you read along the remainder of
;; this section, perform the edits and rerun the test suites to 
;; confirm the validity of our arguments.

; S-expr Symbol Atom -> S-expr
; replaces all old with new in sexp
(check-expect (substitute "new" 'a 'b) "new")
(check-expect (substitute 'a 'a 'b) 'b)
(check-expect (substitute '("new" 1 a b) 'a 'b) '("new" 1 b b))
(check-expect (substitute '("new" 1 (deeper a) b) 'a 'b)
              '("new" 1 (deeper b) b))
(check-expect (substitute '(((world) bye) bye) 'bye '42)
              '(((world) 42) 42))

(define (substitute sexp old new)
  (cond
    [(atom? sexp) (if (equal? sexp old) new sexp)]
    [else (map (lambda (s) (substitute s old new)) sexp)]))

;; Stop! Explain why we had to use lambda for this last simplification.
;; ->
;; lambda had to be used in the natural recursion of the final
;; clause because the function:substitute accepts multiple arguments
;; and since only the s-expr argument changes during execution, a lambda
;; with a single argument and a body with bound old & new is a
;; good way to signal this.


; X -> Boolean
; #t if x is an Atom
(check-expect (atom? 19) #t)
(check-expect (atom? "atom") #t)
(check-expect (atom? 'b) #t)
(check-expect (atom? '()) #f)

(define (atom? x)
  (cond
   [(number? x) #true]
   [(string? x) #true]
   [(symbol? x) #true]
   [else #false]))
