;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-318) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
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

;; ex-318
;; Design depth. The function consumes an S-expression and
;; determines its depth. An Atom has a depth of 1. The depth of
;; a list of S-expressions is the maximum depth of its items
;; plus 1.

; S-expr -> N
; determines the depth of sexp
(check-expect (depth 1) 1)
(check-expect (depth "new") 1)
(check-expect (depth 'new) 1)
(check-expect (depth '(something here)) 2)
(check-expect (depth '(something (new) here)) 3)
(check-expect (depth '(something ((very) new) here)) 4)

(define (depth sexp)
  (cond
    [(atom? sexp) 1]
    [else (+ 1
             (foldr max 0 (map depth sexp)))]))


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