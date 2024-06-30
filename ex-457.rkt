;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-457) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-457
;; Design the function double-amount, which computes
;; how many months it takes to double a given amount
;; of money when a savings account pays interest
;; at a fixed rate on a monthly basis.

;; Number -> N
;; computes the number of months it takes to
;; double some principal @ monthly rate r
;; assumes:
;; (1) (positive? r) unless infinite loop
;; generative:
;; recursively compounds @ monthly rate r until
;; some internal value of principal doubles, then
;; returns the time period in months to achieve that
;; termination:
;; ends recurrence once the compounded amounts reaches
;; or exceeds the target (i.e once the amount is
;; doubled).
(check-expect (double-amount 0.01) 70)
(check-expect (double-amount 0.02) 36)
(check-expect (double-amount 0.03) 24)
(check-expect (double-amount 0.04) 18)

(define (double-amount r)
  (local ((define P 100)      ;; principal
          (define T (* 2 P))  ;; target

          ;; Number N -> N
          ;; computes the number of months
          ;; for P to reach target @ rate r
          (define (helper i amount)
            (cond
              [(>= amount T) i]
              [else
               (helper (add1 i)
                       (compound-interest amount r))])))
    (helper 0 P)))
  

;; Number Number N -> Number
;; computes the compound interest for 1 month
;; on P @ rate r (applied once per month)
(check-expect (compound-interest 100 0.03) 103)

(define (compound-interest P r)
  (* P (expt (+ 1 (/ r 1)) 1)))
