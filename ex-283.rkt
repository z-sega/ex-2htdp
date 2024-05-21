;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-283) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
;; Confirm that DrRacket's stepper can deal with lambda.
;; Use it to step through the third example

(define-struct IR [name price])
(define th 20)
((lambda (ir) (<= (IR-price ir) th)) (make-IR "bear" 10))


;; and also to determine how DrRacket evaluates the following
;; expressions

(map (lambda (x) (* 10 x)) '(1 2 3))

(foldl (lambda (name rst)
         (string-append name ", " rst))
       "etc."
       '("Matthew" "Robby"))

(filter (lambda (ir) (<= (IR-price ir) th))
        (list (make-IR "bear" 10)
              (make-IR "doll" 33)))
