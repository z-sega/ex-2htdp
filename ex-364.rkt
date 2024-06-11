;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-364) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
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
;; Represent this XML data as elements of Xexpr.v2:
;; 1. <transition from="seen-e" to="seen-f" />

'(transition ((from "seen-e")
              (to "seen-f")))

;; 2. <ul><li><word /><word /></li><li><word /></li></ul>

'(ul (li (word) (word))
     (li (word)))

;; Which one could be represented in Xexpr.v0 or Xexpr.v1
;; 2. can be represented using Xexpr.v1
;; None can be represented as Xexpr.v0 because both 1. and 2. have
;; content which is not supported in that data representation.
