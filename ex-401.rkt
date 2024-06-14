;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-401) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-401
;; Design sexp=?, a function that determines whether
;; two S-expressions are equal. For convenience, here
;; is the data definition in condensed form:

; An S-expr (S-expression) is one of:
; - Atom
; - [List-of S-expr]
;
; An Atom is one of:
; - Number
; - String
; - Symbol
(define num 2)
(define str "2")
(define sym 'd)

(define expr-1 `(,sym ,str ,num))
(define expr-2 `(,sym ,expr-1 ,num))
(define expr-2-copy `(,sym ,expr-1 ,num))

; S-expr S-expr -> Boolean
; #true if the s-expressions a and b are equal
(check-expect (sexp=? num num) #true)
(check-expect (sexp=? num 4) #false)
(check-expect (sexp=? '() '()) #true)
(check-expect (sexp=? 3 '()) #false)
(check-expect (sexp=? '() 3) #false)
(check-expect (sexp=? expr-2 expr-2-copy) #true)
(check-expect (sexp=? expr-2 `(,sym ,expr-2-copy ,num))
              #false)
(check-expect (sexp=? '("a" a 10 (-1 "cat"))
                      '("a" a 10 '()))
              #false)

(define (sexp=? a b)
  (local (; S-expr -> Boolean
          ; #t if s is an atom
          (define (atom? s) (or (number? s)
                                (string? s)
                                (symbol? s)))
          
          ; [List-of S-expr] [List-of S-expr] -> Boolean
          ; #t if a* and b* are equal
          (define (sl-sexp=? a* b*)
            (local ((define size-a* (length a*))
                    (define size-b* (length b*)))
              (if (equal? size-a* size-b*)
                  (foldr (lambda (a b acc)
                     (and (sexp=? a b) acc)) #true a* b*)
                  #false))))
    (cond
      [(and (atom? a) (atom? b)) (equal? a b)]
      [(and (atom? a) (list? b)) #false]
      [(and (list? a) (atom? b)) #false]
      [(and (list? a) (list? b)) (sl-sexp=? a b)])))
