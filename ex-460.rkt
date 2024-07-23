;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-460) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define EPSILON 0.01)
(define R 160) ;; # of rectangles to be considered

(define constant (lambda (x) 20))
(define linear (lambda (x) (* 2 x)))
(define square (lambda (x) (* 3 (sqr x))))

;; ex-460
;; Develop the algorithm integrate-dc, which integrates
;; a function f between the boundaries a and b using
;; a divide-and-conquer strategy. Use Kepler's method
;; when the interval is sufficiently small.

;; [Number -> Number] Number Number -> Number
;; computes area of f between [a, b] using
;; divide-and-conquer strategy
(check-within (integrate-dc constant 12 22)
              200 EPSILON)
(check-within (integrate-dc linear 0 10)
              100 EPSILON)
(check-within (integrate-dc square 0 10)
              1000 EPSILON)

(define (integrate-dc f a b)
  (local ((define interval (- b a))
          (define mid (/ (+ b a) 2))
          (define threshold 0.1))
    (cond
      [(<= interval threshold) (integrate-kepler f a b)]
      [else (+ (integrate-dc f a mid)
               (integrate-dc f mid b))])))


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
;(check-within (integrate-kepler square 0 10)
;              1000 EPSILON)

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

;; [Number -> Number] Number Number -> Number
;; computes the area of f from [a, b]
;; how
;; divides the area into R smaller rectangles for
;; summation
(check-within (integrate-rectangles constant 12 22)
              200 EPSILON)
(check-within (integrate-rectangles linear 0 10)
              100 EPSILON)
(check-within (integrate-rectangles square 0 10)
              1000 EPSILON)

(define (integrate-rectangles f a b)
  (local ((define widthR (/ (- b a) R))
          (define midpointR (/ widthR 2)) ;; midpoint
          ;; N -> Number
          ;; computes the area of the (add1 i)st/nd/...
          ;; small rectangle
          (define (area i)
            (* widthR
               (f (+ a (* i widthR) midpointR)))))
    (foldr + 0 (build-list R (lambda (n) (area n))))))
