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

;; ex-357
;; Design eval-definition1. The function consumes four arguments:
;; 1. a BSL-fun-expr ex;
;; 2. a symbol f, which represents a function name;
;; 3. a symbol x, which represents the functions' parameter; and
;; 4. a BSL-fun-expr b, which represents the function's body.
;;
;; It determines the value of ex. When eval-definition1 encounters
;; an application of f to some argument, it
;; 1. evaluates the argument,
;; 2. substitutes the value of the argument for x in b; and
;; 3. finally evaluates the resulting expression with
;;    eval-definition1.
;;
;; Here is how to express the steps as code, assuming arg is the
;; argument of the function application:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (local ((define value (eval-definition1 arg f x b)) ;;
;;         (define plugd (subst b x value)))           ;;
;;   (eval-definition1 plugd f x b))                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Notice that this line uses a form of recursion that has not
;; been covered. The proper design of such functions is
;; discussed in Generative Recursion.
;;
;; If eval-definition1 encounters a variable, it signals the
;; same error as eval-variable from ex-354. It also signals an error
;; for function applications that refer to a function name other
;; than f.
;;
;; *Warning*
;; The use of this uncovered form of recursion introduces a new
;; element into your computations: non-termination. That is, a
;; program may run forever instead of delivering a result or
;; signaling an error. If you followed the design recipes for the
;; first four parts, you cannot write down such programs.
;; For fun, construct an input for eval-definition1 that causes
;; it to run forever. Use STOP to terminate the program.

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
(define ex-fun1 (make-fun-app 'k (make-add 1 1)))
(define ex-fun2 (make-mul 5 ex-fun1))
(define ex-fun3 (make-mul (make-fun-app 'i 5)
                          ex-fun1))

; A BSL-var-eval is a Number
; *interpretation*
; Is any value to which a representation of a BSL-var-expr
; can evaluate to.

; A BSL-fun-eval is a Number
; *interpretation*
; Is any value to which a representation of a BSL-fun-expr
; can evaluate to.

; An AL (short for association list) is [List-of Association]
; An Association is a list of two items:
;   (cons Symbol (cons Number '()))
(define assoc-x (list (list 'x x)))
(define assoc-xy (cons (list 'y y) assoc-x))

(define INVALID-EXPR "Invalid expression: not numeric")
(define INVALID-FUNC "Invalid function: mismatched function name")

; BSL-func-expr Symbol Symbol BSL-fun-expr -> BSL-fun-eval
; computes the value if (numeric? ex) is #true,
; else ERROR.
(check-expect
 (eval-definition1 ex-fun1 (fun-app-name ex-fun1) 'x (fun-app-arg ex-fun1))
 2)
(check-expect
 (eval-definition1 ex-fun2 (fun-app-name ex-fun1) 'x (fun-app-arg ex-fun1))
 10)

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
