;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-322) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))

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

;; ex-322
;; Draw the above two trees in the manner of figure 119.
;; Then design contains-bt?, which determines whether a given
;; number occurs in some given BT.


; BT Number -> Boolean
; #t if n is in any ssn-field in bt
(check-expect (contains-bt? NONE 39) #f)
(check-expect (contains-bt? a 39) #f)
(check-expect (contains-bt? b 39) #t)

(define (contains-bt? bt n)
  (cond
    [(no-info? bt) #f]
    [else (or (equal? (node-ssn bt) n)
              (contains-bt? (node-left bt) n)
              (contains-bt? (node-right bt) n))]))
