;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-282) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
(define (f-plain x)
  (* 10 x))

(define f-lambda
  (lambda (x) (* 10 x)))

;; ex-282
;; Experiment with the above definitions in
;; DrRacket.
;; Also add

; Number -> Boolean
(define (compare x)
  (= (f-plain x) (f-lambda x)))

;; to the definitions area after renaming the left-hand
;; f to f-plain and the right-hand one to f-lambda.
;; Then run

(compare (random 100000))

;; a few times to make sure the two functions agree on all
;; kinds of inputs.
;;
;; If function definitions are just abbreviations for
;; constant definitions, we can replace the function name by
;; its lambda expression:

(f-plain (f-plain 42))
;; ==
((lambda (x) (* 10 x)) ((lambda (x) (* 10 x)) 42))

;; Strangely though, this substitution appears to create
;; an expression that violates the grammar as we know it.
;; To be precise, it generates an application expression
;; whose function position is a lambda expression.
;;
;; The point is that ISL+'s grammar differs from ISL's in
;; two aspects: it obviously comes wiht lambda expressions,
;; but it also allows arbitrary expressions to show up in
;; the function position of an application. This means that
;; you may need to evaluate the function position before you
;; can proceed with an application, but you know how to
;; evaluate most expressions.
;; Of couse, the real difference is that the evaluation of
;; expression may yield a lambda expression.
;; Functions really are values.

;; ...
;; Stop! Use your intuition to calculate the third example
;; ((lambda (ir) (<= (IR-price ir) th)) (make-IR "bear" 10))
;; Assume th is larger than or equal to 10.

;; ->
;; ((lambda (ir) (<= (IR-price ir) th)) (make-IR "bear" 10))
;; ==
;; (<= (IR-price (make-IR "bear" 10)) 10)
;; ==
;; (<= 10 10)
;; ==
;; #true

