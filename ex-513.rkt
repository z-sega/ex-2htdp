;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-513) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-513
;; Develop a data representation for the same subset of
;; ISL+ that uses structures instead of lists. Also
;; provide data representations for ex1, ex2, and ex3
;; following your data definition.

; A Lam is one of
; - a Symbol
; - λExpr
; - Application
(define-struct λ-expr [para body])
; A λExpr is a structure:
;   (make-λ-expr Symbol Lam)
(define-struct app [fun arg])
; An Application is a structure:
;   (make-app Lam Lam)
; examples:
(define ex1
  (make-λ-expr 'x 'x))
(define ex2
  (make-λ-expr 'x 'y))
(define ex3
  (make-λ-expr 'y (make-λ-expr 'x 'y)))
(define ex4
  (make-app (make-λ-expr 'x 'x)
            (make-λ-expr 'x 'x)))
(define ex5
  (make-app (make-λ-expr 'x (make-app 'x 'x))
            (make-λ-expr 'x (make-app 'x 'x))))
(define ex6
  (make-app (make-app (make-λ-expr 'y (make-λ-expr 'x 'y))
                      (make-λ-expr 'z 'z))
            (make-λ-expr 'w 'w)))
