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

;; ex-352
;; Design subst. The function consumes a BSL-var-expr ex, a
;; Symbol x, and a Number v. It produces a BSL-var-expr
;; like ex with all occurences of x replaced by v.

;; BSL-var-expr -> BSL-expr
;; replaces all occurences of symbol x
;; in ex with v
(check-expect (subst ex-number 'x x) ex-number)
(check-expect (subst ex-symbol 'x x) 5)
(check-expect (subst ex-add 'x x) (make-add x 3))
(check-expect (subst ex-mul 'x x) (make-mul 1/2
                                            (make-mul x 3)))
(check-expect (subst ex-add-nested 'x x) (make-add (make-mul x x)
                                                   (make-mul 'y 'y)))

(define (subst ex x v)
  (match ex
    [(? number?) ex]
    [(? symbol?) (if (symbol=? ex x) v ex)]
    [(add l r) (make-add (subst l x v)
                         (subst r x v))]
    [(mul l r) (make-mul (subst l x v)
                         (subst r x v))]))

