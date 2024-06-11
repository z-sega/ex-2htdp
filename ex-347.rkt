;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-347) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/abstraction)

(define-struct add [left right])
(define-struct mul [left right])

; A BSL-expr is one of:
; - Number
; - (make-add BSL-expr BSL-expr)
; - (make-mul BSL-expr BSL-expr)

; A BSL-eval is a Number
; *interpretation*
; Is any value to which a representation of a BSL-expr
; can evaluate to.

;; ex-347
;; Design eval-expression. The function consumes a representation
;; of a BSL expression and computes its value.

; BSL-expr -> BSL-eval
; computes the value of bsl-expr
(check-expect (eval-expression 3) 3)
(check-expect (eval-expression (make-add 1 1)) 2)
(check-expect (eval-expression (make-mul 3 10)) 30)
(check-expect (eval-expression
               (make-add (make-mul 1 1) 10)) 11)

(define (eval-expression bsl-expr)
  (match bsl-expr
      [(? number?) bsl-expr]
      [(add x y) (+ (eval-expression x)
                    (eval-expression y))]
      [(mul x y) (* (eval-expression x)
                    (eval-expression y))]))
