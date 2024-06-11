;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-381) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define xm0
  '(machine ((initial "red"))
            (action ((state "red") (next "green")))
            (action ((state "green") (next "yellow")))
            (action ((state "yellow") (next "red")))))

; An XMachine is a nested list of this shape:
; (cons 'machine (cons `((initial ,FSM-State)) [List-of X1T]))
;
; An X1T is a nested list of this shape:
; `(action ((state ,FSM-State) (next ,FSM-State)))

;; ex-381
;; The definitions of XMachine and X1T use quote, which
;; is highly inappropriate for novice program designers.
;; Rewrite them first to use list and then cons.

; Rewritten using list:
; An XMachine is a nested list of this shape:
;   (list 'machine
;         (list (list initial FSM-State))
;         [List-of X1T])
;
; An X1T is a nested list of this shape:
;   (list 'action
;          (list (list state FSM-State)
;                (list next FSM-State)))
(define list-ex-x1t (list 'action (list (list 'state "red")
                                        (list 'next "green"))))
(define list-ex-xmachine
  (list 'machine
        (list (list 'initial "red"))
        (list list-ex-x1t)))

; Rewritten using cons:
; An XMachine is a nested list of this shape:
;   (cons 'machine
;     (cons (cons (cons 'initial (cons FSM-State '())) '())
;           (cons [List-of X1T] '()))
;
; An X1T is a nested list of this shape:
;   (cons 'action
;      (cons (cons (cons 'state (cons FSM-State '()))
;              (cons (cons 'next (cons FSM-State '())) '()))
;         '()))
(define cons-ex-x1t
  (cons 'action
        (cons (cons (cons 'state (cons "red" '()))
               (cons (cons 'next (cons "green" '())) '()))
         '())))
(define cons-ex-xmachine
  (cons 'machine
        (cons (cons (cons 'initial (cons "red" '())) '())
              (cons (list cons-ex-x1t) '()))))

(check-expect cons-ex-x1t list-ex-x1t)
(check-expect cons-ex-xmachine list-ex-xmachine)