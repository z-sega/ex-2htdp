;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-349) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/abstraction)

(define-struct add [left right])
(define-struct mul [left right])

;; ex-349
;; Create tests for parse until DrRacket tells you that every
;; element in the definitions area is covered during the
;; test run.

(define WRONG "invalid expression")

; S-expr -> BSL-expr
(check-expect (parse 3) 3)
(check-expect (parse '(+ 3 3)) (make-add 3 3))
(check-expect (parse '(* 3 3)) (make-mul 3 3))

(define (parse s)
  (cond
    [(atom? s) (parse-atom s)]
    [else (parse-sl s)]))

; SL -> BSL-expr
(check-expect (parse-sl '(+ 3 3)) (make-add 3 3))
(check-expect (parse-sl '(+ (+ 3 3) (+ 3 3))) (make-add (make-add 3 3)
                                                        (make-add 3 3)))
(check-expect (parse-sl '(* 3 3)) (make-mul 3 3))
(check-expect (parse-sl '(* (* 3 3) (* 3 3))) (make-mul (make-mul 3 3)
                                                        (make-mul 3 3)))
(check-error (parse-sl '(/ 3 1)) WRONG)
(check-error (parse-sl '(* 3 3 3)) WRONG)
(check-error (parse-sl '(* 3)) WRONG)

(define (parse-sl s)
  (cond
    [(and (consists-of-3 s) (symbol? (first s)))
     (cond
       [(symbol=? (first s) '+) (make-add (parse (second s))
                                          (parse (third s)))]
       [(symbol=? (first s) '*) (make-mul (parse (second s))
                                          (parse (third s)))]
       [else (error WRONG)])]
    [else (error WRONG)]))

; Atom -> BSL-expr
(check-expect (parse-atom 3) 3)
(check-error (parse-atom "s") WRONG)
(check-error (parse-atom 's) WRONG)

(define (parse-atom s)
  (cond
    [(number? s) s]
    [(string? s) (error WRONG)]
    [(symbol? s) (error WRONG)]))

; SL -> Boolean
(check-expect (consists-of-3 '(+ 3 3)) #true)
(check-expect (consists-of-3 '(+ 3 3 4)) #false)

(define (consists-of-3 s)
  (and (cons? s) (cons? (rest s)) (cons? (rest (rest s)))
       (empty? (rest (rest (rest s))))))
  
  
; S-expr -> Boolean
; #t if s is an atom
(check-expect (atom? 3) #true)
(check-expect (atom? "s") #true)
(check-expect (atom? 's) #true)
(check-expect (atom? '()) #false)

(define (atom? s)
  (or (number? s) (string? s) (symbol? s)))
  