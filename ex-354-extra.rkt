#lang htdp/isl+

(require 2htdp/abstraction)

(define x 5)
(define y 3)

(define-struct add [left right])
(define-struct mul [left right])

; A BSL-expr is one of:
; - Number
; - (make-add BSL-expr BSL-expr)
; - (make-mul BSL-expr BSL-expr)

; A BSL-var-expr is one of:
; - Number
; - Symbol
; - (make-add BSL-var-expr BSL-var-expr)
; - (make-mul BSL-var-expr BSL-var-expr)
(define ex-number 3)
(define ex-symbol 'x)
(define ex-add (make-add 'x 3))
(define ex-mul (make-mul 1/2 (make-mul 'x 3)))
(define ex-add-nested (make-add (make-mul 'x 'x)
                                (make-mul 'y 'y)))

; A BSL-var-eval is a Number
; *interpretation*
; Is any value to which a representation of a BSL-expr
; can evaluate to.

; An AL (short for association list) is [List-of Association]
; An Association is a list of two items:
;   (cons Symbol (cons Number '()))
(define assoc-x (list (list 'x x)))
(define assoc-xy (cons (list 'y y) assoc-x))

(define INVALID-EXPR "Invalid expression: not numeric")

;; BSL-var-expr -> BSL-var-eval
;; computes value if (numeric? var-ex) is #true,
;; else ERROR.
(check-expect (eval-variable ex-number) ex-number)
(check-expect (eval-variable (make-add 5 3)) 8)
(check-expect (eval-variable (make-mul 5 3)) 15)
(check-expect (eval-variable (make-add (make-add 3 1) 3)) 7)
(check-expect (eval-variable (make-mul (make-mul 3 3) 3)) 27)
(check-error (eval-variable ex-symbol) INVALID-EXPR)
(check-error (eval-variable ex-add) INVALID-EXPR)
(check-error (eval-variable ex-mul) INVALID-EXPR)
(check-error (eval-variable ex-add-nested) INVALID-EXPR)

(define (eval-variable var-ex)
  (local (; BSL-expr -> BSL-var-eval
          ; computes the value of var-ex
          (define (eval-expr ex)
            (match ex
              [(? number?) ex]
              [(add l r) (+ (eval-expr l) (eval-expr r))]
              [(mul l r) (* (eval-expr l) (eval-expr r))])))
    (if (numeric? var-ex)
        (eval-expr var-ex)
        (error INVALID-EXPR))))

;; BSL-var-expr -> Boolean
;; #t if ex is a BSL-expr
(check-expect (numeric? ex-number) #true)
(check-expect (numeric? ex-symbol) #false)
(check-expect (numeric? ex-add) #false)
(check-expect (numeric? (make-add 5 3)) #true)
(check-expect (numeric? ex-mul) #false)
(check-expect (numeric? ex-add-nested) #false)

(define (numeric? ex)
  (match ex
    [(? number?) #true]
    [(? symbol?) #false]
    [(add l r) (and (numeric? l) (numeric? r))]
    [(mul l r) (and (numeric? l) (numeric? r))]))

;; BSL-var-expr -> BSL-expr
;; replaces all occurences of symbol x
;; in ex with v
(check-expect (subst ex-number 'x x) ex-number)
(check-expect (subst ex-symbol 'x x) 5)
(check-expect (subst ex-add 'x x) (make-add x 3))
(check-expect (subst ex-mul 'x x) (make-mul 1/2
                                            (make-mul x 3)))
(check-expect (subst ex-add-nested 'x x) (make-add (make-mul x x)
                                                   (make-mul 'y 'y)))

(define (subst ex x v)
  (match ex
    [(? number?) ex]
    [(? symbol?) (if (symbol=? ex x) v ex)]
    [(add l r) (make-add (subst l x v)
                         (subst r x v))]
    [(mul l r) (make-mul (subst l x v)
                         (subst r x v))]))

;; Design eval-variable*. The function consumes a BSL-var-expr ex
;; and an association list da. Starting from ex, it iteratively
;; applies subst to all associations in da. If numeric? holds
;; for the result, it determines its value; otherwise it
;; signals the same error as eval-variable.
;; *Hint*
;; Think of the given BSL-var-expr as an atomic value and traverse
;; the given association list instead. We provide this hint
;; because the creation of this function requires a little design
;; knowledge from Simultaneous Processing.

;; BSL-var-expr AL -> BSL-var-eval
;; computes value if (numeric? var-ex) is #true,
;; else ERROR.
(check-expect (eval-variable* ex-number assoc-xy) ex-number)
(check-expect (eval-variable* (make-add 5 3) assoc-xy) 8)
(check-expect (eval-variable* (make-mul 5 3) assoc-xy) 15)
(check-expect (eval-variable* (make-add (make-add 3 1) 3)
                              assoc-xy) 7)
(check-expect (eval-variable* (make-mul (make-mul 3 3) 3)
                              assoc-xy) 27)
(check-expect (eval-variable* ex-symbol assoc-xy) x)
(check-expect (eval-variable* ex-symbol assoc-x) x)
(check-expect (eval-variable* ex-add assoc-xy) (+ x 3))
(check-expect (eval-variable* ex-add assoc-x) (+ x 3))
(check-expect (eval-variable* ex-mul assoc-xy)
              (* 1/2 (* x 3)))
(check-expect (eval-variable* ex-mul assoc-x)
              (* 1/2 (* x 3)))
(check-expect (eval-variable* ex-add-nested assoc-xy)
              (+ (* x x)
                 (* y y)))
(check-error (eval-variable* ex-add-nested assoc-x)
              INVALID-EXPR)
(check-error (eval-variable* ex-symbol '()) INVALID-EXPR)
(check-error (eval-variable* ex-add '()) INVALID-EXPR)
(check-error (eval-variable* ex-mul '()) INVALID-EXPR)
(check-error (eval-variable* ex-add-nested '()) INVALID-EXPR)

(define (eval-variable* ex da)
  (cond
    [(empty? da) (eval-variable ex)]
    [else (eval-variable*
           (subst ex (first (first da)) (second (first da)))
           (rest da))]))
