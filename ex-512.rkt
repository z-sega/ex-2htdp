;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-512) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Sample Problem:
;; You have been hired to re-create a part of the ISL+
;; compiler. Specifically, your task deals with the
;; following language fragment, specified in the
;; so-called grammar notation that many programming
;; language manuals use:

;; expression = variable
;;            | (lambda (variable) expression)
;;            | (expression expression)

;; Develop a data representation for the above langauge
;; fragment; use symbols to represent variables.
;; Then design a function that replaces all undeclared
;; variables with '*undeclared.

; A λExpression is (list 'λ (list Symbol) Lam)
; An Application is (list Lam Lam)

; A Lam is one of:
; - a Symbol
; - λExpression
; - Application

;; λ:
(define ex1 '(λ (x) x))
(define ex2 '(λ (x) y))
(define ex3 '(λ (y) (λ (x) y)))
(define ex4 '((λ (x) (x x)) (λ (x) (x x))))
(define ex5 '(((λ (y) (λ (x) y)) (λ (z) z)) (λ (w) w)))


;; ex-512
;; Define is-var?, is-λ?, and is-app?, that is, predicates
;; that distinguish variables from λ expressions and
;; applications
;;
;; Also define:
;; λ-para, which extracts the parameter from a λ expression;
;; λ-body, which extracts the body from a λ expression;
;; app-fun, which extracts the function from an application;
;; and
;; app-arg, which extracts the argument from an application.

; Lam -> Boolean
; #true if expr is a variable
(check-expect (is-var? 'x) #true)
(check-expect (is-var? ex1) #false)
(check-expect (is-var? ex4) #false)

(define (is-var? expr) (symbol? expr))

; Lam -> Boolean
; #true if expr is a λ expression
(check-expect (is-λ? 'x) #false)
(check-expect (is-λ? ex1) #true)
(check-expect (is-λ? ex4) #false)

(define (is-λ? expr)
  (cond
    [(symbol? expr) #false]
    [(and (cons? expr)
          (symbol? (first expr))
          (symbol=? 'λ (first expr))) #true]
    [(and (cons? expr) (= (length expr) 2)) #false]))


; Lam -> Boolean
; #true if expr is an application
(check-expect (is-app? 'x) #false)
(check-expect (is-app? ex1) #false)
(check-expect (is-app? ex4) #true)

(define (is-app? expr)
  (cond
    [(symbol? expr) #false]
    [(and (cons? expr)
          (symbol? (first expr))
          (symbol=? 'λ (first expr))) #false]
    [(and (cons? expr) (= (length expr) 2)) #true]))

; λExpression -> Symbol
; extracts the parameter from λ-expr
(check-expect (λ-para ex1) 'x)
(check-expect (λ-para ex2) 'x)
(check-expect (λ-para ex3) 'y)

(define (λ-para λ-expr) (first (second λ-expr)))

; λExpression -> Lam
; extracts the body from λ-expr
(check-expect (λ-body ex1) 'x)
(check-expect (λ-body ex2) 'y)
(check-expect (λ-body ex3) '(λ (x) y))

(define (λ-body λ-expr) (third λ-expr))

; Application -> Lam
; extracts the function from an application
(check-expect (app-fun ex4) (first ex4))
(check-expect (app-fun ex5) (first ex5))

(define (app-fun app) (first app))

; Application -> Lam
; extracts the argument from an application
(check-expect (app-arg ex4) (second ex4))
(check-expect (app-arg ex5) (second ex5))

(define (app-arg app) (second app))

;; With these predicates and selectors, you basically can
;; act as if you had defined a structure-oriented
;; data representation.
;;
;; Design declareds, which produces the list of
;; all symbols used as λ parameters in a λ term. Don't
;; worry about duplicate symbols

; Lam -> [List-of Symbol]
; computes all symbols used as parameters in λ-expr
(check-expect (declareds 'x) '())
(check-expect (declareds ex1) '(x))
(check-expect (declareds ex2) '(x))
(check-expect (declareds ex3) '(y x))
(check-expect (declareds ex4) '(x x))
(check-expect (declareds ex5) '(y x z w))

(define (declareds expr)
  (local [; λExpression -> [List-of Symbol] 
          (define (declareds/λ λ-expr)
            (second λ-expr))]
    (cond
      [(is-var? expr) '()]
      [(is-λ? expr) (append (declareds/λ expr)
                            (declareds (third expr)))]
      [(is-app? expr)
       (append (declareds (first expr))
               (declareds (second expr)))])))
  
  