;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-423) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-423
;; Define partition. It consumes a String s and a
;; natural number n. The function produces a list of
;; string chunks of size n.
;;
;; For non-empty strings s and positive natural numbers
;; n,
;;
;; (equal? (partition s n)
;;         (bundle (explode s) n))
;;
;; is #true. But don't use this equality as the
;; definition for partition; use substring instead.
;;
;; Hint: Have partition produce its natural result
;; for the empty string. For the case where n is 0,
;; see ex-421.
;;
;; Note: The partition function is somewhat closer
;; to what a cooperative DrRacket environment would
;; need than bundle.

; String N -> [List-of String]
(check-expect (partition "abcd" 1)
              (bundle (explode "abcd") 1))
(check-expect (partition "abcd" 2)
              (bundle (explode "abcd") 2))
(check-expect (partition "abcd" 3)
              (bundle (explode "abcd") 3))
(check-expect (partition "abcd" 4)
              (bundle (explode "abcd") 4))
(check-expect (partition "abcd" 5)
              (bundle (explode "abcd") 5))

(define (partition s n)
  (local ((define string-size (string-length s))
          (define size (if (> n string-size)
                           string-size
                           n))
          (define first-part (substring s 0 size))
          (define rest-part (substring s size)))
    (cond [(empty? (explode s)) '()]
          [(zero? n) '()]
          [else (cons first-part
                      (partition rest-part n))])))


; [List-of 1String] N -> [List-of String]
; bundles chunks of s into strings of length n
; idea: take n items and drop n at a time
(check-expect (bundle '("a" "b" "c" "d") 1)
              '("a" "b" "c" "d"))
(check-expect (bundle '("a" "b" "c" "d") 2)
              '("ab" "cd"))
(check-expect (bundle '("a" "b" "c" "d") 3)
              '("abc" "d"))
(check-expect (bundle '("a" "b" "c" "d") 4)
              '("abcd"))
(check-expect (bundle '("a" "b" "c" "d") 5)
              '("abcd"))

(define (bundle s n)
  (map (lambda (s0) (implode s0))
       (list->chunks s n)))

; [List-of X] N -> [List-of [List-of X]
; computes a list of n sized chunks of items in l
; note: all chunks in the result are at most n length
(check-expect (list->chunks '() 1) '())
(check-expect (list->chunks '(a b c d) 1)
              '((a) (b) (c) (d)))
(check-expect (list->chunks '(a b c d) 2)
              '((a b) (c d)))
(check-expect (list->chunks '(a b c d) 3)
              '((a b c) (d)))
(check-expect (list->chunks '(a b c d) 4)
              '((a b c d)))
(check-expect (list->chunks '(a b c d) 5)
              '((a b c d)))

(define (list->chunks l n)
  (cond [(empty? l) '()]
        [else (cons (list* (take l n))
                    (list->chunks (drop l n) n))]))

; [List-of X] N -> [List-of X]
; keeps the first n items from l if possible
; or everything
(define (take l n)
  (cond [(zero? n) '()]
        [(empty? l) '()]
        [else (cons (first l)
                    (take (rest l) (sub1 n)))]))

; [List-of X] N -> [List-of X]
; removes the first n items from l if possible
; or everything
(define (drop l n)
  (cond [(zero? n) l]
        [(empty? l) l]
        [else (drop (rest l) (sub1 n))]))

