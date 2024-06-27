;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-426) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-426
;; Complete the hand-evaluation from above. A
;; close inspection of the evaluation suggests an
;; additional trivial case for quick-sort<. Every
;; time quick-sort< consumes a list of one item, it
;; returns it as is. After all, the sorted version of
;; a list of one item is the list itself.
;;
;; Modify quick-sort< to take advantage of this
;; observation. Evaluate the example again.
;;
;; Q: How many steps does the revised algorithm save?
;; A: The revision saves 2 additional recursive
;; calls on every (quick-sort ...) where ... is
;; a one element list.

; [List-of Number] -> [List-of Number]
; produces a sorted version of l
(check-expect (quick-sort< '(11 8 14 7))
              '(7 8 11 14))

(define (quick-sort< l)
  (cond [(empty? l) '()]
        [(= (length l) 1) l]
        [else
         (local ((define pivot (first l)))
           (append (quick-sort< (smallers l pivot))
                   (list pivot)
                   (quick-sort< (largers l pivot))))]))

; [List-of Number] Number -> [List-of Number]
; produces a list like l but all elements are
; smaller than n
(check-expect (smallers '() 1) '())
(check-expect (smallers '(2 3 7 5) 1) '())
(check-expect (smallers '(2 3 7 5) 5) '(2 3))

(define (smallers l n)
  (filter (lambda (i) (< i n)) l))

; [List-of Number] Number -> [List-of Number]
; produces a list like l but all elements are
; larger than n
(check-expect (largers '() 1) '())
(check-expect (largers '(2 3 7 5) 1) '(2 3 7 5))
(check-expect (largers '(2 3 7 5) 5) '(7))

(define (largers l n)
  (filter (lambda (i) (> i n)) l))
