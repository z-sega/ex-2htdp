;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-316) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
; An Atom is one of:
; - Number
; - String
; - Symbol

; An S-expr is one of:
; - Atom
; - SL

; An SL is one of:
; - '()
; - (cons S-expr SL)

;; ex-316
;; Define the atom? function.

; X -> Boolean
; #t if x is an Atom
(check-expect (atom? 19) #t)
(check-expect (atom? "atom") #t)
(check-expect (atom? 'b) #t)
(check-expect (atom? '()) #f)

(define (atom? x)
  (cond
   [(number? x) #true]
   [(string? x) #true]
   [(symbol? x) #true]
   [else #false]))
