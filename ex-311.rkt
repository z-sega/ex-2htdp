;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-311) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
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

;; ex-311
;; Develop the function average-age. It consumes a family tree
;; and the current year. It produces the average age of all
;; child structures in the family tree.


; FT Number -> Number
; computes the average age of all in an-ftree
(check-within (average-age NP 2024) 0 0.01)
(check-within (average-age Adam 2024) 90 0.01)
(check-within (average-age Gustav 2024) 69.8 0.01) 

(define (average-age an-ftree current-year)
  (cond
    [(no-parent? an-ftree) 0]
    [else
     (local ((define SUM (sum-ages an-ftree current-year))
             (define COUNT (count-persons an-ftree)))
       (/ SUM COUNT))]))
  


; FT -> Number
; counts the child structures in the an-ftree
(check-expect (count-persons NP) 0)
(check-expect (count-persons Carl) 1)
(check-expect (count-persons Adam) 3)
(check-expect (count-persons Gustav) 5)

(define (count-persons an-ftree)
  (cond
    [(no-parent? an-ftree) 0]
    [else (+ 1
             (count-persons (child-father an-ftree))
             (count-persons (child-mother an-ftree)))]))


; FT -> Number
; sums the ages of all persons in an-ftree based on
; current-date
(check-expect (sum-ages Carl 2024) (- 2024 1926))
(check-expect (sum-ages Adam 2024) (+ 2024 2024 2024 -1926 -1926 -1950))

(define (sum-ages an-ftree current-date)
  (local (; FT -> Number
          ; computes the current age of c
          (define (current-age c)
            (- current-date (child-date c))))
  (cond
    [(no-parent? an-ftree) 0]
    [else (+ (current-age an-ftree)
             (sum-ages (child-father an-ftree) current-date)
             (sum-ages (child-mother an-ftree) current-date))])))

