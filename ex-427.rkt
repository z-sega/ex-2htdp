;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-427) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-427
;; While quick-sort< quickly reduces the size of the
;; problem in many cases, it is inappropriately slow
;; for small problems. Hence people use quick-sort<
;; to reduce the size of the problem and switch to a
;; different sort function when the list is small
;; enough.
;;
;; Develop a version of quick-sort< that uses sort<
;; (an appropriately adapted variant of sort> from
;; Auxiliary Functions that Recur) if the length of
;; the input is below some threshold.

; [List-of Number] -> [List-of Number]
; produces a sorted version of l
(check-expect (quick-sort< '(11 8 14 7) 3)
              '(7 8 11 14))

(define (quick-sort< l thr)
  (cond [(empty? l) '()]
        [(= (length l) 1) l]
        [else
         (local ((define pivot (first l))
                 
                 ; [List-of Number]
                 (define divide-n-conquer
                   (append
                    (quick-sort< (smallers l pivot) thr)
                    (list pivot)
                    (quick-sort< (largers l pivot)
                                 thr)))

                 ; [List-of Number]
                 (define sort-quickly
                   (sort< l)))
           
           (if (<= (length l) thr)
               sort-quickly
               divide-n-conquer))]))

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

; [List-of Number] -> [List-of Number]
; produces a sorted version of l
(check-expect (sort< '(11 8 14 7)) '(7 8 11 14))

(define (sort< l)
  (cond [(empty? l) '()]
        [else (insert (first l)
                      (sort< (rest l)))]))

; Number [List-of Number] -> [List-of Number]
; inserts n into the sorted list of numbers l
(check-expect (insert 8 '(7 11 14)) '(7 8 11 14))

(define (insert n l)
  (cond [(empty? l) (cons n '())]
        [else (if (<= n (first l))
                  (cons n l)
                  (cons (first l)
                        (insert n (rest l))))]))
