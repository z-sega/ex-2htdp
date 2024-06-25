;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-419) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/abstraction)

;; ex-419
;; When you add two inexact numbers of vastly different
;; orders of magnitude, you may get the larger one back
;; as the result. For example, if a number system uses
;; only 15 significant digits, we run into problems when
;; adding numbers that vary by more than a factor of
;; 10^16
;;
;; ...
;;
;; Consider the list of numbers in fig-144 and determine
;; the values of these expressions

(define JANUS
  (list 31.0
        #i2e+34
        #i-1.2345678901235e+80
        2749.0
        -2939234.0
        #i-2e+33
        #i3.2e+270
        17.0
        #i-2.4e+270
        #i4.2344294738446e+170
        1.0
        #i-8e+269
        0.0
        99.0))

(define (sum n*)
  (for/sum ([n n*]) n))

;; Q. (sum JANUS)
(sum JANUS)
;; #i99.0

;; Q. (sum (reverse JANUS))
(sum (reverse JANUS))
;; #i-1.2345678901235e+80

;; Q. (sum (sort JANUS <))
(sum (sort JANUS <))
;; #i0.0

;; A. Each of these expressions should return the same
;; result, but they are all very different. This problem
;; is dangerous, the arrangment of the list and the order
;; they are processed affects the result of the operation.

;; Evaluate this expression and compare the result to
;; the there sums above. What do you think now about advice
;; from the web?

(exact->inexact (sum (map inexact->exact JANUS)))
;; #i4.2344294738446e+170
;; -> The result is entirely different from the three
;; sums above.

;; Q. What do you think about advice from the web?
;; A. It is not guaranteed to be good advice.
