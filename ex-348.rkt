;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-348) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/abstraction)

(define-struct con [left right])
; A con (short for Conjunction) is
; #true when left and right are #true
;   (make-con BooleanEvaluatable BooleanEvaluatable)

(define-struct dis [left right])
; A dis (short for Disjunction) is
; #true when either left or right is #true
;   (make-dis BooleanEvaluatable BooleanEvaluatable)

(define-struct neg [this])
; A neg (short for Negation) is
; #true when this is #false and #false
; when this is #true
;   (make-neg BooleanEvaluatable)

; A BSL-bool-expr is one of:
; - Boolean
; - (make-con BSL-bool-expr BSL-bool-expr)
; - (make-dis BSL-bool-expr BSL-bool-expr)
; - (make-neg BSL-bool-expr)

; A BSL-bool-eval is a Boolean
; *interpretation*
; Is any value to which a representation of a BSL-bool-expr
; can evaluate to.

;; ex-348
;; Develop a data representation for Boolean BSL expressions
;; constructed from #true, #false, and, or, and not.
;; Then design eval-bool-expression, which consumes
;; (representations of) Boolean BSL expressions and computes their
;; values. What kind of values do these Boolean expressions yield?
;; -> Booleans

; BSL-bool-expr -> BSL-bool-eval
; computes the value of b-expr
(check-expect (eval-bool-expression #true) #true)
(check-expect (eval-bool-expression #false) #false)
(check-expect (eval-bool-expression (make-neg #true)) #false)
(check-expect (eval-bool-expression (make-neg #false)) #true)
(check-expect
 (eval-bool-expression (make-neg (make-con #true #false))) #true)
(check-expect (eval-bool-expression (make-con #false #false)) #false)
(check-expect (eval-bool-expression (make-con #true #false)) #false)
(check-expect (eval-bool-expression (make-con #false #true)) #false)
(check-expect (eval-bool-expression (make-con #true #true)) #true)
(check-expect (eval-bool-expression (make-dis #false #false)) #false)
(check-expect (eval-bool-expression (make-dis #true #false)) #true)
(check-expect (eval-bool-expression (make-dis #false #true)) #true)
(check-expect (eval-bool-expression (make-dis #true #true)) #true)
(check-expect
 (eval-bool-expression (make-con (make-dis #true #false)
                                 (make-con #true #false))) #false)
(check-expect
 (eval-bool-expression (make-con (make-dis #true #false)
                                 (make-con #true #true))) #true)

(define (eval-bool-expression b-expr)
  (match b-expr
    [(? boolean?) b-expr]
    [(con x y) (and (eval-bool-expression x)
                    (eval-bool-expression y))]
    [(dis x y) (or (eval-bool-expression x)
                   (eval-bool-expression y))]
    [(neg x) (not (eval-bool-expression x))]))
    
