;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-395) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-395
;; Design take. It consumes a list l and a natural number
;; n. It produces the first n items from l or all of l
;; if it is too short.

;; CASE 3

(define a* '(1 2 3))

; [X] [List-of X] N -> [List-of X]
; returns the first n items from l or all of l
; if it is too short
(check-expect (take '() 0) '())
(check-expect (take '() 2) '())
(check-expect (take a* 0) '())
(check-expect (take a* 1) '(1))
(check-expect (take a* 2) '(1 2))
(check-expect (take a* 3) '(1 2 3))

(define (take l n)
  (cond
    [(and (= n 0) (empty? l)) '()]
    [(and (> n 0) (empty? l)) '()]
    [(and (= n 0) (cons? l)) '()]
    [(and (> n 0) (cons? l))
     (cons (first l) (take (rest l) (sub1 n)))]))


;; Design drop. It consumes a list l and a natural number
;; n. Its result is l with the first n items removed or
;; just '() if l is too short.

(define b* '(1 2 3))

; [X] [List-of X] N -> [List-of X]
; returns l with the first n items removed
;; or just '() if l is too short
(check-expect (drop '() 0) '())
(check-expect (drop '() 2) '())
(check-expect (drop b* 0) b*)
(check-expect (drop b* 1) '(2 3))
(check-expect (drop b* 2) '(3))
(check-expect (drop b* 3) '())

(define (drop l n)
  (cond
    [(and (= n 0) (empty? l)) '()]
    [(and (> n 0) (empty? l)) '()]
    [(and (= n 0) (cons? l)) l]
    [(and (> n 0) (cons? l)) (drop (rest l) (sub1 n))]))
     
