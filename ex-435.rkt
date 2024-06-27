;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-435) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-435
;; When you worked on ex-430 or ex-428, you may have
;; produced looping solutions. Similarly, ex-434
;; actually reveals how brittle the termination argument
;; if for quick-sort<. In all cases, the argument relies
;; on the idea that smallers and largers produce lists
;; that are maximally as long as the given list, and
;; on our understanding that neither includes the given
;; pivot in the result.
;;
;; Based on this explanation, modify the definition
;; of quick-sort< so that both functions receive lists
;; that are shorter than the given one.

; [List-of X] [X X -> Boolean] -> [List-of X]
; produces a sorted version of l using cmp
(check-expect (quick-sort '(11 8 14 7) <)
              '(7 8 11 14))
(check-expect (quick-sort '(11 8 8 14 7 7) <)
              '(7 7 8 8 11 14))
(check-expect (quick-sort '(11 8 14 7) >)
              '(14 11 8 7))
(check-expect (quick-sort '(11 8 8 14 7 7) >)
              '(14 11 8 8 7 7))
(check-expect (quick-sort '("hello" "zoo" "world")
                          string<?)
              '("hello" "world" "zoo"))
(check-expect (quick-sort '("hello" "zoo" "zoo" "world")
                          string<?)
              '("hello" "world" "zoo" "zoo"))

(define (quick-sort l cmp)
  (cond [(empty? l) '()]
        [(= (length l) 1) l]
        [else
         (local ((define pivot (first l))
                 
                 ; [List-of X]
                 ; all elements that are equal to pivot
                 (define pivot-equals
                   (filter (lambda (i)
                             (equal? i pivot)) l))

                 ; [List-of X]
                 ; all elements i where (cmp i pivot)
                 (define p1
                   (filter (lambda (i)
                             (cmp i pivot)) l))

                 ; [List-of X]
                 ; all elements i where
                 ; (not (cmp i pivot)) and elements
                 ; are not equal to pivot
                 (define p2
                   (filter
                    (lambda (i)
                      (not (or (member? i pivot-equals)
                               (cmp i pivot)))) l)))
           (append (quick-sort p1 cmp)
                   pivot-equals
                   (quick-sort p2 cmp)))]))
