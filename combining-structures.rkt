#lang htdp/bsl

(define-struct ball [location velocity])
(define-struct vel [deltax deltay])

(define ball1
  (make-ball (make-posn 30 40) (make-vel -10 5)))

; flat-ball is a ball structure implemented
; with a flat design.
; *interpretation*
; The x and y are Numbers representing position in 2D
; deltax and deltay are Numbers representing the
; velocity of respective x and y directions in 2D
(define-struct flat-ball [x y deltax deltay])
(define flat-ball1
  (make-flat-ball 30 40 -10 5))

(define-struct centry [name home office cell])
(define-struct phone [area number])

(make-centry "Shriram Fisler"
             (make-phone 207 "389-3243")
             (make-phone 101 "483-3830")
             (make-phone 208 "384-2482"))

