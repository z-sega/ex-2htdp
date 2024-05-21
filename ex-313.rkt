;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-313) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
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

;; ex-313
;; Suppose we need the function blue-eyed-ancestor?,
;; which is like blue-eyed-child? but responds with
;; #true only when a proper ancestor, not the given
;; child itself, has blue eyes.

; FT -> Boolean
; #t only when a proper ancestor in an-ftree, not
; the child itself, has blue eyes.
(check-expect (blue-eyed-ancestor? NP) #f)
(check-expect (blue-eyed-ancestor? Carl) #f)
(check-expect (blue-eyed-ancestor? Adam) #f)
(check-expect (blue-eyed-ancestor? Eva) #f)
(check-expect (blue-eyed-ancestor? Gustav) #t)

(define (blue-eyed-ancestor? an-ftree)
  (cond
    [(no-parent? an-ftree) #f]
    [else (or (blue-eyed-person? (person-father an-ftree))
              (blue-eyed-person? (person-mother an-ftree)))]))

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

;; Although the goals clearly differ, the signatures
;; are the same:

; FT -> Boolean
; (define (blue-eyed-ancestor? an-ftree) ...)

;; Stop! Formulate a purpose state for the function.
; -> Already designed the function

;; To appreciate the difference, we take a look at Eva:

(check-expect (blue-eyed-person? Eva) #true)

;; Eva is blue-eyed, but has no blue-eyed ancestor. Hence,

(check-expect (blue-eyed-ancestor? Eva) #false)

;; In contrast, Gustav is Eva's son and does have a
;; a blue-eyed ancestor:

(check-expect (blue-eyed-ancestor? Gustav) #true)

;; Now suppose a friend comes up with this solution:
(check-expect (blue-eyed-ancestor?.friend NP) #f)
(check-expect (blue-eyed-ancestor?.friend Carl) #f)
(check-expect (blue-eyed-ancestor?.friend Adam) #f)
(check-expect (blue-eyed-ancestor?.friend Eva) #f)
;(check-expect (blue-eyed-ancestor?.friend Gustav) #t)

(define (blue-eyed-ancestor?.friend an-ftree)
  (cond
    [(no-parent? an-ftree) #false]
    [else (or (blue-eyed-ancestor?.friend (person-father an-ftree))
              (blue-eyed-ancestor?.friend (person-mother an-ftree)))]))

;; Explain why this function fails one of its tests. What
;; is the result of (blue-eyed-ancestor? A) no matter which
;; A you choose? Can you fix your friend's solution?

; This function fails because it doesn't actually check
; for any blue eyed persons on the family tree. That is,
; there is no conclusive (equal? (person-eyes A) "blue")
; in any clause.
;
; The result will be #false regardless of which FT is processed.
;
; The solution can be corrected using (blue-eyed-person? ...)
; but on each parent. Solution at closer to the top of the
; file.