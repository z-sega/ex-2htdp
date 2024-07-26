;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-430) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-430
;; Develop a variant of quick-sort< that uses only
;; one comparison function, say, <. Its partitioning
;; step divides the given list alon into a list that
;; contains the items of alon smaller than the pivot
;; and another one with those that are not smaller.
;;
;; Use local to package up the program as a single
;; function. Abstract this function so that it consumes
;; a list and a comparison function.

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