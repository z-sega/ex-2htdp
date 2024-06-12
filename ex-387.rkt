;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-387) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-387
;; Design cross. The function consumes a list of symbols and
;; a list of numbers and produces all possible ordered
;; pairs of symbols and numbers. That is, when
;; given '(a b c) and '(1 2), the expected result is
;; '((a 1) (a 2) (b 1) (b 2) (c 1) (c 2)).

; [X Y] [List-of X] [List-of Y] -> [List-of [List X Y]]
; computes all possible ordered pairs of x* and y*
(check-expect (cross '() '(1 2)) '())
(check-expect (cross '(a b c) '()) '())
(check-expect (cross '(a) '(1 2))
              '((a 1) (a 2)))
(check-expect (cross '(a b c) '(1 2))
              '((a 1) (a 2) (b 1) (b 2) (c 1) (c 2)))
(check-expect (cross '(a b c d) '(1 2))
              '((a 1) (a 2)
                (b 1) (b 2)
                (c 1) (c 2)
                (d 1) (d 2)))

(define (cross x* y*)
  (local (; X [List-of Y] -> [List-of [List X Y]]
          ; computes all possible ordered pairs of x and y*
          (define (cross-with-y* x)
            (map (lambda (y) (list x y)) y*)))
    (foldr append '() (map cross-with-y* x*))))