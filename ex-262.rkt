#lang htdp/isl

;; NOT MY ANSWER, I STILL DON'T GET THIS ...
;; https://gitlab.com/cs-study/htdp/-/blob/main/03-Abstraction/16-Using-Abstractions/Exercise-262.rkt?ref_type=heads

;; ex-262
;; Design the function identityM, which creates diagonal
;; squares of 0s and 1s:
;; Use the structural design recipe and exploit the power of local.


; list-of-number is one of:
; - '()
; - (cons Number list-of-number)
; - or -
; [List-of Number]

(define l1 (list 1))

(define l2a (list 1 0))
(define l2b (list 0 1))

(define l3a (list 1 0 0))
(define l3b (list 0 1 0))
(define l3c (list 0 0 1))

; A Matrix is one of:
; - '()
; - (cons list-of-number Matrix)
; - or -
; A Matrix is a [List-of [List-of Number]]
(define m0 '())
(define m1 (list l1))
(define m2 (list l2a
                 l2b))
(define m3 (list l3a
                 l3b
                 l3c))


; Number -> Matrix
; computes the identity matrix for the given integer n
(check-expect (identityM 1) m1)
(check-expect (identityM 2) m2)
(check-expect (identityM 3) m3)
(define (identityM size0)
  (local [; Number Number -> Matrix
          (define (build-matrix size 1-pos)
            (cond
              [(> 1-pos size) '()]
              [else
               (cons (build-row size 1-pos 1)
                     (build-matrix size (add1 1-pos)))]))

          ; Number Number Number -> [List-of Number]
          (define (build-row size 1-pos current)
            (cond
              [(> current size) '()]
              [else
               (cons (if (= current 1-pos) 1 0)
                     (build-row size 1-pos (add1 current)))]))
          ]
    ; - IN
    (build-matrix size0 1)))
