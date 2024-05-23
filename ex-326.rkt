;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-326) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
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

(define a1 (make-node 10 'a1 NONE NONE))
(define a3 (make-node 24 'a3 NONE NONE))
(define a2 (make-node 24 'a2 a1 a3))
(define a4t (make-node 29 'a4 a2 new)) ;; test
(define a4 (make-node 29 'a4 a2 NONE))
;; --
(define a6 (make-node 77 'a6 NONE NONE))
(define a9 (make-node 99 'a9 NONE NONE))
(define a8 (make-node 95 'a8 NONE a9))
(define a7 (make-node 89 'a7 a6 a8))
;; --
(define a5t (make-node 63 'a5 a4t a7))
(define a5 (make-node 63 'a5 a4 a7))

;; ex-326
;; Design the function create-bst. It consumes a BST B,
;; a number N, and a symbol S. It produces a BST that is just
;; like B and that in place of one NONE subtree contains
;; the node structure

; (make-node N S NONE NONE)

;; Once the design is completed, use the function on tree A
;; from figure 119.

(require 2htdp/abstraction)

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
