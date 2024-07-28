;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-515) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

; A Lam is one of:
; - a Symbol
; - (list 'λ (list Symbol) Lam)
; - (list Lam Lam)
(define ex1 '(λ (x) x))
(define ex2 '(λ (x) y))
(define ex3 '(λ (y) (λ (x) y)))
(define ex4 '((λ (x) (x x)) (λ (x) (x x))))
(define ex5 '(((λ (y) (λ (x) y)) (λ (z) z)) (λ (w) w)))

; Lam -> Lam
; replaces all symbols s in le with '*undeclared
; if they do not occur within the body of a λ
; expression whose parameter is s

#|
(check-expect (undeclareds ex1) ex1)
(check-expect (undeclareds ex2) '(λ (x) *undeclared))
(check-expect (undeclareds ex3) ex3)
(check-expect (undeclareds ex4) ex4)
|#

#;(define (undeclareds le0) le0)

;; A close look at the purpose statement directly suggests
;; that the function needs an accumulator. When undeclareds
;; recurs on the body of (the representation of) a λ
;; expression, it forgets (λ-para le), the declared variable

#;(define (undeclareds le0)
  (local [; Lam ??? -> Lam
          ; accumulator a represents ...
          (define (undeclareds/a le a)
            (cond
              [(is-var? le) ...]
              [(is-λ? le)
               (... (undeclareds/a (app-fun le)) ...)]
              [(is-app? le)
               (... (undeclareds/a (app-fun le)
                                   ... a ...)
                    (undeclareds/a (app-arg le)
                                   ... a ...) ...)]))]
    (undeclareds/a le0 ...)))

;; We can now formulate an accumulator invariant:
;; a represents the list of λ parameters encountered on
;; the path from the top of le0 to the top of le.
;; 
;; For example, if le0 is
;;   '(((λ (y) (λ (x) y)) (λ (z) z)) (λ (w) w))
;;             ---------
;; and le is the underlined subtree, then a contains 'y.
;;
;;   '(((λ (y) (λ (x) y)) (λ (z) z)) (λ (w) w))
;;                    -
;; Similarly if le is this highlighted subtree of the same
;; piece of data, then the accumulator contains both 'y and
;; 'x.

#;(define (undeclareds le0)
  (local [; Lam ??? -> Lam
          ; accumulator a represents ...
          (define (undeclareds/a le a)
            (cond
              [(is-var? le) ...]
              [(is-λ? le)
               (... (undeclareds/a (app-fun le)) ...)]
              [(is-app? le)
               (... (undeclareds/a (app-fun le)
                                   ... a ...)
                    (undeclareds/a (app-arg le)
                                   ... a ...) ...)]))]
    (undeclareds/a le0 ...)))

;; We can resolve the remaining design questions, since we
;; have settled on the data representation of the
;; accumulator and its invariant.
;; - we pick an initial accumulator value of '().
;; - we use cons to add (λ-para le) to a.
;; - we exploit the accumulator for the clause where
;;   undeclareds/a deals with a variable. Specifically,
;;   the function uses the accumulator to check whether
;;   the variable is in the scope of a declaration.

#;(define (undeclareds le0)
  (local [; Lam [List-of Symbol] -> Lam
          ; accumulator declareds is a list of all λ
          ; parameters on the path from le0 to le
          (define (undeclareds/a le declareds)
            (cond
              [(is-var? le)
               (if (member? le declareds)
                   le
                   '*undeclared)]
              [(is-λ? le)
               (local [(define para (λ-para le))
                       (define body (λ-body le))
                       (define newd ;; ***
                         (cons para declareds))]
                 (list 'λ
                       (list para)
                       (undeclareds/a body newd)))]
              [(is-app? le)
               (local [(define fun (app-fun le))
                       (define arg (app-arg le))]
                 (list (undeclareds/a fun declareds)
                       (undeclareds/a arg declareds)))]))]
    (undeclareds/a le0 '())))

;; Note:
;; the name declareds for the accumulator; it brings
;; across the key idea behind the accumulator invariant,
;; helping the programmer understand the definition.
;;
;; the base cases uses member? from ISL+ to determine
;; whether the variable le is in declareds and, if not,
;; replaces it with '*undeclared.
;;
;; the second cond clause uses a local to introduce the
;; extended accumulator newd (new-declareds), because para
;; is also used to rebuild the expression, it has its
;; own local definition.

;; ex-515
;; Consider the following expression:

(define test '(λ (*undeclared) ((λ (x) (x *undeclared)) y)))

;; Yes, it uses *undeclared as a variable. Represent it
;; in Lam and check what undeclareds produces for this
;; expression

;; (undeclareds test)
;; ->
;; Ambiguous: '(λ (*undeclared) ((λ (x) (x *undeclared)) *undeclared))
;; Unambigious: '(λ (*undeclared) ((λ (x) (*declared:x *declared:*undeclared)) *undeclared:y))

;; Modify undeclareds so that it replaces a free occurence
;; of 'x with (list '*undeclared 'x) and a bound one 'y
;; with (list '*declared 'y)
;;
;; Doing so unambiguously identifies problem spots, which
;; a program development environment such as DrRacket
;; can use to highlight errors.
;;
;; Note:
;; The trick of replacing a variable occurence with the
;; representation of an application feels awkward. If
;; you dislike it, consider synthesizing the symbols
;; '*undeclared:x and 'declared:y instead

(check-expect (undeclareds ex1)
              '(λ (x) *declared:x))
(check-expect (undeclareds ex2)
              '(λ (x) *undeclared:y))
(check-expect (undeclareds ex3)
              '(λ (y) (λ (x) *declared:y)))
(check-expect (undeclareds ex4)
              '((λ (x) (*declared:x *declared:x))
                (λ (x) (*declared:x *declared:x))))

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
               (local [(define para (λ-para le))
                       (define body (λ-body le))
                       (define newd ;; ***
                         (cons para declareds))]
                 (list 'λ
                       (list para)
                       (undeclareds/a body newd)))]
              [(is-app? le)
               (local [(define fun (app-fun le))
                       (define arg (app-arg le))]
                 (list (undeclareds/a fun declareds)
                       (undeclareds/a arg declareds)))]))]
    (undeclareds/a le0 '())))

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
  
  