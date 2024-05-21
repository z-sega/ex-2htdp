#lang htdp/isl+

;; ex-296
;; Use compass-and-pencil drawings to check the tests.
;;
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
