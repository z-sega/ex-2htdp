;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-327) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
(define-struct no-info [])
(define NONE (make-no-info))

(define-struct node [ssn name left right])
; A BT (short for BinaryTree) is one of:
; - NONE
; - (make-node Number Symbol BT BT)
(define bt-a (make-node 15 'a NONE (make-node 24
                                           'c
                                           NONE NONE)))
(define bt-b (make-node 13 'b bt-a (make-node 39
                                        'd
                                        NONE NONE)))

; A BST (short for binary search tree) is a BT
; according to the following conditions:
; - NONE is always a BST
; - (make-node ssn0 name0 L R) is a BST if
;   - L is a BST,
;   - R is a BST,
;   - all ssn fields in L are smaller than ssn0,
;   - all ssn fields in R are larger than ssn0.
(define a (make-node 2 'a NONE NONE))
(define c (make-node 6 'c NONE NONE))
(define e0 (make-node 39 'e NONE NONE))
(define g (make-node 51 'g NONE NONE))
(define i (make-node 62 'i NONE NONE))
(define b (make-node 5 'b a c))
(define d (make-node 13 'd b e0))
(define h (make-node 60 'h g i))
(define f (make-node 50 'f d h))

(define new (make-node 52 'j NONE NONE))
(define gt (make-node 51 'g NONE new))
(define ht (make-node 60 'h gt i))
(define ft (make-node 50 'f d ht))

(define a1 (make-node 10 'h NONE NONE))
(define a3 (make-node 24 'i NONE NONE))
(define a2 (make-node 15 'd a1 a3))
(define a4t (make-node 29 'b a2 new)) ;; test
(define a4 (make-node 29 'b a2 NONE))
;; --
(define a6 (make-node 77 'l NONE NONE))
(define a9 (make-node 99 'o NONE NONE))
(define a8 (make-node 95 'g NONE a9))
(define a7 (make-node 89 'c a6 a8))
;; --
(define a5t (make-node 63 'a a4t a7))
(define a5 (make-node 63 'a a4 a7))


;; ex-327
;; Design the function create-bst-from-list. It consumes a
;; list of numbers and names and produces a BST by repeatedly
;; applying create-bst.
;; Here is the signature:

;; [List-of [List Number Symbol]] -> BST
;; Use the complete function to create a BST from this
;; sample input:
(define input '((99 o)
                (77 l)
                (24 i)
                (10 h)
                (95 g)
                (15 d)
                (89 c)
                (29 b)
                (63 a)))

(require 2htdp/abstraction)

; [List-of [List Number Symbol]] -> BST
; produces a BST from l
(check-expect (create-bst-from-list input) a5)

(define (create-bst-from-list l)
  (foldr (lambda (ns-tuple acc)
           (create-bst acc
                       (first ns-tuple)
                       (second ns-tuple))) NONE l))

  
; BST Number Symbol -> BST
; insert (make-node N S NONE NONE) into B
(check-expect (create-bst NONE 52 'j) new)
(check-expect (create-bst f 52 'j) ft)
(check-expect (create-bst a5 52 'j) a5t)

(define (create-bst b n s)
  (match b
    [(? no-info?) (make-node n s NONE NONE)]
    [(node ssn0 name0 L R)
     (make-node ssn0
                name0
                (if (< n ssn0) (create-bst L n s) L)
                (if (> n ssn0) (create-bst R n s) R))]))

;; The result is tree A in fig-119 (a5), if you follow the
;; structural design recipe. If you use an existing abstraction,
;; you may still get this tree but you may also get an
;; "inverted" one. Why?
;;
;; This is dependent on the abstraction; foldr will
;; compute a BST as you expect, but foldl will compute
;; an inverted BST. This happends because of the way
;; these abstractions process their given lists.
;; foldr processing it from left to right, and foldl
;; processes it right to left (in reverse).
;; 
;; The effect is superficially and does not break the
;; BST invariant.
