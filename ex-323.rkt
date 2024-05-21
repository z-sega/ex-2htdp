;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-323) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))

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

;; ex-323
;; Design search-bt. The function consumes a number n and a
;; BT. If the tree contains a node structure whose ssn field
;; is n, the function produces the values of the name field
;; in that node. Otherwise, the function produces #false.

(require 2htdp/abstraction)

; A [Maybe Symbol] is one of:
; - #false
; - Symbol

; BT Number -> [Maybe Symbol]
; returns the name of a node in bt where the ssn-field
; matches n or #false
(check-expect (search-bt NONE 39) #false)
(check-expect (search-bt a 39) #false)
(check-expect (search-bt b 39) 'd)

(define (search-bt bt n)
  (match bt
    [(? no-info?) #false]
    [(node ssn name left right)
     (local ((define left-result (search-bt left n))
             (define right-result (search-bt right n)))
       (cond
         [(equal? ssn n) name]
         [(symbol? left-result) left-result]
         [(symbol? right-result) right-result]
         [else #false]))]))

; BT Number -> [Maybe Symbol]
(check-expect (search-bt.v2 NONE 39) #false)
(check-expect (search-bt.v2 a 39) #false)
(check-expect (search-bt.v2 b 39) 'd)

(define (search-bt.v2 bt n)
  (match bt
    [(? no-info?) #false]
    [(node ssn name left right)
     (if (equal? ssn n)
         name
         (for/or ([sub-tree (list left right)])
           (search-bt.v2 sub-tree n)))]))
      

