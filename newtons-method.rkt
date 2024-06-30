;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname newtons-method) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define EPSILON 0.01)

(define f-slope@0 (lambda (x) 0))
(define f-slope@0.5 (lambda (x) (+ 2 (* x 0.5))))
(define poly (lambda (x) (* (- x 2)
                            (- x 4))))

;; [Number -> Number] Number -> Number
;; finds a number r1 such that (f r1) is small
;; generative:
;; repeatedly generates improved guesses
(check-within (newton poly 1) 2 EPSILON)
(check-within (newton poly 3.5) 4 EPSILON)

(define (newton f r1)
  (cond
    [(<= (abs (f r1)) EPSILON) r1]
    [else (newton f (root-of-tangent f r1))]))

;; [Number -> Number] Number -> Number
;; computes the root of the tangent through
;; (r1, (f r1))
(check-expect (root-of-tangent f-slope@0.5 2) -4)

(define (root-of-tangent f r1)
  (- r1
     (/ (f r1)
        (slope f r1))))

;; [Number -> Number] Number -> Number
;; computes the slope of f at r1
(check-expect (slope f-slope@0 0) 0)
(check-expect (slope f-slope@0 2) 0)
(check-expect (slope f-slope@0 -2) 0)
(check-expect (slope f-slope@0.5 0) 0.5)
(check-expect (slope f-slope@0.5 2) 0.5)
(check-expect (slope f-slope@0.5 -2) 0.5)

(define (slope f r1)
  (* (/ 1 (* 2 EPSILON))
     (- (f (+ r1 EPSILON))
        (f (- r1 EPSILON)))))