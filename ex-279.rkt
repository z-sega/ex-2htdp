;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-279) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
;; ex-279
;; Decide which of the following phrases are legal lambda
;; expressions:
;;
(lambda (x y) (x y y))
;; legal: the argument x is assumed to be a function
;; to be applied to two arguments
;;
;; (lambda () 10)
;; illegal: a lambda expression requires at least one variable
;;
(lambda (x) x)
;; legal: consumes one argument and returns it
;;
(lambda (x y) x)
;; legal: consumes two arguments, returns the first one
;;
;; (lambda x 10)
;; illegal: a lambda's variables must be enclosed in parenthesis
