;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-372) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
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

; An XEnum.v1 is one of:
; - (cons 'ul [List-of XItem.v1])
; - (cons 'ul (cons Attributes [List-of XItem.v1]))
;
; An XItem.v1 is one of:
; - (cons 'li (cons XWord '()))
; - (cons 'li (cons Attributes (cons XWord '())))
;
; where Attributes is a [List-of Attribute]
(define word-one '(word ((text "one"))))
(define word-two '(word ((text "two"))))
(define l1 `(li ,word-one))
(define l2 `(li ,word-two))
(define e0 `(ul ,l1 ,l2))

(require 2htdp/abstraction)
(require 2htdp/image)

(define BT (circle 2.5 'solid 'black))

; XItem.v1 -> Image
; renders an item as a "word" prefixed by a bullet
(check-expect (render-item1 l1)
              (beside/align 'center BT (text (word-text word-one) 12 'black)))
(check-expect (render-item1 l2)
              (beside/align 'center BT (text (word-text word-two) 12 'black)))

(define (render-item1 i)
  (local ((define content (xexpr-content i))
          (define element (first content))
          (define a-word (word-text element))
          (define item (text a-word 12 'black)))
    (beside/align 'center BT item)))

(define e0-rendered
  (above/align
   'left
   (beside/align 'center BT (text "one" 12 'black))
   (beside/align 'center BT (text "two" 12 'black))))

; XEnum.v1 -> Image
; renders a simple enumeration as an image
(check-expect (render-enum1 e0) e0-rendered)

(define (render-enum1 xe)
  (local ((define content (xexpr-content xe))

          ; XItem.v1 Image -> Image
          (define (deal-with-one item so-far)
            (above/align 'left
                         (render-item1 item)
                         so-far)))
  (foldr deal-with-one empty-image content)))

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
(define (list-of-attributes? x)
  (cond
    [(empty? x) #true]
    [else (local ((define possible-attribute (first x)))
            (cons? possible-attribute))]))