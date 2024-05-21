#lang htdp/isl+

;; Mathematical, we say that a Posn p is inside a circle if the
;; distance between p and the circle's center is smaller than
;; the radius r. Let's wish for the right kind of helper
;; function and write down what we have.

; A Shape is a function:
;   [Posn -> Boolean]
; *interpretation* if s is a shape and p a Posn,
; (s p) produces #true if p is in s, #false otherwise

; Shape Posn -> Boolean
(define (inside? s p)
  (s p))

; Number Number Number -> Shape
; creates a representation for a circle of
; radius r located at (center-x, center-y)
(define (mk-circle center-x center-y r)
  ; [Posn -> Boolean]
  (lambda (p)
    (<= (distance-between center-x center-y p) r)))

; The distance-between function is a straightforward exercise.

;; ex-297
;; Design the function distance-between. It consumes two
;; numbers and a Posn: x, y, and p. The function computes
;; the distance between the points (x, y) and p.

; Number Number Posn -> Number
; computes the distance between the points (x, y) and p
(check-within (distance-between 3 4 (make-posn 0 0)) 5 0.001)
(check-within (distance-between 3 4 (make-posn 0 9)) 5.83 0.001)
(define (distance-between x y p)
  (sqrt (+ (sqr (- (posn-x p) x))
           (sqr (- (posn-y p) y)))))

