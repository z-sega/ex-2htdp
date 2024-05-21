#lang htdp/isl+

;; ex-288
;; Use build-list to define a function that
;; 1. creates the list (list 0 ... (- n 1)) for
;; any natural number n;

; N is a Natural Number
; N -> [List-of N]
; creates the list (list 0 ... (- n 1)) for n
(check-expect (exclusive-n-list 3)
              (list 0 1 2))
(define (exclusive-n-list n)
  (build-list n (lambda (x) x)))
  
;; 2. creates the list (list 1 ... n) for any natural
;; number n;

; N -> [List-of N]
; creates the list (list 0 ... n) for n
(check-expect (inclusive-n-list 3)
              (list 0 1 2 3))
(define (inclusive-n-list n)
  `(,@(build-list n (lambda (x) x)) ,n))

;; 3. creates the list (list 1 1/2 ... 1/n) for any natural
;; number n;

; N -> [List-of Number]
; creates the list (list 1 1/2 ... 1/n) for any natural
; number n
(check-expect (fractional-n-list 3)
              (list 1 1/2 1/3))
(check-expect (fractional-n-list 5)
              (list 1 1/2 1/3 1/4 1/5))
(define (fractional-n-list n)
  (build-list n (lambda (x)
                  (/ 1 (add1 x)))))

;; 4. creates the list of the first n even numbers; and

; N -> [List-of Number]
; creates the list of the first n even numbers;
(check-expect (even-list 4)
              (list 2 4 6 8))
(define (even-list n)
  (build-list n (lambda (x)
                  (* (add1 x) 2))))

;; 5. creates a diagonal square of 0s and 1s;
;; see ex-262

; N -> [List-of [List-of Number]]
; creates the diagonal square of n composed
; of 0s and 1s
(check-expect (identityM 2)
              (list (list 1 0) (list 0 1)))
(define (identityM n)
  (build-list n (lambda (i)
                  (build-list n (lambda (j)
                                  (if (= i j) 1 0))))))
  

;; Finally, define tabulate from ex-250 using build-list.

; Number -> [List-of Number]
; tabulates sin between n and 0 (incl.) in a list.
(define (tab-sin n)
  (cond
    [(= n 0) (list (sin 0))]
    [else (cons (sin n) (tab-sin (sub1 n)))]))

; Number -> [List-of Number]
; tabulates f between n and 0 (incl.) in a list
(check-within (tabulate 4 sin) (tab-sin 4) 0.0001)
(define (tabulate n f)
  (reverse (build-list (add1 n) (lambda (x) (f x)))))
