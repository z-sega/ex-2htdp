;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-497) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-497 - CURIOSITY: Tail Optimization
;; Like sum, !.v1 performs the primite computations,
;; multiplication in this case, in reverse order.
;; Surprisenly, this affects the performance of the
;; function in a negative manner.
;;
;; Measure how long it takes to evaluate (!.v1 20)
;; 1,000 times. Recall that (time an-expression)
;; function determines how long it takes to run
;; an-expression.


; N -> N
; factorial-function:
; computes (* n (- n 1) (- n 2) ... 1)
(check-expect (!.v1 1) 1)
(check-expect (!.v1 2) 2)
(check-expect (!.v1 6) 720)

(define (!.v1 n)
  (cond
    [(zero? n) 1]
    [else (* n (!.v1 (sub1 n)))]))

; N -> N
; factorial-function:
; computes (* n (- n 1) (- n 2) ... 1)
(check-expect (!.v2 1) 1)
(check-expect (!.v2 2) 2)
(check-expect (!.v2 6) 720)

(define (!.v2 n0)
  (local [; N -> N
          ; computes (* n (- n 1) (- n 2) ... 1)
          ; accumulator: a is the product of the n
          ; natural numbers in the interval [n0, n)
          (define (!/a n a)
            (cond
              [(zero? n) a]
              [else (!/a (sub1 n)
                         (* n a))]))]
    (!/a n0 1)))


;; compare:
(define (run-f-x-times f x)
  (build-list x (lambda (n) (f 20))))

(define v1 (time (run-f-x-times !.v1 10000)))
(define v2 (time (run-f-x-times !.v2 10000)))

;; why? 
    