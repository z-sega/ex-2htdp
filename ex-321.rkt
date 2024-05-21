;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-321) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
;; ex-321
;; Abstract the data definitions for S-expr and SL so that
;; they abstract over the kinds of Atoms that may appear.

; An S-expr is one of:
; - Atom
; - SL

; An Atom is one of:
; - Number
; - String
; - Symbol

; An SL is one of:
; - '()
; - (cons S-expr SL)

; To "abstract" is to turn something concrete into a parameter.
; To abstract similar function definitions, you add parameters
; that replace concrete values in the definition.
; To abstract similar data definitions, you create parametric
; data definitions.

; Abstracting over the kinds of Atoms in SL and S-expr
; steps:
; 1. abstract over differences
; 2. instantiate the abstraction
; 3. create examples and make sure they are the same as concrete data
; definitions

; An S-expr is one of:
; - [Atomic X]
; - [List-of S-expr]

; An [Atomic X] is a non-compound data class.
(define atomic-number 0) ; [Atomic Number]
(define atomic-string "a") ; [Atomic String]
(define atomic-symbol 'a)  ; [Atomic Symbol]

; different ideas:
; https://github.com/S8A/htdp-exercises/blob/master/ex321.rkt
; https://gitlab.com/cs-study/htdp/-/blob/main/04-Intertwined-Data/19-The-Poetry-of-S-expressions/Exercise-321.rkt?ref_type=heads