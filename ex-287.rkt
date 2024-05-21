#lang htdp/isl+

;; Use filter to define eliminate-exp. The function consumes a number,
;; ua, and a list of inventory records (containing name and price),
;; and it produces a list of all those structures whose acquisition
;; price is below ua.

(define-struct IR [name sp])
; An IR is a structure:
;   (make-IR String Number)
; *interpretation*
; (make-IR "blueberry" 500.00)
; describes an inventory item which is a blueberry
; sold at 500.00
(define blueberry (make-IR "blueberry" 500.00))
(define soccerball (make-IR "soccerball" 49.99))
(define basketball (make-IR "basketball" 52.99))

; [List-of IR]
(define target-inventory
  (list blueberry
        soccerball
        basketball))

; Number [List-of IR] -> [List-of IR]
; produces a list of all those records that
; are cheaper than ua
(check-expect (eliminate-exp 100
                             target-inventory)
              (list soccerball basketball))
(define (eliminate-exp ua loir)
  (filter (lambda (ir) (< (IR-sp ir) ua))
          loir))

;; Then use filter to define recall, which consumes
;; the name of an inventory item, called ty, and a
;; list of inventory records and which produces a
;; list of inventory records that do not use the
;; name ty.

; String [List-of IR] -> [List-of IR]
; produces a list of records that do not use the
; name ty
(check-expect (recall "soccerball" target-inventory)
              (list blueberry basketball))
(check-expect (recall "blueberry" target-inventory)
              (list soccerball basketball))
(define (recall ty loir)
  (filter (lambda (ir) (not (string=? ty (IR-name ir))))
          loir))

;; In addition, define selection, which consumes two
;; lists of names and selects all those from the
;; second one that are also on the first.

; [List-of String] [List-of String] -> [List-of String]
; consumes a list A and a list B and produces a list
; containing all those elements in both lists.
(check-expect (selection (list "first-thing-in-both"
                               "just-in-a"
                               "second-thing-in-both")
                         (list "just-in-b"
                               "first-thing-in-both"
                               "second-thing-in-both"))
              (list "first-thing-in-both"
                    "second-thing-in-both"))
(define (selection los-a los-b)
  (filter (lambda (b) (member? b los-a))
          los-b))
