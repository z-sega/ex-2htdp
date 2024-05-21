;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-325) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
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

;; ex-325
;; Design search-bst. The function consumes a number n and a BST.
;; If the tree contains a node whose ssn field is n, the function
;; produces the value of the name field in that node.
;; Otherwise, the function produces NONE. The function organization
;; must exploit the BST invariant so that the function performs
;; as few comparisons as necessary.

(require 2htdp/abstraction)

; [NoneUnless X] is one of:
; - NONE
; - X
; 
; [NoneUnless String]
; [NoneUnless Symbol]

; Number BST -> [NoneUnless Symbol]
; produces the value of the (node-name bt-i) if
; (node-ssn bt-i) is equal to n, else returns NONE
(check-expect (search-bst 39 NONE) NONE)
(check-expect (search-bst 399 f) NONE)
(check-expect (search-bst 39 f) 'e)
(check-expect (search-bst 62 f) 'i)

(define (search-bst n bt)
  (match bt
    [(? no-info?) NONE]
    [(node ssn0 name0 L R)
     (cond
       [(equal? ssn0 n) name0]
       [(< n ssn0) (search-bst n L)]
       [(> n ssn0) (search-bst n R)])]))

