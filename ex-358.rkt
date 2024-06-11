;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-358) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
(require 2htdp/abstraction)

(define x 5)
(define y 3)

(define-struct add [left right])
(define-struct mul [left right])

(define INVALID-EXPR "Invalid expression: not numeric")
(define INVALID-FUNC "Invalid function: mismatched function name")

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


(define (k x0) x0)
(define (i x0) x0)

(define-struct fun-app [name arg])
; A fun-app (short for function application) is a structure:
;   (make-fun-app Symbol BSL-fun-expr)
; *intepretation*
; (make-fun-app f x) represents the application of a function
; f to x; equivalent to (f x)

; A BSL-fun-expr is one of:
; - Number
; - Symbol
; - (make-add BSL-fun-expr BSL-fun-expr)
; - (make-mul BSL-fun-expr BSL-fun-expr)
; - (make-fun-app Symbol BSL-fun-expr)
; ... (i.e include BSL-var-expr examples)
(define ex-fun1 (make-fun-app 'f 2))
(define ex-fun2 (make-fun-app 'g 2))

; A BSL-var-eval is a Number
; *interpretation*
; Is any value to which a representation of a BSL-var-expr
; can evaluate to.

; A BSL-fun-eval is a Number
; *interpretation*
; Is any value to which a representation of a BSL-fun-expr
; can evaluate to.

(define-struct fun-def [name param body])
; A fun-def (short for function definition) is a structure:
;   (make-fun-def Symbol Symbol BSL-fun-expr)
; *interpretation* (make-fun-def 'f-sqr 'x (* x x)) is
; equivalent to (define (f-sqr x) (* x x))

; A BSL-fun-def is a (make-fun-def Symbol Symbol BSL-var-expr)
(define f (make-fun-def 'f 'x (make-add 3 'x)))
(define g (make-fun-def 'g 'y (make-fun-app 'f (make-mul 2 'y))))
(define h (make-fun-def 'h 'v (make-add (make-fun-app 'f 'v)
                              (make-fun-app 'g 'v))))

; A BSL-fun-def* is one of:
; - '()
; - (cons BSL-fun-def BSL-fun-def*)
(define da-fgh (list f g h))

; BSL-fun-def* Symbol -> BSL-fun-def
; retrieves the definition of f in da
; signals an error if there is none
(check-expect (lookup-def da-fgh 'g) g)
(check-expect (lookup-def da-fgh 'h) h)
(check-expect (lookup-def da-fgh 'x) #false)

(define (lookup-def da f)
  (for/or ([f0 da])
    (if (symbol=? (fun-def-name f0) f) f0 #false)))

;; ex-359
;; Design eval-function*. The function consumes ex, a BSL-fun-expr,
;; and da, a BSL-fun-def* representation of a definitions area. It
;; produces the result that DrRacket shows if you evaluate ex in the
;; interactions area, assuming the definitions area contains da.
;;
;; The function works like eval-definition1 from ex-357. For an
;; application of some function f, it
;;
;; 1. evaluates the argument;
;; 2. looks up the definition of f in the BSL-fun-def representation
;; of da, which comes with a parameter and a body;
;; 3. substitutes the value of the argument for the function parameter
;; in the function's body; and
;; 4. evaluates the new expression via recursion.
;;
;; Like DrRacket, eval-function* signals an error when it encounters a
;; variable or a function name without definition in the definitions area.

; BSL-fun-expr BSL-fun-def* -> BSL-fun-eval
(check-expect (eval-function* ex-fun1 da-fgh) 5)
(check-expect (eval-function* ex-fun2 da-fgh) 7)

(define (eval-function* ex da)
  (match ex
    [(? number?) ex]
    [(? symbol?)]
    []
    []))

; An AL (short for association list) is [List-of Association]
; An Association is a list of two items:
;   (cons Symbol (cons Number '()))
(define assoc-x (list (list 'x x)))
(define assoc-xy (cons (list 'y y) assoc-x))

; BSL-func-expr Symbol Symbol BSL-fun-expr -> BSL-fun-eval
; computes the value if (numeric? ex) is #true,
; else ERROR.
(check-expect
 (eval-definition1 ex-fun1 (fun-app-name ex-fun1) 'x (fun-app-arg ex-fun1))
 2)
(check-expect
 (eval-definition1 (make-add 2 2) (fun-app-name ex-fun1) 'x (fun-app-arg ex-fun1))
 4)
(check-expect
 (eval-definition1 (make-mul 2 2) (fun-app-name ex-fun1) 'x (fun-app-arg ex-fun1))
 4)
(check-error
 (eval-definition1 'x (fun-app-name ex-fun1) 'x (fun-app-arg ex-fun1))
 INVALID-EXPR)

(define (eval-definition1 ex f x b)
  (match ex
    [(? number?) ex]
    [(? symbol?) (error INVALID-EXPR)]
    [(add l r) (+ (eval-definition1 l f x b)
                  (eval-definition1 r f x b))]
    [(mul l r) (* (eval-definition1 l f x b)
                  (eval-definition1 r f x b))]
    [(fun-app name arg) (local ((define value
                                  (eval-definition1 arg name x b))
                                (define plugd
                                  (subst b x value)))
                          (eval-definition1 plugd f x b))]))


; BSL-var-expr -> BSL-var-eval
; computes value if (numeric? var-ex) is #true,
; else ERROR.
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

;; BSL-var-expr AL -> BSL-var-eval
;; computes the value of ex using definitions
;; in da if (numeric? result) else ERROR
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


;; BSL-var-expr AL -> BSL-var-eval
;; computes the value of ex using definitions
;; in da if (numeric? result) else ERROR
(check-expect (eval-var-lookup ex-number assoc-xy) ex-number)
(check-expect (eval-var-lookup (make-add 5 3) assoc-xy) 8)
(check-expect (eval-var-lookup (make-mul 5 3) assoc-xy) 15)
(check-expect (eval-var-lookup (make-add (make-add 3 1) 3)
                              assoc-xy) 7)
(check-expect (eval-var-lookup (make-mul (make-mul 3 3) 3)
                              assoc-xy) 27)
(check-expect (eval-var-lookup ex-symbol assoc-xy) x)
(check-expect (eval-var-lookup ex-symbol assoc-x) x)
(check-expect (eval-var-lookup ex-add assoc-xy) (+ x 3))
(check-expect (eval-var-lookup ex-add assoc-x) (+ x 3))
(check-expect (eval-var-lookup ex-mul assoc-xy)
              (* 1/2 (* x 3)))
(check-expect (eval-var-lookup ex-mul assoc-x)
              (* 1/2 (* x 3)))
(check-expect (eval-var-lookup ex-add-nested assoc-xy)
              (+ (* x x)
                 (* y y)))
(check-error (eval-var-lookup ex-add-nested assoc-x)
              INVALID-EXPR)
(check-error (eval-var-lookup ex-symbol '()) INVALID-EXPR)
(check-error (eval-var-lookup ex-add '()) INVALID-EXPR)
(check-error (eval-var-lookup ex-mul '()) INVALID-EXPR)
(check-error (eval-var-lookup ex-add-nested '()) INVALID-EXPR)

(define (eval-var-lookup ex da)
  (local (; BSL-var-expr -> BSL-var-expr
          ; replaces symbols in ex from da
          (define (var-lookup ex)
            (match ex
              [(? number?) ex]
              [(? symbol?) (local ((define var (assq ex da)))
                             (if (cons? var)
                                 (second var)
                                 (error INVALID-EXPR)))]
              [(add l r) (make-add (var-lookup l)
                                   (var-lookup r))]
              [(mul l r) (make-mul (var-lookup l)
                                   (var-lookup r))])))
    (eval-variable (var-lookup ex))))
