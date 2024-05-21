;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-320) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
; An Atom is one of:
; - Number
; - String
; - Symbol

; An S-expr is one of:
; - Atom
; - SL

; An SL is one of:
; - '()
; - (cons S-expr SL)


;; ex-320
;; Practice the step from data definition to function design
;; with two changes to the definition of S-expr.
;;
;; For the first step, reformulate the data definition of S-expr
;; so that the first clause of the first data definition is
;; expanded into the three clauses of Atom and the second
;; data definition uses the List-of abstraction. Redesign
;; the count function for this data definition.

; An S-expr is one of:
; - Number
; - String
; - Symbol
; - SL

; SL is a [List-of S-expr]

; S-expr Symbol -> N
; counts all occurences of sy in s
(check-expect (count.1 1 'hello) 0)
(check-expect (count.1 "hello" 'hello) 0)
(check-expect (count.1 'world 'hello) 0)
(check-expect (count.1 '(world hello) 'hello) 1)
(check-expect (count.1 '(((world) hello) hello) 'hello) 2)
(check-expect (count.1 '() 'hello) 0)

(define (count.1 s sy)
  (local (; S-expr -> N
          ; counts all occurences of sy in s
          (define (count-s s)
            (cond
              [(number? s) 0]
              [(string? s) 0]
              [(symbol? s) (if (symbol=? s sy) 1 0)]
              [else (count-sl s)]))
            
          ; SL -> N
          ; counts all occurences of sy in sl
          (define (count-sl sl)
            (cond
              [(empty? sl) 0]
              [else (foldr + 0 (map count-s sl))])))
    (count-s s)))


;; For the second step, integrate the data definition of
;; SL into the one for S-expr. Simplify the count again.
;; *Hint* Use lambda.

; An S-expr is one of:
; - Number
; - String
; - Symbol
; - [List-of S-expr]

; S-expr Symbol -> N
; counts all occurences of sy in s
(check-expect (count.2 1 'hello) 0)
(check-expect (count.2 "hello" 'hello) 0)
(check-expect (count.2 'world 'hello) 0)
(check-expect (count.2 '(world hello) 'hello) 1)
(check-expect (count.2 '(((world) hello) hello) 'hello) 2)
(check-expect (count.2 '() 'hello) 0)

(define (count.2 s sy)
  (cond
    [(number? s) 0]
    [(string? s) 0]
    [(symbol? s) (if (symbol=? s sy) 1 0)]
    [else (foldr +
                 0
                 (map (lambda (sl) (count.2 sl sy)) s))]))

