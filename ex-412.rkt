;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-412) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct inex [mantissa sign exponent])
;; An Inex is a structure:
;;   (make-inex N99 S N99)
;;
;; An S is one of:
;; - 1
;; - -1
;;
;; An N99 is an N between 0 and 99 (inclusive).
(define MIN-N99 0)
(define MAX-N99 99)

; N Number N -> Inex
; makes an instance of Inex after checking the arguments
(check-expect (create-inex 12 1 2) (make-inex 12 1 2))
(check-error (create-inex 120 1 2) "bad values given")
(check-error (create-inex 12 2 2) "bad values given")
(check-error (create-inex 12 1 100) "bad values given")

(define (create-inex m s e)
  (cond
    [(and (<= 0 m MAX-N99)
          (<= 0 e MAX-N99)
          (or (= s 1)
              (= s -1))) (make-inex m s e)]
    [else (error "bad values given")]))

; Inex -> Number
; converts an inex into its numeric equivalent
(check-expect (inex->number (make-inex 12 1 2)) 1200)

(define (inex->number an-inex)
  (* (inex-mantissa an-inex)
     (expt 10
           (* (inex-sign an-inex)
              (inex-exponent an-inex)))))

;; With create-inex it is also easy to delimit the range
;; of representable numbers, which is actually quite
;; small for many applications:

(define MAX-POSITIVE (create-inex MAX-N99 1 MAX-N99))
(define MIN-POSITIVE (create-inex 1 -1 MAX-N99))


;; ex-412
;; Design inex+. The function adds two Inex representations
;; of numbers that have the same exponent. The function
;; must be able to deal with inputs that increase the
;; exponent. Furthermore, it must signal its own error
;; if the result is out of range, not rely on create-inex
;; for error checking.

; Inex Inex -> Inex
; adds a and b that have the same exponent (and sign).
(check-expect (inex+ (create-inex 55 1 0)
                     (create-inex 55 1 0))
              (create-inex 11 1 1))
(check-expect (inex+ (create-inex 56 1 0)
                     (create-inex 56 1 0))
              (create-inex 11 1 1))
(check-error (inex+ (create-inex 99 1 99)
                    (create-inex 99 1 99))
             "(+ a b) cannot be represented")

(define (inex+ a b)
  (local ((define sign (inex-sign a))
          (define exp (inex-exponent a))

          (define m-sum (+ (inex-mantissa a)
                           (inex-mantissa b)))
          
          (define m-sum-corrected
            (if (> m-sum MAX-N99)
                (round (/ m-sum 10))
                m-sum))
          (define exp-corrected
            (if (> m-sum MAX-N99)
                (add1 exp)
                exp)))
    (if (or (> m-sum-corrected MAX-N99)
            (> exp-corrected MAX-N99))
        (error "(+ a b) cannot be represented")
        (make-inex m-sum-corrected
                   sign
                   exp-corrected))))