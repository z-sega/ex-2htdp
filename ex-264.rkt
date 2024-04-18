;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex-264) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-264
;; Use DrRacket's stepper to calculate out how it
;; evaluates (sup (list 2 1 3))
;; where sup is the function from fig. 89 equipped
;; with local

; [NEList-of Number] -> Number
; determines the largest number on l
(check-expect (sup (list 2 1 3)) 3)
(check-expect (sup (list 2 3 1)) 3)
(define (sup l)
  (cond
    [(empty? (rest l)) (first l)]
    [else
     (local ((define largest-in-rest
               (sup (rest l))))
       (if (> (first l) largest-in-rest)
           (first l)
           largest-in-rest))]))

(sup (list 2 1 3))
