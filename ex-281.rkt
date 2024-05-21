;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-281) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
;; ex-281
;; Write down a lambda expression that
;;
;; 1. consumes a number and decides whether it is less than 10;
(define th 10)
(define lambda1 (lambda (n) (< n th)))
(lambda1 4)

;; 2. multiplies two given numbers and turns the result into a
;; string;
(define lambda2 (lambda (a b)
                  (number->string (* a b))))
(lambda2 2 4)

;; 3. consumes a natural number and returns 0 for evens and 1 for
;; odds;
(define lambda3 (lambda (n)
                  (modulo n 2)))
(lambda3 0)
(lambda3 4)
(lambda3 5)

;; 4. consumes two inventory records and compares them by price;
;; and
(define-struct IR [name price])
(define lambda4 (lambda (a b)
                  (>= (IR-price a) (IR-price b))))
(lambda4 (make-IR "Bear" 10)
         (make-IR "Racoon" 20))
(lambda4 (make-IR "Fish" 30)
         (make-IR "Racoon" 20))

;; 5. adds a red dot at a given Posn to a given Image.
(require 2htdp/image)
(define RED-DOT (circle 10 "solid" "red"))
(define MT (empty-scene 50 50))
(define lambda5 (lambda (p img)
                  (place-image RED-DOT
                               (posn-x p) (posn-y p)
                               img)))
(lambda5 (make-posn 10 30) MT)

;; Demonstrate how to use these functions in the interactions area.
;; -> to use them, the functions must be given a name/identifier
;; so that they can be referenced.
