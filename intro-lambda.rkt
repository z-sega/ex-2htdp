;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname intro-lambda) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
;; some simple examples of using lambda
((lambda (x) (expt 10 x)) 2)
((lambda (name rst) (string-append name ", " rst))
 "Robby"
 "etc.")

(define-struct IR [name price])
(define th 20)
((lambda (ir) (<= (IR-price ir) th)) (make-IR "bear" 10))

;; important: nameless functions can be used wherever a
;; a function is required
(map (lambda (x) (expt 10 x))
     '(1 2 3 4 5 6 7))

(foldl (lambda (name rst)
         (string-append name ", " rst))
       "etc."
       '("Matthew" "Robby"))

(filter (lambda (ir) (<= (IR-price ir) th))
        (list (make-IR "bear" 10)
              (make-IR "doll" 33)))

;; important: how to evaluate the application of a lambda
;; expression to arguments

; ((lambda (x-1 ... x-n) f-body) v-1 ... v-n) == f-body
; with all occurences of x-1 ... x-n
; replaced with v-1 ... v-n, respectively [beta-v]

;; that is, the application of a lambda expression proceeds
;; just like that of an ordinary function. We replace the
;; parameters of the function with the actual argument values
;; and compute the value of the function body.

;; Here is how to use this law:
((lambda (x) (* 10 x)) 2)
;; ==
(* 10 2)
;; ==
20