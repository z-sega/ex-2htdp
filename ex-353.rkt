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

;; ex-353
;; Design the numeric? function. It determines whether a
;; BSL-var-expr is also a BSL-expr. Here we assume that your
;; solution to ex-345 is the definition for BSL-var-expr
;; without Symbols.

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
