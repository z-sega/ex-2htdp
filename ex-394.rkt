;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-394) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-394
;; Design merge. The function consumes two lists of
;; numbers, sorted in ascending order. It produces a single
;; sorted list of numbers that contains all the numbers
;; on both inputs lists. A number occurs in the output
;; as many times as it occurs on the two input lists
;; together.

; Case 3

(define a* '(1 3 4 6 8))
(define b* '(1 2 5 6 9))

(define result '(1 1 2 3 4 5 6 6 8 9))

; [List-of Number] [List-of Number] -> [List-of Number]
; merges sorted (asc) lists a* and b*; numbers appear
; in result as many times as they occur in both lists.
(check-expect (merge '() '()) '())
(check-expect (merge '() b*) b*)
(check-expect (merge a* '()) a*)
(check-expect (merge a* b*) result)

(define (merge a* b*)
  (cond
    [(and (empty? a*) (empty? b*)) '()]
    [(and (empty? a*) (cons? b*)) b*]
    [(and (cons? a*) (empty? b*)) a*]
    [(and (cons? a*) (cons? b*))
     ; I don't get how she (Y.E) came up with this...
     (if (<= (first a*) (first b*))
         (cons (first a*) (merge (rest a*) b*))
         (cons (first b*) (merge a* (rest b*))))]))

