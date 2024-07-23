;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-504) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-504
;; Design to10. It consumes a list of digits and
;; produces the corresponding number. The first item
;; on the list is the most significant digit.
;; Hence, when applied to '(1 0 2), it produces 102.

; [List-of N] -> N
; produces the corresponding number from l
(check-expect (to10 '(1)) 1)
(check-expect (to10 '(1 2)) 12)
(check-expect (to10 '(1 0 2)) 102)

(define (to10 l0)
  (local [; N N -> N
          ; calculates the value of n
          ; based on its placement p
          (define (n-value n p) (* (expt 10 p) n))
          
          ; [List-of N] -> N
          ; produces the corresponding number from l,
          ; accumulator:
          ; - p is the placement of the digit
          ; - a is number built by summation of digits
          ;   in l0 that are not in l
          (define (to10/a l p a)
            (cond
              [(empty? l) a]
              [else
               (to10/a (rest l)
                       (sub1 p)
                       (+ (n-value (first l) p) a))]))]
    (to10/a l0 (sub1 (length l0)) 0)))



