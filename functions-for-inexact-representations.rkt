;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname functions-for-inexact-representations) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define-struct inex [mantissa sign exponent])
;; An Inex is a structure:
;;   (make-inex N99 S N99)
;;
;; An S is one of:
;; - 1
;; - -1
;;
;; An N99 is an N between 0 and 99 (inclusive).

; N Number N -> Inex
; makes an instance of Inex after checking the arguments
(check-expect (create-inex 12 1 2) (make-inex 12 1 2))
(check-error (create-inex 120 1 2) "bad values given")
(check-error (create-inex 12 2 2) "bad values given")
(check-error (create-inex 12 1 100) "bad values given")

(define (create-inex m s e)
  (cond
    [(and (<= 0 m 99)
          (<= 0 e 99)
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

(define MAX-POSITIVE (create-inex 99 1 99))
(define MIN-POSITIVE (create-inex 1 -1 99))
