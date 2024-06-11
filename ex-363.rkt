;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-363) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
;; ex-363
;; All elements of Xexpr.v2 start with a Symbol, but some are followed
;; by a list of attributes and some by just a list of Xexpr.v2s.
;; Reformulate the definition of Xexpr.v2 to isolate the common
;; beginning and highlight the different kinds of endings.
;;
;; Eliminate the use of List-of from Xexpr.v2.

; An Xexpr.v2 is a list:
; - (cons Symbol Body)
; - (cons Symbol (cons [List-of Attribute] Body))
; where Body is short for [List-of Xexpr.v2]
; An Attribute is a list of two items:
;   (cons Symbol (cons String '()))

;; -----

; An Attribute is a list of two items:
;   (cons Symbol (cons String '()))
(define attr '(initial "red"))

; A Body is one of:
; - '()
; - (cons [List-of Attribute] Body)
; - (cons Xexpr.v2 Body)
(define three-action '((action) (action) (action)))
(define attr-three-action (cons (list attr attr) three-action))

; An Xexpr.v2 is a list:
;   (cons Symbol Body)
(define machine-with-actions (cons 'machine three-action))
(define machine-with-attrs-and-actions (cons 'machine attr-three-action))

