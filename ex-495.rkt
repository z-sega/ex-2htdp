;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-495) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-495
;; Complete the manual evaluation of (sum/a '(10 4) 0)
;; in fig-183. Doing so shows that the sum and sum.v2
;; add up the given numbers in reverse order. While sum
;; adds up the numbers from right to left, the
;; accumulator-style version adds them up from left to
;; right.

(sum/a '(10 4) 0)
(sum/a '(4) (+ 10 0))
(sum/a '() (+ 4 (+ 10 0)))
(+ 4 (+ 10 0))
14