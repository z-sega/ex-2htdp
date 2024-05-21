;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-323) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))

(define-struct no-info [])
(define NONE (make-no-info))

(define-struct node [ssn name left right])
; A BT (short for BinaryTree) is one of:
; - NONE
; - (make-node Number Symbol BT BT)
(define a (make-node 15 'd NONE (make-node 24
                                           'i
                                           NONE NONE)))
(define b (make-node 13 'd a (make-node 39
                                        'i
                                        NONE NONE)))

;; ex-323
;; Design search-bt. The function consumes a number n and a
;; BT. If the tree contains a node structure whose ssn field
;; is n, the function produces the values of the name field
;; in that node. Otherwise, the function produces #false.

; A [Maybe Symbol] is one of:
; - #false
; - Symbol

; BT Number -> [Maybe Symbol]
; returns the name of a node in bt where the ssn-field
; matches n or #false
(check-expect (search-bt NONE 39) #false)
(check-expect (search-bt a 39) #false)
(check-expect (search-bt b 39) 'i)

(define (search-bt bt n)
  (cond
    [(no-info? bt) #false]
    [else
     (local ((define left-search (search-bt (node-left bt) n))
             (define right-search (search-bt (node-right bt) n)))
       (if (equal? (node-ssn bt) n)
           (node-name bt)
           (or left-search
               right-search)))]))
