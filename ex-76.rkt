#lang htdp/bsl

; Posn is (make-posn Number Number)

(define-struct movie [title producer year])
; Movie is (make-movie String String String)

(define-struct person [name hair eyes phone])
; Person is (make-person String String String String)

(define-struct pet [name number])
; Pet is (make-pet String Number)

(define-struct CD [artist title price])
; CD is (make-CD String String Number)

(define-struct sweater [material size producer])
; Sweater is (make-sweater String String String)
