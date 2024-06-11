;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-365) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
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


;; ex-365
;; Interpret the following elements of Xexpr.v2 as XML data:
;; 1. '(server ((name "example.org")))

; <server name="example.org"></server>

;; 2. '(carcas (board (grass)) (player ((name "sam"))))

; <carcas><board><grass></grass></board><player name="sam"></player></carcas>

;; 3. '(start)

; <start></start>

;; Which ones are elements of Xexpr.v0 or Xexpr.v1?
;; Xexpr.v0 elements: 3
;; Xexpr.v1 elements: 3 (also) but the rest rely on attributes (only
;; supported in Xexpr.v2)
 
