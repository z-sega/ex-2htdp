;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-516) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-513
;; Develop a data representation for the same subset of
;; ISL+ that uses structures instead of lists. Also
;; provide data representations for ex1, ex2, and ex3
;; following your data definition.

; A Lam is one of
; - a Symbol
; - Lexpr
; - Application
(define-struct lexpr [para body])
; A Lexpr is a structure:
;   (make-lexpr Symbol Lam)
(define-struct lapp [fun arg])
; An Application is a structure:
;   (make-lapp Lam Lam)
; examples:
(define ex1
  (make-lexpr 'x 'x))
(define ex2
  (make-lexpr 'x 'y))
(define ex3
  (make-lexpr 'y (make-lexpr 'x 'y)))
(define ex4
  (make-lapp (make-lexpr 'x 'x)
            (make-lexpr 'x 'x)))
(define ex5
  (make-lapp (make-lexpr 'x (make-lapp 'x 'x))
            (make-lexpr 'x (make-lapp 'x 'x))))
(define ex6
  (make-lapp (make-lapp (make-lexpr 'y (make-lexpr 'x 'y))
                      (make-lexpr 'z 'z))
            (make-lexpr 'w 'w)))


;; ---------
;; ---------
;; ---------
;; ---------
;; ---------
;; ---------
;; ---------
;; --------- HELPERS:

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

(define (is-λ? expr) (lexpr? expr))
  

; Lam -> Boolean
; #true if expr is an application
(check-expect (is-app? 'x) #false)
(check-expect (is-app? ex1) #false)
(check-expect (is-app? ex4) #true)

(define (is-app? expr) (lapp? expr))

; Lexpr -> Symbol
; extracts the parameter from λ-expr
(check-expect (λ-para ex1) 'x)
(check-expect (λ-para ex2) 'x)
(check-expect (λ-para ex3) 'y)

(define (λ-para lexpr) (lexpr-para lexpr))

; λExpression -> Lam
; extracts the body from λ-expr
(check-expect (λ-body ex1) 'x)
(check-expect (λ-body ex2) 'y)
(check-expect (λ-body ex3) (lexpr-body ex3))

(define (λ-body lexpr) (lexpr-body lexpr))

; Application -> Lam
; extracts the function from an application
(check-expect (app-fun ex4) (lapp-fun ex4))
(check-expect (app-fun ex5) (lapp-fun ex5))

(define (app-fun app) (lapp-fun app))


; Application -> Lam
; extracts the argument from an application
(check-expect (app-arg ex4) (lapp-arg ex4))
(check-expect (app-arg ex5) (lapp-arg ex5))

(define (app-arg app) (lapp-arg app))

; Lam -> [List-of Symbol]
; computes all symbols used as parameters in λ-expr
(check-expect (declareds 'x) '())
(check-expect (declareds ex1) '(x))
(check-expect (declareds ex2) '(x))
(check-expect (declareds ex3) '(y x))
(check-expect (declareds ex4) '(x x))
(check-expect (declareds ex5) '(x x))

(define (declareds expr)
  (cond
    [(is-var? expr) '()]
    [(is-λ? expr) (cons (lexpr-para expr)
                        (declareds (lexpr-body expr)))]
    [(is-app? expr)
     (append (declareds (lapp-fun expr))
             (declareds (lapp-arg expr)))]))

; Lam -> Lam
; replaces all symbols s in le0 with '*undeclared:s
; if they do not occur within the body of a λ
; expression whose parameter is s
(check-expect (undeclareds ex1)
              (make-lexpr 'x '*declared:x))
(check-expect (undeclareds ex2)
              (make-lexpr 'x '*undeclared:y))
(check-expect (undeclareds ex3)
              (make-lexpr 'y
                          (make-lexpr 'x '*declared:y)))
(check-expect (undeclareds ex4)
              (make-lapp (make-lexpr 'x '*declared:x)
                         (make-lexpr 'x '*declared:x)))
(check-expect (undeclareds ex5)
              (make-lapp (make-lexpr 'x
                                     (make-lapp '*declared:x '*declared:x))
                         (make-lexpr 'x
                                     (make-lapp '*declared:x '*declared:x))))

(define (undeclareds le0)
  (local [; Symbol Symbol -> Symbol
          ; concatenates a and b
          (define (append-symbol a b)
            (string->symbol
             (string-append (symbol->string a)
                            (symbol->string b))))
          
          ; Lam [List-of Symbol] -> Lam
          ; accumulator declareds is a list of all λ
          ; parameters on the path from le0 to le
          (define (undeclareds/a le declareds)
            (cond
              [(is-var? le)
               (if (member? le declareds)
                   (append-symbol '*declared: le)
                   (append-symbol '*undeclared: le))]
              [(is-λ? le)
               (local [(define para (lexpr-para le))
                       (define body (lexpr-body le))
                       (define newd ;; ***
                         (cons para declareds))]
                 (make-lexpr para
                             (undeclareds/a body newd)))]
              [(is-app? le)
               (local [(define fun (lapp-fun le))
                       (define arg (lapp-arg le))]
                 (make-lapp
                  (undeclareds/a fun declareds)
                  (undeclareds/a arg declareds)))]))]
    (undeclareds/a le0 '())))  
  