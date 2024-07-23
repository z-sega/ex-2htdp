;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-459) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define EPSILON 0.01)
(define R 160) ;; # of rectangles to be considered

(define constant (lambda (x) 20))
(define linear (lambda (x) (* 2 x)))
(define square (lambda (x) (* 3 (sqr x))))

;; ...
;; Turn the description of the process into an ISL+
;; function and call it integrate-rectangles. 
;; Adapt the test cases from fig-165 to this case.
;;
;; The more rectangles the algorithm uses, the closer
;; its estimate is to the actual area. Make R a
;; top-level constant and increase it by factors of 10
;; until the algorithm's accuracy eliminates problems
;; with an EPSILON value of 0.1.
;;
;; Decrease EPSILON to 0.01 and increase R enough to
;; eliminate any failing test cases again. Compare
;; the result to ex-458.
;;
;; The Kepler method of ex-458 immediately suggests
;; a divide-and-conquer strategy like binary search
;; introduced in Binary Search. Roughly speaking,
;; the algorithm would split the interval into two
;; pieces, recursively compute the area of each piece,
;; and add the two results.

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
