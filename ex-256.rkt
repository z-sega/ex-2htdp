;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex-256) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-256
;; Explain the following abstract function:

; [X] [X -> Number] [NEList-of X] -> X
; finds the (first) item in lx that maximizes f
; if (argmax f (list x-1 ... x-n)) == x-i,
; then (>= (f x-i) (f x-1)), (>= (f x-i) (f x-2)), ...
; (define (argmax f lx) ...)

; Use it on concrete examples in ISL. Can you articulate
; an analogous purpose statement for argmin?

; ->
(check-expect (argmax sqrt '(4 25 2 1)) 25)
(check-expect (argmin sqr '(4 5 2 8)) 2)

; ->
; If x-i is an element of a list of items of some unknown
; data class X; argmax is a function that processes that
; list of items and returns the item for which (f x-i)
; is greatest.

; ->
; Extrapolating from argmax, argmin is likely a function
; that processes a list of items and returns the item for
; which (f x-i) is least.
