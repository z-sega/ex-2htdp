;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-432) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-432
;; ex-219 introduces the function food-create, which
;; consumes a Posn and produces a randomly chosen Posn
;; that is guaranteed to be distinct from the given one.
;; First reformulate the two functions as a single
;; definition, using local; then justify the design of
;; food-create.

;; Justification of the design of food-create.
;; the food-create function is a generatively-recursive
;; algorithm because:
;; 1. its processing ignores the structure of a posn
;; 2. it recurs until some condition is met.

(define FOOD-MIN-X 1)
(define FOOD-MIN-Y 1)
(define FOOD-MAX-Y 9)
(define FOOD-MAX-X 9)

; Posn -> Posn
; creates food for worm
; terminates: when internal generated posn is not
; the same as p
(check-random (food-create (make-posn 2 3))
              (make-posn (random FOOD-MAX-X)
                         (random FOOD-MAX-Y)))

(define (food-create p)
  (local (; Posn -> Posn
          ; return candidate if it is not p
          (define (food-check-create candidate)
            (if (equal? p candidate)
                (food-create p)
                candidate)))
    (food-check-create
     (make-posn (random FOOD-MAX-X)
                (random FOOD-MAX-Y)))))
