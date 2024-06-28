;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-448) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-448
;; The find-root algorithm terminates for all
;; (continuous) f, left, and right for which the
;; assumption holds. Why? Formulate a termination
;; argument.
;;
;; Hint:
;; Suppose the arguments of find-root describe an
;; interval of size s1. How large is the distance
;; between left and right for the first and second
;; recursive call to find-root? After how many steps
;; is (- right left) smaller than or equal to EPSILON?

;; Q: Why?
;; A: The assumptions 1 and 2 protect the function
;; from infinitely searching for an interval that
;; may not exist.
;; If assumption 1 didn't hold, then
;; the function will not have values at some point
;; within some interval [a, b]; if the function
;; was designed to error out at such a point, then
;; find-root will need to be designed with some
;; failsafe.
;; If assumption 2 did not hold, then the find-root
;; function risks searching for the root in an
;; interval that contains f(x) values but no root
;; i.e the function does not have zero value within
;; the interval and this will cause an infinite loop.
;;
;; extra: the function also needs to work with
;; an EPSILON that is not 0. If (zero? EPSILON) then
;; the function will never terminate because it will
;; keep searching for a more precise value for the
;; root; and we know computer numbers are not precise.

(define EPSILON 0.000001)

;; [Number -> Number] Number Number -> Number
;; determines R such that f has a root in
;; [R, (+ R EPSILON)]
;; assume:
;; (1) f is continuous
;; (2) (or (<= (f left) 0 (f right))
;;         (<= (f right) 0 (f left)))
;; generative: divides interval in half, the root is
;; in one of the two halves, picks according to (2)
;; termination:
;; if assumption (1) and (2) hold, and
;; (not (zero? EPSILON)) find-root will terminate
;; when an interval smaller than or equal to EPSILON
;; is reached. This interval will be reached because
;; each recurrence halves the interval.
(check-within (find-root poly 1 3) 2 EPSILON)
(check-within (find-root poly 3 5) 4 EPSILON)
(check-satisfied (find-root poly 3 5)
                 ;; #t if given root is actually a root
                 ;; root if (zero? (poly given-root))
                 (lambda (r) (zero? (poly (round r)))))

(define (find-root f left right)
  (cond [(<= (- right left) EPSILON) left]
        [else
         (local ((define mid (/ (+ left right) 2))
                 (define f@mid (f mid)))
           (cond [(or (<= (f left) 0 f@mid)
                      (<= f@mid 0 (f left)))
                  (find-root f left mid)]
                 [(or (<= f@mid 0 (f right))
                      (<= (f right) 0 f@mid))
                  (find-root f mid right)]))]))


;; Number -> Number
(check-expect (poly 2) 0)
(check-expect (poly 4) 0)

(define (poly x) (* (- x 2) (- x 4)))

;; interval with both roots of poly
(find-root poly 1 5)
