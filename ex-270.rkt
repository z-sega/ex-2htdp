;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname |270|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-270
;; Use build-list to define a function that
;; 1. creates the list (list 0 ... (- n 1)) for
;; any natural number n;

; N is a Natural Number
; N -> [List-of N]
; creates the list (list 0 ... (- n 1)) for n
(check-expect (exclusive-n-list 3)
              (list 0 1 2))
(define (exclusive-n-list n)
  (local (; N -> N
          ; returns x
          (define (f x) x))
  (build-list n f)))
  
;; 2. creates the list (list 1 ... n) for any natural
;; number n;

; N -> [List-of N]
; creates the list (list 0 ... n) for n
(check-expect (inclusive-n-list 3)
              (list 0 1 2 3))
(define (inclusive-n-list n)
  (local (; N -> N
          ; returns x
          (define (f x) x))
  (append (build-list n f) `(,n))))

;; 3. creates the list (list 1/2 ... 1/n) for any natural
;; number n;

; N -> [List-of Number]
; creates the list (list 1/2 ... 1/n) for any natural
; number n
(check-expect (fractional-n-list 3)
              (list 1/2 1/3))
(check-expect (fractional-n-list 5)
              (list 1/2 1/3 1/4 1/5))
(define (fractional-n-list n)
  (local (; N -> Number
          ; computes the fraction of 1/(+ 1 x)
          (define (f x) (/ 1 (add1 x)))
          ; N -> Boolean
          ; #t if x is not 1
          (define (not-one x) (if (eq? x 1) #f #t)))
    (filter not-one (build-list n f))))

;; 4. creates the list of the first n even numbers; and

; N -> [List-of Number]
; creates the list of the first n even numbers;
(check-expect (even-list 4)
              (list 2 4 6 8))
(define (even-list n)
  (local (; N -> N
          ; adds one to n and multplies result by 2
          (define (f x) (* (add1 x) 2)))
    (build-list n f)))

;; 5. creates a diagonal square of 0s and 1s;
;; see ex-262

; N -> [List-of [List-of Number]]
; creates the diagonal square of n composed
; of 0s and 1s
(check-expect (identityM 2)
              (list (list 1 0) (list 0 1)))
(define (identityM n)
  (build-list n
              (lambda (i)
                (build-list n
                            (lambda (j)
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
  (append (reverse
           (build-list n (lambda (i) (f (add1 i)))))
          (list (f 0))))
