;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex-249) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-249
;; Functions are values: arguments, results, items in lists.
;; Place the following definitions and expressions into
;; DrRacket's definitions window and use the stepper to find
;; out how running this program works:

(define (f x) x)

(cons f '())

(f f)

(cons f (cons 10 (cons (f 10) '())))

;; The stepper displays functions as lambda expressions;
;; see Nameless Functions
