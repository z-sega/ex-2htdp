;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-269) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-269
;; Define eliminate-expensive. The function consumes
;; a number, ua, and a list of inventory records, and
;; it produces a list of all those structures whose
;; sales price is below ua.

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
; are cheaper than us
(check-expect (eliminate-expensive 100
                                   target-inventory)
              (list soccerball basketball))
(define (eliminate-expensive us loir)
  (local (; IR -> Boolean
          ; #t if sale price of ir is less than
          ; us
          (define (is-cheap ir)
            (< (IR-sp ir) us)))
    (filter is-cheap loir)))

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
  (local (; IR -> Boolean
          ; #t if ir does not use the name ty
          (define (not-using-name ir)
            (not (string=? ty (IR-name ir)))))
    (filter not-using-name loir)))

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
  (local (; String -> Boolean
          ; #t if b is in los-a
          (define (also-in-los-a b)
            (member? b los-a)))
    (filter also-in-los-a los-b)))
