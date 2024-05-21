;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname pattern-matching) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
(require 2htdp/abstraction)

;; Pattern Matching
;;
;; *Sample Problem*
;; Design the function last-item, which retrieves the last
;; item on a non-empty list.
;;
;; Recall that non-empty lists are defined as follows:

; A [NEList-of X] is one of:
; - (cons X '())
; - (cons X [NEList-of X])

;; Stop! Arbitrarily Large Data deals with the problem.
;; Look up the solution.

; [NEList-of X] -> X
; extracts the last item on xl
(check-expect (last-item.old '(a)) 'a)
(check-expect (last-item.old '(a b)) 'b)
(check-expect (last-item.old '(a b c)) 'c)
(check-error (last-item.old '()))

(define (last-item.old xl)
  (cond
    [(empty? (rest xl)) (first xl)]
    [else (last-item.old (rest xl))]))


;; With match, a designer can eliminate three selectors and
;; two predicates from the solution using cond:

; [NEList-of X] -> X
; retrieves the last item of ne-l
(check-expect (last-item '(a)) 'a)
(check-expect (last-item '(a b)) 'b)
(check-expect (last-item '(a b c)) 'c)
(check-error (last-item '()))

(define (last-item ne-l)
  (match ne-l
    [(cons lst '()) lst]
    [(cons fst rst) (last-item rst)]))

;; Instead of predicates and selectors, this solution
;; uses patterns that are just like those found in
;; the data definition. For each self-reference and
;; occurence of the set parameter in the data definition,
;; the patterns use program-level variables.
;; The bodies of the match clauses no longer extract the
;; relevant parts form the list with selectors but
;; simply refer to these names.
;; As before, the function recurs on the rest field of
;; the given cons because the data definition refers to
;; itself in this position. In the base case, the answer
;; is lst, the variable that stands for the last item
;; on the list.


;; Let's take a look at a second problem from Arbitrarily
;; Large Data:
;; 
;; *Sample Problem*
;; Design the function depth, which measures the number of
;; layers surrounding a Russian doll.
;;
;; Here is the data definition again:

(define DOLL "doll")
(define-struct layer [color doll])
; An RD.v2 (short for Russian doll) is one of:
; - DOLL
; - (make-layer String RD.v2)

;; Here is a definition of depth using match:

; RD.v2 -> N
; how many dolls are part of an-rd
(check-expect (depth (make-layer "red" DOLL)) 1)
(check-expect (depth
               (make-layer "yellow" (make-layer "red" DOLL)))
               2)

(define (depth a-doll)
  (match a-doll
    ["doll" 0]
    [(layer c inside) (+ (depth inside) 1)]))

;; While the pattern in the first match clause looks for
;; "doll", the second one matches any layer structure,
;; associating c with the value in the color field and
;; inside with the value in the doll field. 
;; In short, match again again makes the function definition
;; concise.

;; The final problem is an excerpt from the generalized
;; UFO game:
;; *Sample Problem*
;; Design the move-right function. It consumes a list of
;; Posns, which represent the positions of objects on a
;; canvas, plus a number. The function adds the latter
;; to each x-coordinate, which represents a rightward
;; movement of these objects.
;; 
;; Here is the solution, using the full power of ISL+:

; [List-of Posn] -> [List-of Posn]
; moves each object right by delta-x pixels

(define input `(,(make-posn 1 1) ,(make-posn 10 14)))
(define result `(,(make-posn 4 1) ,(make-posn 13 14)))

(check-expect (move-right input 3) result)

(define (move-right lop delta-x)
  (for/list [(p lop)]
    (match p
      [(posn x y) (make-posn (+ x delta-x) y)])))

;; Stop! Did you notice that we use define to formulate
;; the tests? If you give data examples good names with
;; define and write down next to them what a function
;; produces as the expected result, you can read the code
;; later much more easily than if you had just written
;; down the constants.

;; Stop! How does a solution with cond and selectors compare?
;; Write it out and compare the two.

; [List-of Posn] -> [List-of Posn]
; moves each object right by delta-x pixels
(check-expect (move-right.old input 3) result)

(define (move-right.old lop delta-x)
  (cond
    [(empty? lop) '()]
    [else (cons (make-posn (+ (posn-x (first lop)) delta-x)
                           (posn-y (first lop)))
                (move-right.old (rest lop) delta-x))]))

;; Which one do you like better?

; -> The solution with cond and selectors is much harder
; to read in comparison. Pattern matching removes the need
; for selectors and makes the function body more readable
; (i.e the intention of the programmer/writer is clearer)
