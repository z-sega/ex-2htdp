;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex-254) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-254
;; Formulate signatures for the following functions:
;;
;; - sort-n
;; which consumes a list of numbers and a function
;; that consumes two numbers (from the list) and produces a
;; Boolean; sort-n produces a sorted list of numbers.
;;
;; - sort-s
;; which consumes a list of strings and a function that consumes
;; two strings (from the list) and produces a Boolean; sort-s
;; produces a sorted list of strings.
;;
;; Then abstract over the two signatures, following the above
;; steps. Also show that the generalized signature can be
;; instantiated to describe the signature of a sort function
;; for lists of IRs.
;;
;; Where an IR is a structure:
;;   (make-IR String Number)

; [List-of Number] [Number Number -> Boolean] -> [List-of Number]
(define (sort-n l f) (... l))

; [List-of String] [String String -> Boolean] -> [List-of String]
(define (sort-s l f) (... l))

;; The steps:
;; 1. Given two similar function definitions, f and g, compare
;; their signatures for similarities and differences. The
;; goal is to discover the organization of the signature and
;; to mark the places where one signature differs from the other.
;; Connect the differences as pairs just like you do when you
;; analyze function bodies.
;;
;; DONE
;;
;; 2. Abstract f and g into f-abs and g-abs. That is, add
;; parameters that eliminate the differences between f and g.
;; Create signatures for f-abs and g-abs. Keep in mind what the
;; new parameters originally stood for; this helps you figure out
;; the new pieces of the signatures.
;;
; [List-of Number] [Number Number -> Boolean] -> [List-of Number]
; [List-of String] [String String -> Boolean] -> [List-of String]
;; 
;; 3. Check whether the analysis of step 1 extends to the
;; signatures of f-abs and g-abs. If so, replace the differences
;; with variables that range over classes of data.
;; Once the two signatures are the same, you have a signature
;; for the abstracted function.
;;
;  There are four pairs of differences, but they boil down to
;  just one since all occurences of Number in (1) become String
;  in (2). Here is the signature for the abstraction:
;
; [List-of X] [X X -> Boolean] -> [List-of X]
;;
;; 4. Test the abstract signature. First, ensure that
;; suitable substitutions of the varialbes in the abstract
;; signature yield the signatures of f-abs and g-abs. Second,
;; check that the generalized signature is in sync with the code.
;; For example, if p is a new parameter and its signature is
;;
;; ... [A B -> C] ...
;;
;; then p must always be applied to two arguments, the first one
;; from A and the second one from B. And the result of an
;; application of p is going to be a C and should be used where
;; elements of C are expected.
;;
; verify by instantiating the signature for sort-n
; X is Number
; [List-of Number] [Number Number -> Boolean] -> [List-of Number]
;;
; verify by instantiating the signature for sort-s
; X is String
; [List-of String] [String String -> Boolean] -> [List-of String]
;;
; generalize to sort-func for [List-of IR]
; X is IR
; [List-of IR] [IR IR -> Boolean] -> [List-of IR]
