;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-312) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
;; Our experimentation suggests two insights.
;;
;; First, we are not looking for a data definition that describes
;; how to generate instances of child structures but for a data
;; definition that describes how to represent family trees.
;;
;; Second, the data definition consists of two clauses, one
;; for the variant describing unknown family trees and another
;; for known family trees:

(define-struct no-parent [])
(define-struct child [father mother name date eyes])
; An FT (short for family tree) is one of:
; - (make-no-parent)
; - (make-child FT FT String N String)

;; And since the "no parent" tree is going to show up a lot
;; in our programs, we define NP as a short-hand and revise
;; the data definition a bit:

(define NP (make-no-parent))
; An FT is one of:
; - NP
; - (make-child FT FT String N String)

; Examples:
(make-child NP NP "Carl" 1926 "green")
(make-child (make-child NP NP "Carl" 1926 "green")
            (make-child NP NP "Bettina" 1926 "green")
            "Adam"
            1950
            "hazel")

;; Since the records for Carl and Bettina are also needed
;; to construct records for Dave and Eva, it is better to
;; introduce definitions that name specific instances of
;; child and to use the variable names elsewhere.

;; Oldest Generation:
(define Carl (make-child NP NP "Carl" 1926 "green"))
(define Bettina (make-child NP NP "Bettina" 1926 "green"))

;; Middle Generation:
(define Adam (make-child Carl Bettina "Adam" 1950 "hazel"))
(define Dave (make-child Carl Bettina "Dave" 1955 "black"))
(define Eva (make-child Carl Bettina "Eva" 1965 "blue"))
(define Fred (make-child NP NP "Fred" 1966 "pink"))

;; Youngest Generation:
(define Gustav (make-child Fred Eva "Gustav" 1988 "brown"))

;; ex-312
;; Develop the function eye-colors, which consumes a family
;; tree and produces a list of all eye colors in the tree.
;; An eye color may occur more than once in the resulting
;; list.
;; *Hint* Use append to concatenate the lists resulting from
;; the recursive calls.

; FT -> [List-of String]
; computes the list of all eye colors in an-ftree
(check-expect (eye-colors NP) '())
(check-expect (eye-colors Carl) '("green"))
(check-expect (eye-colors Eva) '("blue" "green" "green"))
(check-expect (eye-colors Gustav)
              '("brown" "pink" "blue" "green" "green"))

(define (eye-colors an-ftree)
  (cond
    [(no-parent? an-ftree) '()]
    [else (append (list (child-eyes an-ftree))
                  (eye-colors (child-father an-ftree))
                  (eye-colors (child-mother an-ftree)))]))