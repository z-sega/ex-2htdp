;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-458) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define EPSILON 0.1)

(define constant (lambda (x) 20))
(define linear (lambda (x) (* 2 x)))
(define square (lambda (x) (* 3 (sqr x))))

;; ex-458
;; Kepler suggested a simple integration method. To
;; compute an estimate of the area under f between
;; a and b, proceed as follows:
;;
;; 1. divide the interval into half at
;;    mid = (a + b)/2;
;; 2. compute the areas of these two trapezoids:
;;    - [(a, 0), (a, f(a)), (mid, 0), (mid, f(mid))]
;;    - [(mid, 0), (mid, f(mid)), (b, 0), (b, f(b))];
;; 3. then add the two areas.
;;
;; ...
;;
;; Design the function integrate-kepler. That is, turn
;; the mathematical knowledge into an ISL+ function.
;; Adapt the test cases from fig-165 to this use.

;; [Number -> Number] Number Number -> Number
;; computes the area under the graph of f between
;; a and b
;; assume (< a b) holds
;; how:
;; divides the intervals [a, b] at mid-point,
;; computes the areas of trapezoids at [a, mid] and
;; [mid, b],
;; and adds these areas together
(check-within (integrate-kepler constant 12 22)
              200 EPSILON)
(check-within (integrate-kepler linear 0 10)
              100 EPSILON)
(check-within (integrate-kepler square 0 10)
              1000 EPSILON)

(define (integrate-kepler f a b)
  (local ((define mid (/ (+ a b) 2))
          ;; Number Number Number Number -> Number
          ;; compute the area of the trapezoid
          ;; with points at (a0, 0), (a, f@a0),
          ;; (b0, 0) and (b0, f@b0)
          (define (trapezoid-area a0 b0)
            (local ((define f@a0 (f a0))
                    (define f@b0 (f b0)))
              (+ (* (- b0 a0) f@b0)
                 (* 1/2 (- b0 a0) (- f@a0 f@b0))))))
    (+ (trapezoid-area a mid)
       (trapezoid-area mid b))))

;; Q: Which of the three tests fails and by how much?
;; A: test-3 fails by 125 units.
