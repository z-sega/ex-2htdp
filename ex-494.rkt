;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-494) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of Number] -> [List-of Number]
; produces a sorted version of l
(define (sort> l)
  (cond
    [(empty? l) '()]
    [else (insert (first l)
                  (sort> (rest l)))]))

; Number [List-of Number] -> [List-of Number]
; inserts n into the sorted list of numbers l
(define (insert n l)
  (cond
    [(empty? l) '(n)]
    [else (if (>= n (first l))
              (cons n l)
              (cons (first l)
                    (insert n (rest l))))]))

;; Q: Does the insertion sort> function from Auxiliary
;;    Functions that Recur need an accumulator? If so,
;;    why? If not, why not?
;; A: As sort> is a structurally recursive function,
;;    the condition for recognizing the need for an
;;    accumulator is whether it traverses the result
;;    of its natural recursion (sort> (rest l)) with
;;    an auxiliary, also recursive function
;;    as in (insert (first l) (sort> (rest l))).
;;    As it meets the condition, it would benefit from
;;    having an accumulator.