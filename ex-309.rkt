#lang htdp/isl+

;; ex-309
;; Design the function words-on-line, which determines the
;; number of Strings per item in a list of list of strings.

(require 2htdp/abstraction)

; [List-of [List-of String]] -> [List-of N]
; determines the number of strings per item
; in sll
(define input '(("apple" "banana")
                ("orange" "grape" "kiwi" )
                ("pear" "pineapple")))
(define result '(2 3 2))

(check-expect (words-on-line '()) '())
(check-expect (words-on-line input) result)

(define (words-on-line sll)
  (for/list ([sl sll])
    (match sl
      [l (length l)])))
