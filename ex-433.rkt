;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-433) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

; [List-of X] N -> [List-of [List-of X]]
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

;; ex-433
;; Develop a checked version of bundle that is
;; guaranteed to terminate for all inputs. It may
;; signal an error for those cases where the original
;; version loops.

; [List-of 1String] N -> [List-of String]
; bundles chunks of s into strings of length n
(check-expect (checked-bundle '("a" "b" "c" "d") 1)
              '("a" "b" "c" "d"))
(check-expect (checked-bundle '() 0)
             '())
(check-error (checked-bundle '("a" "b" "c" "d") 0)
             "INFINITE LOOP")

(define (checked-bundle s n)
  (if (and (zero? n) (cons? s)) (error "INFINITE LOOP")
      (bundle s n)))

; [List-of 1String] N -> [List-of String]
; bundles chunks of s into strings of length n
; how: bundles by taking n items and dropping n at a
; time
; termination: (bundle s 0) loops infinitely unless s
; is '()
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
