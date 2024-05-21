;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname isl-for-loops) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
(require 2htdp/abstraction)

;; examples
(for/list ([i 10]) i)
  
(build-list 10 (lambda (i) i))


(for/list ([i 2]
           [j '(a b)])
  (list i j))

(local ((define i-s (build-list 2 (lambda (i) i)))
        (define j-s '(a b)))
  (map list i-s j-s))


;; final example:
;; Design enumerate. The function consumes a list and
;; produces a list of the same items paired with their
;; relative index.

;; Stop! Design this function systematically, using
;; ISL+'s abstractions

; [List-of X] -> [List-of [List-of N X]]
; consumes a list and produces a list of the same
; items paired with their relative index.
(check-expect (enumerate '(a b)) (list (list 1 'a)
                                       (list 2 'b)))
(check-expect (enumerate '(1 2 3)) (list (list 1 1)
                                         (list 2 2)
                                         (list 3 3)))
(define (enumerate l)
  (build-list (length l) (lambda (i)
                           (list (+ i 1) (list-ref l i)))))

;; With for/list, this problem has a straightforward solution

; [List-of X] -> [List-of [List-of N X]]
; pairs each item in lx with its index
(check-expect (enumerate.for '(a b c)) '((1 a) (2 b) (3 c)))

(define (enumerate.for lx)
  (for/list ([ith (length lx)]
             [x lx])
    (list (+ ith 1) x)))

;; ----
(define width 2)

(for/list ([width 3]
           [height width])
  (list width height))

(for*/list ([width 3]
           [height width])
  (list width height))

;; Sample Problem
;; Design cross. The function consumes two lists, l1
;; and l2, and produces pairs of all items from
;; these lists.

;; Stop! Take a moment to design the function, using the
;; existing abstractions.

; [X Y] [List-of X] [List-of Y] -> [List-of [List-of X Y]]
; produces pairs of all items from these l1 and l2
(check-expect (cross '(a b c) (list 1 2))
              (list (list 'a 1) (list 'a 2) (list 'b 1)
                    (list 'b 2) (list 'c 1) (list 'c 2)))
(check-satisfied (cross '(a b c) (list 1 2))
                 (lambda (x) (equal? (length x) 6)))

(define (cross l1 l2)
  (local (; X -> [List-of [List-of X Y]]
          ; combines given x (from l1) with elements
          ; in l2
          (define (with-l2 x)
            (map (lambda (y) (list x y)) l2)))
    (foldr (lambda (x acc)
            (append `,(with-l2 x) acc)) '() l1)))

;; -> Since the purpose of for*/list is an enumeration
;; of all such pairs, defining cross via for*/list
;; is straightforward:

; [List-of X] [List-of Y] -> [List-of [List-of X Y]]
; generates all pairs of items from l1 and l2
(check-satisfied (cross.for* '(a b c) '(1 2))
                 (lambda (x) (= (length x) 6)))

(define (cross.for* l1 l2)
  (for*/list ([x1 l1]
              [x2 l2])
    (list x1 x2)))

;; Another use of for*/list.
;; A compact solution of the extended design problem
;; of creating all possible rearrangements of the
;; letters in a given list.

; [List-of X] -> [List-of [List-of X]]
; creates a list of all rearrangements of the items
; in w
(define (arrangements w)
  (cond
    [(empty? w) '(())]
    [else (for*/list ([item w]
                      [arrangement-without-item (arrangements
                                                 (remove item w))])
            (cons item arrangement-without-item))]))


;; The .../list suffix clearly signals that the loop expression
;; creates a list. In addition, the teachpack comes with for
;; and for* loops that have equally suggestive suffixes:
;; 
;; - .../and collects the values of all iterations with and:
;; for pragramatics, the loop returns the last generated value or
;; #false.

(for/and ([i 10]) (> (- 9 i) 0))
(for/and ([i 10]) (if (>= i 0) i #false))

;; Stop again! It is an instructive exercise to reformulate
;; all of the above examples using the existing abstractions
;; in ISL+. Doing so also indicates how to design functions with
;; for loops instead of abstract functions.
;; *Hint*
;; Design and-map and or-map, which work like andmap and ormap,
;; respectively, but which return the appropriate non-#false
;; values.

(define ABC "abc")
(define l (build-list 10 (lambda (i) i)))
(define str-l (explode ABC))

; [X -> Boolean] [List-of X] -> Boolean
; works like andmap: #t if p for all elements in l
(check-expect (and-map (lambda (x) (>= x 0)) l)
              (andmap (lambda (x) (>= x 0)) l))
(check-expect (and-map (lambda (x) (< x 10)) l)
              (andmap (lambda (x) (< x 10)) l))

(define (and-map p l)
  (foldr (lambda (i acc) (and (p i) acc)) #true l))


; [X -> Boolean] [List-of X] -> Boolean
; works like ormap: #t if p for any element in l
(check-expect (or-map odd? l) (ormap odd? l))
(check-expect (or-map even? l) (ormap even? l))
(check-expect (or-map negative? l) (ormap negative? l))

(define (or-map p l)
  (foldr (lambda (i acc) (or (p i) acc)) #false l))

;; HINT-COMPLETE

; [X -> Boolean] [List-of X] -> Boolean
; works like for/and: #false or the last generated value

(check-expect (for/and.copy (lambda (i) (> (- 9 i) 0)) l)
              (for/and ([i l]) (> (- 9 i) 0)))
(check-expect (for/and.copy (lambda (i) (>= i 0)) l)
              (for/and ([i l]) (if (>= i 0) i #false)))

(define (for/and.copy p l)
  (local ((define l-reverse (reverse l)))
    (foldr (lambda (i acc)
             (if (p i) i #false)) #false l-reverse)))


; [X -> Boolean] [List-of X] -> Boolean
; works like for/or: #false or the first value not #false
(check-expect (for/or.copy (lambda (i) (= (- 9 i) 0)) l)
              (for/or ([i l]) (if (= (- 9 i) 0) i #false)))
(check-expect (for/or.copy (lambda (i) (< i 0)) l)
              (for/or ([i l]) (if (< i 0) i #false)))

(define (for/or.copy p l)
  (foldr (lambda (i acc) (if (p i) i #false)) #false l))

; [X] [X -> Number] [List-of X] -> Number
; works like for/sum: adds up the numbers that the iterations
; generate
(check-expect (for/sum.copy string->int str-l)
              (for/sum ([c ABC]) (string->int c)))

(define (for/sum.copy f l)
  (foldr (lambda (i acc) (+ (f i) acc)) 0 l))


; [X] [X -> Number] [List-of X] -> Number
; works like for/product: multiplies the numbers that the
; iterations generate
(check-expect (for/product.copy
                  (lambda (i) (+ (string->int i) 1)) str-l)
              (for/product ([c ABC]) (+ (string->int c) 1)))

(define (for/product.copy f l)
  (foldr (lambda (i acc) (* (f i) acc)) 1 l))


; [X] [X -> 1String] [List-of X] -> String
; works like for/string: creates Strings from the (1String)
; sequence
(define a (string->int "a"))
(check-expect (for/string.copy
                  (lambda (i) (int->string (+ a i))) l)
              (for/string ([j l]) (int->string (+ a j))))

(define (for/string.copy f l)
  (foldr (lambda (i acc) (string-append (f i) acc)) "" l))


;; ----------------------

(define (enumerate.v2 lx)
  (for/list ([item lx]
             [ith (in-naturals 1)])
    (list ith item)))

; N -> Number
; adds the even numbers between 0 and n (exclusive)
(check-expect (sum-evens 2) 0)
(check-expect (sum-evens 8) 12) 
(define (sum-evens n)
  (for/sum ([i (in-range 0 n 2)]) i))
