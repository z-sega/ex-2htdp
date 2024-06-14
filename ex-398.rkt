;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-398) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-398
;; A linear combination is the sum of many linear terms,
;; that is, products of variables and numbers. The latter
;; are called coefficients in this context. Here are
;; some examples:
;;
;; (* 5 x)
;; (+ (* 5 x) (* 17 y))
;; (+ (* 5 x) (* 17 y) (* 3 z))
;;
;; In all examples, the coefficient of x is 5, that of y
;; is 17, and the one for z is 3.
;;
;; If we are given values for variables, we can determine
;; the value of a polynomial. For example, if x = 10, the
;; the value of (* 5 x) is 50; if x = 10 and y = 1, the
;; value of (+ (* 5 x) (* 17 y)) is 67; and if x = 10,
;; y = 1, and z = 2, the value of
;; (+ (* 5 x) (* 17 y) (* 3 z)) is 73.
;;
;; There are many different representations of linear
;; combinations. We could, for example, represent them
;; with functions. An alternative representation is a
;; list of its coefficients. The above combinations would
;; be represented as:
;;
;; (list 5)
;; (list 5 17)
;; (list 5 17 3)
;;
;; This choice of representation assumes a fixed order
;; of variables.
;; 
;; Design value. The function consumes two equally long
;; lists: a linear combination and a list of variable
;; values. It produces the value of the combination for
;; these values.

; An LC (short for Linear Combination) is one of:
; - '()
; - (cons Number LC)
(define coef-x (list 5))
(define coef-x-y (list 5 17))
(define coef-x-y-z (list 5 17 3))

; A VV (short for Variable Values) is one of:
; - '()
; - (cons Number VV)
(define var-x (list 10))
(define var-x-y (list 10 1))
(define var-x-y-z (list 10 1 2))

; LC VV -> Number
; computes value of the linear combination for
; the coefficients c* and variable values v*
; *assume* c* v* are the same size
(check-expect (value '() '()) 0)
(check-expect (value coef-x var-x) 50)
(check-expect (value coef-x-y var-x-y) 67)
(check-expect (value coef-x-y-z var-x-y-z) 73)

(define (value c* v*)
  (foldr (lambda (c v acc)
           (+ (* c v) acc)) 0 c* v*))

