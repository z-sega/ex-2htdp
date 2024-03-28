;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex-251) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-251
;; Design fold1, which is the abstraction of the two functions:

; [List-of Number] -> Number
; computes the sum of the numbers on l
(define (sum l)
  (cond
    [(empty? l) 0]
    [else (+ (first l)
             (sum (rest l)))]))

; [List-of Number] -> Number
; computes the product of the numbers on l
(define (product l)
  (cond
    [(empty? l) 1]
    [else (* (first l)
             (product (rest l)))]))


; paired differences:
; [(empty? l) <1>]
; [else (<2> (first l) (<3> (rest l)))]

; abstract over differences:
; [List-of Number] Number -> Number
(define (fold1 l f acc)
  (cond
    [(empty? l) acc]
    [else (f (first l)
             (fold1 (rest l) f acc))]))

; verify abstraction
(define test-list '(1 2 3 4 5))

; [List-of Number] -> Number
(check-expect (sum-from-abstract test-list)
              (sum test-list))
(define (sum-from-abstract l)
  (fold1 l + 0))

; [List-of Number] -> Number
(check-expect (product-from-abstract test-list)
              (product test-list))
(define (product-from-abstract l)
  (fold1 l * 1))
