#lang htdp/isl+

;; ex-293 - INCOMPLETE
;; Develop found?, a specification for the find function,
;; then use found? to formulate a check-satisfied test for-all
;; find.

; Maybe X is one of:
; - #false, or
; - X

; [Maybe [List-of X]]
(define l1 '("a" "b" "c" "d"))
(define m1 #false)


; [X] X [List-of X] -> [Maybe [List-of X]]
; returns the first sublist of l that starts
; with x, #false otherwise

(check-satisfied (find "b" l1) (found-spec "b" l1))
(check-satisfied (find "c" l1) (found-spec "c" l1))
(check-satisfied (find "x" l1) (found-spec "x" l1))

(define (find x l)
  (cond
    [(empty? l) #false]
    [else (if (starts-with? x l)
              l
              (find x (rest l)))]))

; [X] X [List-of X] -> Boolean
; #t if l starts with x
(check-expect (starts-with? "a" l1) #true)
(check-expect (starts-with? "x" l1) #false)

(define (starts-with? x l)
  (equal? (first l) x))

; [X] X [List-of X] -> [[List-of X] -> Boolean]
(check-expect [(found-spec "b" '("a" "b" "c" "d"))
               '("b" "c" "d")]
              #true)
(check-expect [(found-spec "b" '("a" "b" "c" "d"))
               '("c" "d")]
              #false)
(check-expect [(found-spec "x" '("a" "b" "c" "d"))
               #false]
              #true)
(define (found-spec x l)
  (lambda (maybe-lt)
    (local (; X [List-of X] -> Boolean
            ; #t if maybe-lt is false
            ; AND x is not on l
            (define (not-found? x l)
              (and (false? maybe-lt)
                   (not (member? x l))))

            ; X [List-of X] -> Boolean
            ; #t if x is first on l
            (define (first-on-list? x l)
              (starts-with? x l))

            ; [List-of X] [List-of X] -> Boolean
            ; #t if a is a sublist of b
            ; TODO: 
            ; check *substring?*
            (define (is-sublist? a b) #true)) 
      (or (not-found? x l)
          (and (first-on-list? x maybe-lt)
               (is-sublist? maybe-lt l))))))

