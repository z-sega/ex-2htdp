;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-391) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-391
;; Design replace-eol-with using the strategy of
;; Processing Two Lists Simultaneously: Case 3.
;; Start from the tests. Simplify the result
;; systemically.

; [List-of Number] [List-of Number] -> [List-of Number]
; replaces the final '() in front with end
(check-expect (replace-eol-with '() '(a b)) '(a b))
(check-expect (replace-eol-with '(1) '()) '(1))
(check-expect (replace-eol-with '(1) '(a)) '(1 a))
(check-expect (replace-eol-with '(2 1) '(a)) '(2 1 a))

(define (replace-eol-with front end)
  (cond
    [(empty? front) end]
    [(cons? front)
     (cons (first front)
           (replace-eol-with (rest front) end))]))
    