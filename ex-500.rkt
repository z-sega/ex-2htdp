;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-500) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-500 - CURIOSITY: Tail Optimization
;; Design an accumulator-style version of how-many,
;; which is the function that determines the number of
;; items on a list. Stop when you have formulated the
;; invariant and have someone check it.
;;
;; The performance of how-many is O(n) where n is the
;; length of the list. Does the accumulator version
;; improve on this?

; [List-of X] -> N
; computes the length of l
(check-expect (how-many.v1 '()) 0)
(check-expect (how-many.v1 '(1)) 1)
(check-expect (how-many.v1 '(a b c d e)) 5)

(define (how-many.v1 l)
  (cond [(empty? l) 0]
        [else (add1 (how-many.v1 (rest l)))]))

; [List-of X] -> N
; computes the length of l0
(check-expect (how-many.v2 '()) 0)
(check-expect (how-many.v2 '(1)) 1)
(check-expect (how-many.v2 '(a b c d e)) 5)

(define (how-many.v2 l0)
  (local [; [List-of X] N -> N
          ; computes the length of l
          ; accumulator: a is the count of elements
          ; in l0 that are not on l
          (define (how-many/a l a)
            (cond [(empty? l) a]
                  [else (how-many/a (rest l)
                                    (add1 a))]))]
    (how-many/a l0 0)))


;; The performance of how-many is O(n) where n is the
;; length of the list. Does the accumulator version
;; improve on this?
;; The accumulator-style function faster, it
;; takes about half the time to run that v1, but the
;; improvement is still performing on the order of n.
;;
;; n       v1-time (ms) v2-time (ms)
;; ---------------------------------
;; 100     0            0
;; 1000    0            0
;; 10000   2            1
;; 100000  22           15
;; 1000000 270          174

;; compare:
;; [List-of X] N -> N
;; run f on a list of length n
(define (run-f-on-list f n)
  (f (build-list n (lambda (x) (add1 x)))))

(time (run-f-on-list how-many.v1 1000000))
(time (run-f-on-list how-many.v2 1000000))

;; When you evaluate (how-many some-non-empty-list)
;; by hand, n applications of add1 are pending by
;; the time the function reaches '() - where n is
;; the number of items on the list. Computer scientists
;; sometime say that how-many needs O(n) space to
;; represent these pending function applications.
;; Q: Does the accumulator reduce the amount of space 
;; needed to compute the result?
;; A: Yes. In the accumulator no additions are pending
;; because they are performed at each iteration
;; (add1 a). This means that the space requirement is
;; constant, maybe O(1).
;;
;; Note: Computer scientists refer to this space as
;; stack space.
