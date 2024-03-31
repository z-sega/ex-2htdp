;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex-255) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-255
;; Formulate signatures for the following functions:
;;
;; - map-n
;; consumes a list of numbers and a function from numbers to
;; numbers to produce a list of numbers
;;
;; - map-s
;; consumes a list of strings and a function from strings to
;; strings and produces a list of strings.
;;
;; Then abstract over the two signatures, following the above
;; steps. Also show that the generalized signature can be
;; instantiated to describe the signature of the map1 function
;; above:

; map-n
; [List-of Number] [Number -> Number] -> [List-of Number]

; map-s
; [List-of String] [String -> String] -> [List-of String]

; comparing the two functions there are four sets of diffs
; but they boil down to just one, since for every Number in (1)
; there is String in (2). Therefore one signature parameter
; will be sufficient for abstracting over the two signatures.

; [List-of X] [X -> X] -> [List-of X]

; the abstraction can be verified by describing the signature
; of map-n and then the signature of map-s in terms of the
; abstract form:

; map-n
; X is Number
; [List-of Number] [Number -> Number] -> [List-of Number]

; map-s
; X is String
; [List-of String] [String -> String] -> [List-of String]

; Finally, to show that the generalized signature can
; be instantiated to describe the following signature:

; map1
; [X Y] [List-of X] [X -> Y] -> [List-of Y]

; map1's signature is a superset of our abstract signature.
; our abstract signature can be described in terms of map1
; as follows:

; X and Y is Z (some class of data)
; [List-of Z] [Z -> Z] -> [List-of Z]

; but map1 cannot be described in terms of our abstract
; signature
