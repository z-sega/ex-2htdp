;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname finding-blue-eyed-child-in-ancestor-tree) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))

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
(define-struct person [father mother name date eyes])
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
(make-person NP NP "Carl" 1926 "green")
(make-person (make-person NP NP "Carl" 1926 "green")
            (make-person NP NP "Bettina" 1926 "green")
            "Adam"
            1950
            "hazel")

;; Since the records for Carl and Bettina are also needed
;; to construct records for Dave and Eva, it is better to
;; introduce definitions that name specific instances of
;; child and to use the variable names elsewhere.

;; Oldest Generation:
(define Carl (make-person NP NP "Carl" 1926 "green"))
(define Bettina (make-person NP NP "Bettina" 1926 "green"))

;; Middle Generation:
(define Adam (make-person Carl Bettina "Adam" 1950 "hazel"))
(define Dave (make-person Carl Bettina "Dave" 1955 "black"))
(define Eva (make-person Carl Bettina "Eva" 1965 "blue"))
(define Fred (make-person NP NP "Fred" 1966 "pink"))

;; Youngest Generation:
(define Gustav (make-person Fred Eva "Gustav" 1988 "brown"))


;; Let's now turn to a concrete example, the blue-eyed-child?
;; function. Its purpose is to determine whether any child
;; structure in a given family tree has blue eyes.

; FT -> Boolean
; does an-ftree contain a child structure with
; "blue" in the eyes field
(check-expect (blue-eyed-person? Carl) #false)
(check-expect (blue-eyed-person? Gustav) #true)

(define (blue-eyed-person? an-ftree)
  (cond
    [(no-parent? an-ftree) #false]
    [else (or (string=? (person-eyes an-ftree) "blue")
              (blue-eyed-person? (person-father an-ftree))
              (blue-eyed-person? (person-mother an-ftree)))]))


