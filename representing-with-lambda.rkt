#lang htdp/isl+

;; B'cos functions are first-class values in ISL+, we may think
;; of them as another form of data and use them for data representation.

;; Sample Problem
;; Navy strategists represent fleets of ships as rectangles
;; (the ships themselves) and circles (their weapons' reach).
;; The coverage of a fleet of ships is the combination of all
;; these shapes. Design a data representation for rectangles,
;; circles, and combinations of shapes. Then design a function
;; that determines whether some point is within a shape.


;; One mathematical approach considers shapes as predicates
;; on points. That is, a shape is a function that maps a
;; Cartesian point to a Boolean value. Let's translate that
;; into a data definition:

; A Shape is a function:
;   [Posn -> Boolean]
; *interpretation* if s is a shape and p a Posn,
; (s p) produces #true if p is in s, #false otherwise

;; Such an unusual representation calls for an immediate
;; exploration with examples. We delay this step for a
;; moment, however, and instead define a function that
;; checks whether a point is inside some shape:

; Shape Posn -> Boolean
(define (inside? s p)
  (s p))

;; Doing so is straightforward because of the given
;; interpretation. It also turns out that it is
;; simpler that creating examples, and,
;; suprisingly, the function is helpful for
;; formulating data examples.

;; Stop! Explain how and why inside? works.

; HOW:
; Shape is a predicate that given a Posn
; checks whether that position is within it (the bounds of
; shape).
; 
; Example:
; (define some-shape ...)
; (define p (make-posn 3 4))
; 
; (some-shape p) 

; WHY: Shape is a predicate (function) that can
; be applied to any given point.

;; Returning to the problem of elements of Shape.
;; Here is a simple element of Shape:

; Posn -> Boolean
(lambda (p) (and (= (posn-x p) 3)
                 (= (posn-y p) 4)))

;; As required, it consumes a Posn p, and its body compares
;; the coordinates of p to those of the point (3, 4),
;; meaning this function represents a single point.
;;
;; While the data definition of a point as a Shape might
;; seem silly, it suggests how we can define functions
;; that create elements of Shape:

; NOTE: We use "mk" because this function is not and
; ordinary constructor.

; Number Number -> Shape
(define (mk-point x y)
  (lambda (p)
    (and (= (posn-x p) x)
         (= (posn-y p) y))))

(define a-sample-shape (mk-point 3 4))

;; Stop again!! Convince yourself that the last line
;; creates a data representation of (3, 4).
;; Consider using DrRacket's stepper.

; The function consumes x and y coordinates
; and returns a function that is #t if the any
; given point is on x and y.
; 
; Following from the data definition of Shape,
; a Shape is a function that maps a Cartesian point
; to a Boolean value.
; If this function is applied to any given point
; like so: (a-sample-shape some-p) and the application
; evaluates to a boolean value then a-sample-shape
; is indeed an element of Shape.

;; If we were to design such a function, we would formulate
;; a purpose statement and provide some illustrative
;; examples. For the purpose statement, we can go with
;; the obvious:

; creates a representation for a point at (x, y)

;; or, more precisely,

; represents a point at (x, y)

;; For the examples we want to go with the interpretation of
;; Shape. To illustrate, (mk-point 3 4) is supposed to evaluate
;; to a function that returns #true if, and only if, it is
;; given (make-posn 3 4). Using inside?, we can express
;; this statement via tests:

(check-expect (inside? (mk-point 3 4) (make-posn 3 4))
              #true)
(check-expect (inside? (mk-point 3 4) (make-posn 3 0))
              #false)

;; In short, to make a point representation, we define a
;; constructor-like function that consumes the point's two
;; coordinates. Instead of a record, this function uses
;; lambda to construct another function. The function that
;; it creates consumes a Posn and determines whether its
;; x and y fields are equal to the originally given
;; coordinates.
;; 
;; Next we generalixe this idea from simple points to shapes, 
;; say circles. In your geometry courses, you learn that a
;; circle is a collection of points that all have the same
;; distance to the center of the circle - the radius.
;; For points inside the circle, the distance is smaller
;; than or equal to the radius.
;; Hence, a function that creates a Shape representation
;; of a circle must consume three pieces: the two coordinates
;; for its center and the radius:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ; Number Number Number -> Shape            ;;
;; ; creates a representation for a circle of ;;
;; ; radius r located at (center-x, center-y) ;;
;; (define (mk-circle center-x center-y r)    ;;
;;   ...)                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Like mk-point, it produces a function via a lambda.
;; The function that is returned determines whether
;; some Posn is inside the circle. Here are some
;; examples, again formulated as tests:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (check-expect (inside? (mk-circle 3 4 5) ;;
;;                        (make-posn 0 0))  ;;
;;               #true)                     ;;
;; (check-expect (inside? (mk-circle 3 4 5) ;;
;;                        (make-posn 0 9))  ;;
;;               #false)                    ;;
;; (check-expect (inside? (mk-circle 3 4 5) ;;
;;                        (make-posn -1 3)) ;;
;;               #true)                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; The origin, (make-posn 0 0), is exactly five steps away
;; from (3, 4), the center of the circle.
;; Stop! Explain the remaining examples.

; (make-posn 0 9) is not inside because it is 6 steps away
; from the (3, 4), the center of the circle.

; (make-posn -1 3) is inside the circle because the point
; does not exceed the radius of the circle. 


; Number Number Number -> Shape
; creates a representation for a circle of
; radius r located at (center-x, center-y)
(define (mk-circle center-x center-y r)
  ; [Posn -> Boolean]
  (lambda (p)
    (<= (distance-between center-x center-y p) r)))

; The distance-between function is a straightforward exercise.

; Number Number Posn -> Number
; computes the distance between the points (x, y) and p
(check-within (distance-between 3 4 (make-posn 0 0)) 5 0.001)
(check-within (distance-between 3 4 (make-posn 0 9)) 5.83 0.001)
(define (distance-between x y p)
  (sqrt (+ (sqr (- (posn-x p) x))
           (sqr (- (posn-y p) y)))))

;; Some tests for circle tests ...
(check-expect (inside? (mk-circle 3 4 5)
                       (make-posn 0 0))
              #true)
(check-expect (inside? (mk-circle 3 4 5)
                       (make-posn 0 9))
              #false)
(check-expect (inside? (mk-circle 3 4 5)
                       (make-posn -1 3))
              #true)

;; The data representation of a rectangle is expressed in
;; a similar manner:

; Number Number Number Number -> Shape
; represents a width by height rectangle whose
; upper-left corner is located at (ul-x, ul-y)
(check-expect (inside? (mk-rect 0 0 10 3)
                       (make-posn 0 0))
              #true)
(check-expect (inside? (mk-rect 2 3 10 3)
                       (make-posn 4 5))
              #true)
; Stop! Formulate a negative test case.
(check-expect (inside? (mk-rect 0 0 10 3)
                       (make-posn 11 4))
              #false)

(define (mk-rect ul-x ul-y width height)
  (lambda (p)
    (and (<= ul-x (posn-x p) (+ ul-x width))
         (<= ul-y (posn-y p) (+ ul-y height)))))


;; Its constructor receives four numbers: the coordinates of the
;; upper-left corner, its width, and height. The result is again
;; a *lambda* expression. As for circles, this function
;; consumes a Posn and produces a Boolean, checking whether
;; the x and y fields of the Posn are in the proper intervals
;; (i.e tucked within the radius of the circle)

;; At this point, we have only one task left, namely, the
;; design of a function that maps two Shape representations
;; to their combination. The signature and the header are easy:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ; Shape Shape -> Shape         ;;
;; ; combines two shapes into one ;;
;; (define (mk-combination s1 s2) ;;
;;   ; Posn -> Boolean            ;;
;;   (lambda (p)                  ;;
;;     #false))                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Indeed, even the default value is straightforward. We know
;; that a shape is represented as a function from Posn to
;; Boolean, so we write down a lambda that consumes some Posn
;; and produces #false, meaning it says no point is in the
;; combination.

; Shape Shape -> Shape
; combines two shapes into one
(check-expect (inside? union1 (make-posn 0 0)) #true)
(check-expect (inside? union1 (make-posn 0 9)) #false)
(check-expect (inside? union1 (make-posn -1 3)) #true)
(define (mk-combination s1 s2)
  ; Posn -> Boolean
  (lambda (p)
    (or (inside? s1 p)
        (inside? s2 p))))

;; So suppose we wish to combine the circle and the rectangle
;; from the above:

(define circle1 (mk-circle 3 4 5))
(define rectangle1 (mk-rect 0 3 10 3))
(define union1 (mk-combination circle1 rectangle1))

;; Since (make-posn 0 0) is inside both, there is no question that
;; it is inside the combination of the two. In a similar vein,
;; (make-posn 0 9) is in neither shape, and so it isn't in the
;; combination. Finally, (make-posn -1 3) is in circle1 but not
;; in rectangle1. But the point must be in the combination of the
;; two shapes because every point that is in one or the other
;; shape is in their combination.
;;
;; The or expression says that the result is #true if one of the
;; expressions produces #true: (inside? s1 p) or (inside? s2 p).
;; The first expression determines whether p is in s1 and the
;; second one whether p is in s2. And that is precisely a
;; translation of our above explanation into ISL+.

