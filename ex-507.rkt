;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-507) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-507
;; ex-257 explains how to design foldl with the design
;; recipes and guidelines of the first two parts of
;; the book:

(check-expect (f*ldl + 0 '(1 2 3))
              (foldl + 0 '(1 2 3)))
(check-expect (f*ldl cons '() '(a b c))
              (foldl cons '() '(a b c)))

; version 1
#;(define (f*ldl f i l)
  (foldr f i (reverse l)))

;; That is, foldl is the result of reversing the given
;; list and then using foldr to fold the given function
;; over this intermediate list.
;; 
;; The f*ldl function obviously traverses the list twice,
;; but once we design all the functions, it becomes
;; clear how much harder it has to work:

; version 2
; [X Y -> Y] Y [List-of X] -> Y
#;(define (f*ldl f i l)
  (local [; [List-of X] -> [List-of X]
          (define (reverse l)
            (cond
              [(empty? l) '()]
              [else (add-to-end (first l)
                                (reverse (rest l)))]))

          ; X [List-of X] -> [List-of X]
          (define (add-to-end x l)
            (cond
              [(empty? l) (list x)]
              [else (cons (first l)
                          (add-to-end x (rest l)))]))

          ; [List-of X] -> Y
          (define (f*ldr l)
            (cond
              [(empty? l) i]
              [else (f (first l)
                       (f*ldr (rest l)))]))]
    (f*ldr (reverse l))))

;; We know that reverse has to traverse a list once for
;; every item on the list, meaning f*ldl really performs
;; n^2 traversals for a list of length n. Fortunately,
;; ne know how to eliminate this bottleneck with an
;; accumulator:

; version 3
; [X Y -> Y] Y [List-of X] -> Y
#;(define (f*ldl f i l)
  (local [; [List-of X] -> [List-of X]
          ; accumulator: a is the list of all
          ; elements in l that are not in l0
          ; in reverse order.
          (define (reverse/a l0 a)
            (cond
              [(empty? l0) a]
              [else (reverse/a (rest l0)
                               (cons (first l0) a))]))

          ; [List-of X] -> Y
          (define (f*ldr l)
            (cond
              [(empty? l) i]
              [else (f (first l)
                       (f*ldr (rest l)))]))]
    (f*ldr (reverse/a l '()))))

;; Once reverse uses an accumulator, we actually get the
;; apparent performance of two traversals of the list. The
;; question is whether we can improve on this by adding
;; an accumulator to the locally defined foldr:

; version 4
; [X Y -> Y] Y [List-of X] -> Y
#;(define (f*ldl f i l0)
  (local [; Y [List-of X] -> Y
          ; accumulator: a is the aggregation of items
          ; on l0 that are not in l in reverse order
          ; after applying f to condense each item
          ; how:
          ; (foldr/a '() '(a b))
          ; (foldr/a (cons a '()) '(b))
          ; (foldr/a (cons b '(a)) '())
          ; '(b a)
          (define (foldr/a a l)
            (cond
              [(empty? l) a]
              [else (foldr/a (f (first l) a)
                             (rest l))]))]
    (foldr/a i l0)))

;; Since equipping the function with an accumulator
;; reverses the order in which the list is
;; traversed, the initial reversal of the list is
;; superfluous.
;;
;; TASK 1:
;; Recall the signature of foldl:
;;
;; [X Y] [X Y -> Y] Y [List-of X] -> Y
;;
;; It is also the signature of f*ldl. Formulate the
;; signature for foldr/a and its accumulator invariant.
;; Hint:
;; Assume that the difference between l0 and l is
;; (list x1 x2 x3). What is a, then?
;;
;; ...
;;
;; You may also be wondering why foldr/a consumes its
;; arguments in this unusual order, first the
;; accumulator and then the list. To understand the
;; reason for this ordering, imagine instead that
;; foldr/a also consumes f - as the first argument.
;; At this point it becomes abundantly clear that
;; foldr/a is foldl:

; version 5
; [X Y] [X Y -> Y] Y [List-of X] -> Y
(define (f*ldl f i l)
  (cond
    [(empty? l) i]
    [else (f*ldl f
                 (f (first l) i)
                 (rest l))]))


;; Task 2:
;; Design build-l*st using an accumulator-style
;; approach. The function must satisfy the
;; following tests:

#;(check-expect (build-l*st n f)
                (build-lst n f))

;; for any natural number n and function f.

(check-expect (build-l*st 2 (lambda (x) x))
              (build-list 2 (lambda (x) x)))
(check-expect (build-l*st 2 (lambda (x) 2))
              (build-list 2 (lambda (x) 2)))
(check-expect (build-l*st 109 (lambda (x) (* x x)))
              (build-list 109 (lambda (x) (* x x))))

; [N X] N [N -> X] -> [List-of X]
(define (build-l*st n0 f)
  (local [; N [List-of X] -> [List-of X]
          ; accumulator: a is a list of all elements
          ; from applying f to the natural numbers
          ; in the interval [n0, n)
          ; n is initially 0
          (define (bl/a n a)
            (cond
              [(zero? n) a]
              [else
               (bl/a (sub1 n)
                     (cons (f (sub1 n)) a))]))]
    (bl/a n0 '())))
