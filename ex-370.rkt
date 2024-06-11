;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-370) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
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

;; ex-370
;; Make up three examples for XWords. Design word?, which checks
;; whether some ISL+ value is in XWord, and word-text, which
;; extracts the value of the only attribute of an instance of
;; XWord.

; An XWord is '(word ((text String))).
(define w0 '(word ((text "Zero"))))
(define w1 '(word ((text "One"))))
(define w2 '(word ((text "Two"))))

(require 2htdp/abstraction)

; S-expr -> Boolean
; #true if ex is in XWord
(check-expect (word.v1? w0) #true)
(check-expect (word.v1? w1) #true)
(check-expect (word.v1? w2) #true)
(check-expect (word.v1? '(machine ((initial "red")) (action))) #false)

(define (word.v1? ex)
  (local (; SL -> Boolean
          (define (sl-word? sl)
            (and (equal? 2 (length sl))
                 (symbol=? 'word (first sl))
                 (string? (find-attr (second sl) 'text)))))
  (and (cons? ex)
       (sl-word? ex))))

; S-expr -> Boolean
; #true if ex is in XWord
(check-expect (word.v2? w0) #true)
(check-expect (word.v2? w1) #true)
(check-expect (word.v2? w2) #true)
(check-expect (word.v2? '(machine ((initial "red")) (action))) #false)

(define (word.v2? ex)
  (match ex
    [(list 'word (list (list 'text txt))) #true]
    [else #false]))

; XWord -> String
; retrieves the text attribute of ex
(check-expect (word-text w0) "Zero")
(check-expect (word-text w1) "One")
(check-expect (word-text w2) "Two")

(define (word-text ex)
  (match ex
    [(list 'word (list (list 'text txt))) txt]))

  

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

