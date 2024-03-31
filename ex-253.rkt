;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex-253) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-253
;; Each of these signatures describes a class of functions:
;; Describe these collections with at least one example from
;; ISL.

; [Number -> Boolean]
; The signature describes a class of functions that consumes
; a Number and returns a Boolean
; positive?
; or 
(define (number->bool n) #f)

; [Boolean String -> Boolean]
; The signature describes a class of functions that consumes
; a Boolean and a String and returns a Boolean
; eq?
; or
(define (bool-n-str->bool b s) #f)

; [Number Number Number -> Number]
; The signature describes a class of functions that consumes
; three Numbers and returns a Number
; *
; or
(define (n-n-n->n n) n)

; [Number -> [List-of Number]]
; The signature describes a class of functions that consumes
; a Number and returns a list of numbers
; list
; or
(define (number->numbers n) (cons n (cons (add1 n) '())))

; [[List-of Number] -> Boolean]
; The signature describes a class of functions that consumes
; a list of numbers and returns a boolean
; list?
; or
(define (numbers->bool ln) #t)
