;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-502) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-502
;; Design the function palindrom, which accepts a
;; non-empty list and constructs a palindrom by
;; mirroring the list around the last item. When give
;; (explode "abc"), it yields (explode "abcda").
;;
;; Hint:
;; Here is a solution designed by function composition:

; [NEList-of 1String] -> [NEList-of 1String]
; creates a palindrome from s0
(check-expect (mirror (explode "abc"))
              (explode "abcba"))

(define (mirror s0)
  (append (all-but-last s0)
          (list (last s0))
          (reverse (all-but-last s0))))

;; See Auxiliary Functions that Generalize for last;
;; design all-but-last in an analogous manner.

; [NEList-of X] -> [NEList-of X]
; l without the last item
(check-expect (all-but-last '(a)) '())
(check-expect (all-but-last '(a b)) '(a))
(check-expect (all-but-last '(a b c d)) '(a b c))

(define (all-but-last l)
  (cond
    [(empty? (rest l)) '()]
    [else (cons (first l)
                (all-but-last (rest l)))]))

; [NEList-of X] -> X
; last item on l
(check-expect (last '(a)) 'a)
(check-expect (last '(a b)) 'b)
(check-expect (last '(a b c d)) 'd)

(define (last l)
  (cond
    [(empty? (rest l)) (first l)]
    [else (last (rest l))]))

;; This solution traverse s0 four times:
;; 1. via all-but-last,
;; 2. via last,
;; 3. via all-but-last again, and
;; 4. via reverse, which is ISL+'s version of invert.
;;
;; Even with local definition for the result of
;; all-but-last, the function needs three traversals.
;; While these traversals aren't "stacked" and therefore
;; don't have a disastrous impact on the function's
;; performance, an accumulator version can compute the
;; same result with a single traversal.

; [NEList-of 1String] -> [NEList-of 1String]
; creates a palindrome from s0
(check-expect (palindrome (explode "a"))
              (explode "a"))
(check-expect (palindrome (explode "ab"))
              (explode "aba"))
(check-expect (palindrome (explode "abc"))
              (explode "abcba"))

(define (palindrome l0)
  (local [; [NEList-of 1String] [NEList-of 1String]
          ; -> [NEList-of 1String]
          ; creates a palindrome of l0 by appending
          ; l0 to a
          ; accumulator: a is a list of elements from
          ; l0, except the last item, that are not in l
          (define (palindrome/a l a)
            (cond
              [(empty? (rest l)) (append l0 a)]
              [else
               (palindrome/a (rest l)
                             (cons (first l) a))]))]
    (palindrome/a l0 '())))
