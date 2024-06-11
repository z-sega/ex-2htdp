;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-369) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
; An Xexpr.v0 is a one-item list:
;   (cons Symbol '())

; An Xexpr.v1 is a list:
;   (cons Symbol [List-of Xexpr.v1])

; An Xexpr.v2 is a list:
; - (cons Symbol Body)
; - (cons Symbol (cons [List-of Attribute] Body))
; where Body is short for [List-of Xexpr.v2]
; An Attribute is a list of two items:
;   (cons Symbol (cons String '()))

(define a0 '((initial "X")))
(define e0 '(machine))
(define e1 `(machine ,a0))
(define e2 '(machine (action)))
(define e3 '(machine () (action)))
(define e4 `(machine ,a0 (action) (action)))
(define e6 '(player))
(define e7 `(action ,e6))

; Xexpr.v2 -> [List-of Attribute]
; retrieves the list of attributes of xe
(check-expect (xexpr-attr e0) '())
(check-expect (xexpr-attr e1) a0)
(check-expect (xexpr-attr e2) '())
(check-expect (xexpr-attr e3) '())
(check-expect (xexpr-attr e4) a0)

(define (xexpr-attr xe)
  (local ((define optional-loa+content (rest xe)))
    (cond
      [(empty? optional-loa+content) '()]
      [else
       (local ((define loa-or-x (first optional-loa+content)))
         (if (list-of-attributes? loa-or-x) loa-or-x '()))])))

; AttrOrXexpr.v2 is one of:
; - [List-of Attribute]
; - Xexpr.v2

; AttrOrXexpr.v2 -> Boolean
; determines whether x is an element of [List-of Attribute]
; #false otherwise
(define (list-of-attributes? x)
  (cond
    [(empty? x) #true]
    [else (local ((define possible-attribute (first x)))
            (cons? possible-attribute))]))

; X-expr.v2 -> Symbol
; retrieves the name of xe
(check-expect (xexpr-name e0) 'machine)
(check-expect (xexpr-name e1) 'machine)
(check-expect (xexpr-name e2) 'machine)
(check-expect (xexpr-name e6) 'player)
(check-expect (xexpr-name e7) 'action)

(define (xexpr-name xe) (first xe))
  
; X-expr.v2 -> [List-of X-expr.v2]
; retrieves the body of xe

(check-expect (xexpr-content e0) '())
(check-expect (xexpr-content e1) '())
(check-expect (xexpr-content e2) '(action))
(check-expect (xexpr-content e4) '((action) (action)))

(define (xexpr-content xe)
  (local ((define optional-loa+content (rest xe)))
    (cond
      [(empty? optional-loa+content) '()]
      [else
       (local ((define loa-or-content (first optional-loa+content)))
         (if (list-of-attributes? loa-or-content)
             (rest optional-loa+content)
             loa-or-content))])))


;; ex-369
;; Design find-attr. The function consumes a list of attributes
;; and a symbol. If the attributes list associates the symbol with
;; a string, the function retrieves this string; otherwise it
;; returns #false. Look up assq and use it to define the function.

(require 2htdp/abstraction)

; A [Maybe X] is one of:
; - #false
; - X
; e.g
; [Maybe String]

(define a1 '((initial "red") (next "blue") (turn "Jimmy")))

; [List-of Attribute] Symbol -> [Maybe String]
(check-expect (find-attr '() 'next) #false)
(check-expect (find-attr a1 'next) "blue")
(check-expect (find-attr a1 'turn) "Jimmy")
(check-expect (find-attr a1 'help) #false)

(define (find-attr attr* sy)
  (local ((define found-attr (assq sy attr*)))
    (if (cons? found-attr) (second found-attr) #false)))
