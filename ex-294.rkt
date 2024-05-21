#lang htdp/isl+

;; ex-294
;; Develop is-index?, a specification for index:
;; Use is-index? to formulate a check-satisfied test for index.

; [Maybe X] is one of:
; - #false, or
; - X

; [X] X [List-of X] -> [Maybe N]
; determine the index of the first occurence of
; x in l, #false otherwise
(check-expect (index 10 '()) #false)
(check-expect (index 10 '(1 2 3)) #false)
(check-expect (index 10 '(10 20 30)) 0)
(check-expect (index 10 '(20 10 10)) 1)
(check-expect (index 10 '(20 30 10)) 2)
(check-satisfied (index 10 '()) (is-index? 10 '()))
(check-satisfied (index 10 '(1 2 3)) (is-index? 10 '(1 2 3)))
(check-satisfied (index 10 '(10 20 30)) (is-index? 10 '(10 20 30)))
(check-satisfied (index 10 '(20 30 10)) (is-index? 10 '(20 30 10)))
; tests from Y.E above; helped me catch some issues

(check-satisfied (index "a" '("b" "a" "d"))
                 (is-index? "a" '("b" "a" "d")))
(check-satisfied (index "a" '("b" "a" "a" "d"))
                 (is-index? "a" '("b" "a" "a" "d")))

(define (index x l)
  (cond
    [(empty? l) #false]
    [else (if (equal? (first l) x)
              0
              (local ((define i (index x (rest l))))
                (if (boolean? i)
                    i
                    (+ i 1))))]))

; [X] X [List-of X] -> [N -> Boolean]
; computes specification for index that is:
; #t if x is on l
; AND l is large enough to have index mn
; AND mn is the first index of x on l
(check-expect [(is-index? "a" '("b" "a" "d")) 1] #true)
(check-expect [(is-index? "a" '("b" "a" "a" "d")) 1] #true)
(check-expect [(is-index? "a" '("b" "a" "a" "d")) 2] #false)

(define (is-index? x l)
  (lambda (mn)
    (local (; X [List-of X] -> Boolean
            ; #t if maybe-lt is false
            ; AND x is not on l
            (define (not-found? x l)
              (and (false? mn)
                   (not (member? x l))))

            ; N [List-of X] -> Boolean
            ; #t if l is atleast large enough
            ; to have index i
            (define (large-enough? i)
              (>= (add1 (length l)) i))

            ; N X [List-of X] -> Boolean
            ; #t if from index 0 to (sub1 mn)
            ; no other element is x
            (define (is-index-of-first-occurence? i current)
              (cond
                [(>= current i) #true]
                [else (and (not (equal? (list-ref l current) x))
                           (is-index-of-first-occurence? i (add1 current)))])))
      (or (not-found? x l)
          (and (member? x l)
               (large-enough? mn)
               (is-index-of-first-occurence? mn 0))))))

