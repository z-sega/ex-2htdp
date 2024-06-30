;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-455) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-455
;; Translate this mathematical formula into the
;; ISL+ function slope, which maps function f and
;; a number r1 to the slope of f at r1. Assume that
;; EPSILON is a global constant. For your examples,
;; use functions whose exact slope you can figure out,
;; say, horizontal lines, linear functions, and
;; perhaps polynomials if you know some calculus.

(define EPSILON 0.01)

(define f-slope@0 (lambda (x) 0))
(define f-slope@0.5 (lambda (x) (+ 2 (* x 0.5))))


;; [Number -> Number] Number -> Number
;; computes the slope of f at r1
(check-expect (slope f-slope@0 0) 0)
(check-expect (slope f-slope@0 2) 0)
(check-expect (slope f-slope@0 -2) 0)
(check-expect (slope f-slope@0.5 0) 0.5)
(check-expect (slope f-slope@0.5 2) 0.5)
(check-expect (slope f-slope@0.5 -2) 0.5)

(define (slope f r1)
  (* (/ 1 (* 2 EPSILON))
     (- (f (+ r1 EPSILON))
        (f (- r1 EPSILON)))))