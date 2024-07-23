;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-484) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-484
;; While a list sorted in descending order is clearly the
;; worst possible input for inf, the analysis of inf's
;; abstract running time explains why the rewrite of inf
;; with local reduces the running time. For convenience, we
;; replicate this version here:

(check-expect (infL '(0 1)) 0)
(check-expect (infL '(1 0)) 0)
(check-expect (infL '(2 1 0)) 0)

(define (infL l)
  (cond [(empty? (rest l)) (first l)]
        [else (local ((define s (infL (rest l))))
                (if (< (first l) s)
                    (first l)
                    s))]))

;; Hand-evaluate (infL '(3 2 1 0)). Then argue that infL
;; uses on the "order of n steps" in the best and the
;; worst case. You many now wish to revisit ex-261,
;; which asks you to explore a similar problem.

;; A: (infL '(3 2 1 0)) has 3 recursive calls because
;; s_0 <- (infL (rest 3 2 1 0)). And for (infL (rest 3 2 1 0))
;; s_1 <- (infL (rest (rest 3 2 1 0))), until the list is
;; exhausted. For a list of n elements, there will be
;; exactly (n - 1) recursive calls.
;; However, we know that the constant is essential
;; insignificant as so we say infL uses on the order of n
;; steps.