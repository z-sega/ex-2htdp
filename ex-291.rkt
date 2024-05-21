;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-291) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
;; ex-291
;; The fold functions are so powerful that you can define
;; almost any list-processing functions with them. Use
;; fold to define map-via-fold, which simulates map.

; [List-of Number] -> [List-of Number]
(check-expect (add-3-foldr '(1 2 3)) (add-3 '(1 2 3)))
(define (add-3-foldr l)
  (foldr (lambda (x acc)
           (cons (+ x 3) acc))
         '()
         l))

; [List-of Number] -> [List-of Number]
; adds 3 to all the numbers on l
(check-expect (add-3 '(1 2 3)) '(4 5 6))
(define (add-3 l)
  (map (lambda (x) (+ x 3)) l))