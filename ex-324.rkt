;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-324) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))

(define-struct no-info [])
(define NONE (make-no-info))

(define-struct node [ssn name left right])
; A BT (short for BinaryTree) is one of:
; - NONE
; - (make-node Number Symbol BT BT)
(define a (make-node 15 'a NONE (make-node 24
                                           'c
                                           NONE NONE)))
(define b (make-node 13 'b a (make-node 39
                                        'd
                                        NONE NONE)))


;; ex-324
;; Design the function inorder. It consumes a binary
;; tree and produces the sequence of all the ssn
;; numbers in the tree as they show up from left to
;; right when looking at a tree drawing.
;;
;; *Hint* Use append, which concatenates lists like
;; thus:
;; (append (list 1 2 3) (list 4) (list 5 6 7))
;; ==
;; (list 1 2 3 4 5 6 7)

(require 2htdp/abstraction)

; BT -> [List-of Number]
; produces the sequence of all the ssn on
; bt from left to right
(check-expect (inorder NONE) '())
(check-expect (inorder a) (list 15 24))
(check-expect (inorder b) (list 15 24 13 39))

(define (inorder bt)
  (match bt
    [(? no-info?) '()]
    [(node ssn name left right)
     (append (inorder left)
             (list ssn)
             (inorder right))]))
