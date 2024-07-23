;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname generic-integration) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define EPSILON 0.1)

(define constant (lambda (x) 20))
(define linear (lambda (x) (* 2 x)))
(define square (lambda (x) (* 3 (sqr x))))

;; [Number -> Number] Number Number -> Number
;; computes the area under the graph of f between
;; a and b
;; assume
;; (< a b) holds
(check-within (integrate constant 12 22) 200 EPSILON)
(check-within (integrate linear 0 10) 100 EPSILON)
(check-within (integrate square 0 10) 1000 EPSILON)

(define (integrate f a b) #i0)
  