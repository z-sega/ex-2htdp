#lang htdp/isl+

(require 2htdp/abstraction)

(define x 5)
(define y 3)

(define-struct add [left right])
(define-struct mul [left right])

; A BSL-expr is one of:
; - Number
; - (make-add BSL-expr BSL-expr)
; - (make-mul BSL-expr BSL-expr)

; A BSL-var-expr is one of:
; - Number
; - Symbol
; - (make-add BSL-var-expr BSL-var-expr)
; - (make-mul BSL-var-expr BSL-var-expr)
(define ex-number 3)
(define ex-symbol 'x)
(define ex-add (make-add 'x 3))
(define ex-mul (make-mul 1/2 (make-mul 'x 3)))
(define ex-add-nested (make-add (make-mul 'x 'x)
                                (make-mul 'y 'y)))

; A BSL-var-eval is a Number
; *interpretation*
; Is any value to which a representation of a BSL-expr
; can evaluate to.

;; ex-354
;; Design eval-variable. The checked function consumes a
;; BSL-var-expr and determines its value if numeric? yields
;; true for the input. Otherwise it signals an error

(define INVALID-EXPR "Invalid expression: not numeric")

;; BSL-var-expr -> BSL-var-eval
;; computes value if (numeric? var-ex) is #true,
;; else ERROR.
(check-expect (eval-variable ex-number) ex-number)
(check-expect (eval-variable (make-add 5 3)) 8)
(check-expect (eval-variable (make-mul 5 3)) 15)
(check-expect (eval-variable (make-add (make-add 3 1) 3)) 7)
(check-expect (eval-variable (make-mul (make-mul 3 3) 3)) 27)
(check-error (eval-variable ex-symbol) INVALID-EXPR)
(check-error (eval-variable ex-add) INVALID-EXPR)
(check-error (eval-variable ex-mul) INVALID-EXPR)
(check-error (eval-variable ex-add-nested) INVALID-EXPR)

(define (eval-variable var-ex)
  (local (; BSL-expr -> BSL-var-eval
          ; computes the value of var-ex
          (define (eval-expr ex)
            (match ex
              [(? number?) ex]
              [(add l r) (+ (eval-expr l) (eval-expr r))]
              [(mul l r) (* (eval-expr l) (eval-expr r))])))
    (if (numeric? var-ex)
        (eval-expr var-ex)
        (error INVALID-EXPR))))

;; BSL-var-expr -> Boolean
;; #t if ex is a BSL-expr
(check-expect (numeric? ex-number) #true)
(check-expect (numeric? ex-symbol) #false)
(check-expect (numeric? ex-add) #false)
(check-expect (numeric? (make-add 5 3)) #true)
(check-expect (numeric? ex-mul) #false)
(check-expect (numeric? ex-add-nested) #false)

(define (numeric? ex)
  (match ex
    [(? number?) #true]
    [(? symbol?) #false]
    [(add l r) (and (numeric? l) (numeric? r))]
    [(mul l r) (and (numeric? l) (numeric? r))]))
