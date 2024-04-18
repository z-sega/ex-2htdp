;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-265) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-265
;; Use DrRacket's stepper to fill in any gaps above.

((local ((define (f x y) (+ (* x (sqr y)) 3))) f)
 4 1)

;; Using the stepper on ISL will warn you about
;; syntax, switching over to ISL with lambdas will
;; work, but that brings up an interesting question:
;; What are lambdas?