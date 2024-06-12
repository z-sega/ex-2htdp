;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname simultaneous-list-processing-case-3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Processing Two Lists Simultaneously: Case 3
;; -------------------------------------------
;; *Sample Problem*
;; Given a list of symbols los and a natural number n,
;; the funcion list-pick extractws the nth symbol from
;; los; if there is no such symbol, it signals an error.

(define ERR "list too short")

; N is one of:
; - 0
; - (add1 N)

; [List-of Symbol] N -> Symbol
; extracts the nth symbol from l;
; signals an error if there is no such symbol
(check-expect (list-pick '(a b c) 2) 'c)
(check-expect (list-pick (cons 'a '()) 0) 'a)
(check-error (list-pick '() 0) ERR)
(check-error (list-pick '() 3) ERR)

(define (list-pick l n)
  (cond
    [(and (= n 0) (empty? l))
     (error ERR)]
    [(and (> n 0) (empty? l))
     (error ERR)]
    [(and (= n 0) (cons? l))
     (first l)]
    [(and (> n 0) (cons? l))
     (list-pick (rest l) (sub1 n))]))
