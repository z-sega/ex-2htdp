#lang htdp/isl+

;; ex-299
;; Design a data representation for finite and infinite sets so
;; that you can represent the sets of all odd numbers, all
;; even numbers, all numbers divisible by 10, and so on.
;;
;; Design the functions add-element, which adds an element
;; to a set; union, which combines the elements of two sets;
;; and intersect, which collects all elements common to two
;; sets.
;;
;; *Hint* Mathematicians deal with sets as functions that
;; consume a potential element ed and produce #true only
;; if ed belongs to the set.


; A Set is a Function:
;   [Number -> Boolean]
;
; *interpretation*
; if s is a set of numbers and n is a number.
; (s n) evaluates to #t if n is an element of s.
; *example*
(define even-number-set
  (lambda (n)
    (even? n)))

(define odd-number-set
  (lambda (n)
    (odd? n)))

(define divisible-by-ten-number-set
  (local ((define (divisible-by-ten? n)
            (equal? 0 (modulo n 10))))
    (lambda (n)
      (divisible-by-ten? n))))

; [Number -> Boolean] -> [Number -> Boolean]
; returns a function that creates
; sets based on the Set representation
; given fn which is #t when applied to
; some number that is part of the set.
; TLDR: helper for creating sets ...
(define (mk-set fn)
  ; Number -> Boolean
  (lambda (n) (fn n)))

(define even-number-set.v2 (mk-set even?))
(define odd-number-set.v2 (mk-set odd?))
(define divisible-by-ten-number-set.v2
  (local ((define (divisible-by-ten? n)
            (equal? 0 (modulo n 10))))
    (mk-set divisible-by-ten?)))
(define empty-set (mk-set (lambda (n) #false)))

; Set Number -> Boolean
; #t if n is in s
(check-expect (inside? even-number-set 2) #true)
(check-expect (inside? even-number-set 1) #false)
(check-expect (inside? even-number-set.v2 2) #true)
(check-expect (inside? odd-number-set 1) #true)
(check-expect (inside? odd-number-set 2) #false)
(check-expect (inside? odd-number-set.v2 1) #true)
(check-expect (inside? divisible-by-ten-number-set 20) #true)
(check-expect (inside? divisible-by-ten-number-set 2) #false)
(check-expect (inside? divisible-by-ten-number-set.v2 20) #true)
(check-expect (inside? empty-set 2) #false)
(check-expect (inside? empty-set 1) #false)
(check-expect (inside? empty-set 10) #false)
(define (inside? s n) (s n))

; Set Number -> [Number -> Boolean]
; adds n to s
; *detail* given a set s and
; a number n, returns a function that
; is true when applied s is applied to n
(check-expect (inside? (add-element empty-set 2) 2)
              #true)
(check-expect (inside? (add-element empty-set 2) 1)
              #false)
(check-expect (inside? (add-element empty-set 1) 1)
              #true)
(define (add-element s n)
  (lambda (n0)
    (or (= n n0)
        (s n0))))

; Set Set -> [Number -> Boolean]
; combines the elements of sets a and b
(check-expect (inside? (union even-number-set odd-number-set) 1)
              #true)
(check-expect (inside? (union even-number-set odd-number-set) 2)
              #true)
(check-expect (inside? (union even-number-set
                              divisible-by-ten-number-set) 2)
              #true)
(check-expect (inside? (union even-number-set
                              divisible-by-ten-number-set) 20)
              #true)
(check-expect (inside? (union even-number-set
                              divisible-by-ten-number-set) 3)
              #false)
(define (union a b)
  (lambda (n)
    (or (a n)
        (b n))))

; Set Set -> [Number -> Boolean]
; collects all elements common to two sets
(check-expect (inside? (intersect even-number-set odd-number-set) 2)
              #false)
(check-expect (inside? (intersect even-number-set odd-number-set) 1)
              #false)
(check-expect (inside? (intersect even-number-set
                                  divisible-by-ten-number-set) 20)
              #true)
(check-expect (inside? (intersect even-number-set
                                  divisible-by-ten-number-set) 2)
              #false)
(define (intersect a b)
  (lambda (n)
    (and (a n)
         (b n))))
