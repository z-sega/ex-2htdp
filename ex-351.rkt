;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-351) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/abstraction)

(define-struct add [left right])
(define-struct mul [left right])

; An BSL-expr is one of:
; - Number
; - (make-add BSL-expr BSL-expr)
; - (make-mul BSL-expr BSL-expr)

; A BSL-eval is a Number
; *interpretation*
; Is any value to which a representation of a BSL-expr
; can evaluate to.

(define WRONG "invalid expression")

;; ex-351
;; Design interpreter-expr. The function accepts S-expressions.
;; If parse recognizes them as BSL-expr, it produces their value.
;; Otherwise, it signals the same error as parse.

; S-expr -> BSL-eval
; computes value of s if it is a valid BSL-expr
; else ERROR
(check-expect (interpreter-expr 3) 3)
(check-expect (interpreter-expr '(+ 3 3)) 6)
(check-expect (interpreter-expr '(* 3 3)) 9)
(check-expect (interpreter-expr '(+ (* 3 3) (* 2 2))) 13)
(check-expect (interpreter-expr '(* (+ 3 3) (+ 2 2))) 24)
(check-error (interpreter-expr "f") WRONG)
(check-error (interpreter-expr 'f) WRONG)
(check-error (interpreter-expr '(/ 3 1)) WRONG)
(check-error (interpreter-expr '(* (sqr 3) 1)) WRONG)

(define (interpreter-expr s)
  (local (; BSL-expr -> BSL-eval
          ; computes value of given bsl-expr
          (define (eval-expr s)
            (match s
              [(? number?) s]
              [(add x y) (+ (eval-expr x)
                            (eval-expr y))]
              [(mul x y) (* (eval-expr x)
                            (eval-expr y))])))
    ; S-expr -<parse>-> BSL-expr -<eval-expr>-> BSL-eval
    (eval-expr (parse s))))

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
  
