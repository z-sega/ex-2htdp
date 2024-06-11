;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-376) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/abstraction)

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
(define e1 `(machine ,a0))
(define e2 '(machine (action)))
(define e3 '(machine () (action)))
(define e4 `(machine ,a0 (action) (action)))
(define e6 '(player))
(define e7 `(action ,e6))

; An XWord is '(word ((text String))).
(define w0 '(word ((text "Zero"))))
(define w1 '(word ((text "One"))))
(define w2 '(word ((text "Two"))))

;; Given the representation of words, representing an XHTML-style
;; enumeration of words is straightforward:

; An XEnum.v2 is one of:
; - (cons 'ul [List-of XItem.v2])
; - (cons 'ul (cons Attributes [List-of XItem.v2]))
;
; An XItem.v2 is one of:
; - (cons 'li (cons XWord '()))
; - (cons 'li (cons Attributes (cons XWord '())))
; - (cons 'li (cons XEnum.v2 '()))
; - (cons 'li (cons Attributes (cons XEnum.v2 '())))
;
; where Attributes is a [List-of Attribute]
(define word-one '(word ((text "one"))))
(define word-two '(word ((text "two"))))
(define l-one `(li ,word-one))
(define l-two `(li ,word-two))
(define e0 `(ul ,l-one ,l-two))

;; ex-376
;; Design a program that counts all "hello"s in an instance
;; of XEnum.v2

(define word-hello '(word ((text "hello"))))
(define word-bike '(word ((text "bike"))))
(define word-smart '(word ((text "smart"))))
(define word-bye '(word ((text "bye"))))

(define item-nested-hello `(li (ul (li ,word-bike)
                      (li ,word-hello)
                      (li ,word-bye))))
(define item-hello `(li ,word-hello))
(define item-bye `(li ,word-bye))

(define enum-hello-none `(ul ,item-bye))
(define enum-hello-two `(ul ,item-nested-hello ,item-hello))

; XEnum.v2 -> N
; counts all "hello"s in ex-enum
(check-expect (enum-count-hello enum-hello-none) 0)
(check-expect (enum-count-hello enum-hello-two) 2)

(define (enum-count-hello ex-enum)
  (for/sum ([item (xexpr-content ex-enum)]) (item-count-hello item)))

; XItem.v2 -> N
; counts all "hello"s in ex-item
(check-expect (item-count-hello item-bye) 0)
(check-expect (item-count-hello item-hello) 1)
(check-expect (item-count-hello item-nested-hello) 1)

(define (item-count-hello ex-item)
  (local ((define content (first (xexpr-content ex-item))))
    (cond
      [(word? content) (if (equal? (word-text content) "hello") 1 0)]
      [else (enum-count-hello content)])))




; XWord -> String
; retrieves the text attribute of xword
(check-expect (word-text w0) "Zero")
(check-expect (word-text w1) "One")
(check-expect (word-text w2) "Two")

(define (word-text ex)
  (match ex
    [(list 'word (list (list 'text txt))) txt]))


; X-expr.v2 -> [List-of X-expr.v2]
; retrieves the body of xe

(check-expect (xexpr-content e1) '())
(check-expect (xexpr-content e2) '((action)))
(check-expect (xexpr-content e3) '((action)))
(check-expect (xexpr-content e4) '((action) (action)))

(define (xexpr-content xe)
  (local ((define optional-loa+content (rest xe)))
    (cond
      [(empty? optional-loa+content) '()]
      [else
       (local ((define loa-or-content (first optional-loa+content)))
         (if (list-of-attributes? loa-or-content)
             (rest optional-loa+content)
             optional-loa+content))])))

; AttrOrXexpr.v2 is one of:
; - [List-of Attribute]
; - Xexpr.v2

; AttrOrXexpr.v2 -> Boolean
; determines whether x is an element of [List-of Attribute]
; #false otherwise
(check-expect (list-of-attributes? '()) #true)
(check-expect (list-of-attributes? '((text "something"))) #true)
(check-expect (list-of-attributes? '(ul (li (word ((text "something"))))))
              #false)

(define (list-of-attributes? x)
  (cond
    [(empty? x) #true]
    [else (local ((define possible-attribute (first x)))
            (cons? possible-attribute))]))

; S-expr -> Boolean
; #true if ex is in XWord
(check-expect (word? w0) #true)
(check-expect (word? w1) #true)
(check-expect (word? w2) #true)
(check-expect (word? '(machine ((initial "red")) (action))) #false)

(define (word? ex)
  (match ex
    [(list 'word (list (list 'text txt))) #true]
    [else #false]))