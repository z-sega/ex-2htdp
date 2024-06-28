;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-447) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-447
;; The poly function has two roots. Use find-root with
;; poly and an interval that contains both roots.

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
