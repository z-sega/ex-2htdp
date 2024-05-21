;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex-290) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
;; ex-290
;; Recall that the append function in ISL concatenates
;; the items of two lists or, equivalently, replaces
;; '() at the end of the first list with the second list:

(equal? (append (list 1 2 3) (list 4 5 6 7 8))
        (list 1 2 3 4 5 6 7 8))

;; Use foldr to define append-from-fold. What happens
;; if you replace foldr with foldl?

; [List-of X] [List-of X] -> [List-of X]
; appends two lists using foldr
(check-expect (append-from-foldr '(1 2 3) '(4 5 6))
              '(1 2 3 4 5 6))
(define (append-from-foldr l-a l-b)
  (foldr cons l-b l-a))

; [List-of X] [List-of X] -> [List-of X]
; appends two lists using foldl
(check-expect (append-from-foldl '(1 2 3) '(4 5 6))
              '(3 2 1 4 5 6))
(define (append-from-foldl l-a l-b)
  (foldl cons l-b l-a))

; -> foldr does what you'd expect. It concatenates the
; lists. However, the foldl version concatenates the
; lists but the first list is organized in reverse.
; This is because foldl folds/reduces from the last
; item on the list to the first.

;; Now use one of the fold functions to define functions
;; that compute the sum and the product, respectively,
;; of a list of numbers.

; [List-of Number] -> Number
; computes the sum of the numbers on the list
(check-expect (sum '()) 0)
(check-expect (sum '(0 1 2 3)) 6)
(define (sum l)
  (foldr + 0 l))

; [List-of Number] -> Number
; computes the product of the numbers on the list
(check-expect (product '()) 1)
(check-expect (product '(0 1 2 3)) 0)
(check-expect (product '(1 2 3)) 6)
(define (product l)
  (foldr * 1 l))

;; With one of the fold functions, you can define
;; a function that horizontally composes a list of
;; Images.
;; *Hints*
;; 1. Look up beside and empty-image. Can you use the
;; other fold function? Also define a function that
;; stacks a list of images vertically.
;; 2. Look up above.
(require 2htdp/image)

(define BLOCK (rectangle 15 15 "solid" "red"))
(define RECTANGLE (rectangle 30 15 "solid" "green"))
(define CIRCLE (circle 20 "solid" "yellow"))

; [List-of Image]
(define l0 `(,BLOCK ,RECTANGLE ,CIRCLE))

; [List-of Image] -> Image
; horizontally composes the images in l into one image
(check-expect (horizontal-compose-r l0)
              .)
(define (horizontal-compose-r l)
  (foldr beside empty-image l))

; [List-of Image] -> Image
; horizontally composes the images in l into one image
; in reverse
(check-expect (horizontal-compose-l l0)
              .)
(define (horizontal-compose-l l)
  (foldl beside empty-image l))

; -> Notice that the r-variant does the expected; the
; l-variant however processes the list in reverse.
; Note that the MT (base image) is not affected (and is
; always at the end of the composition).

; [List-of Image] -> Image
; vertically composes the images in l into one image
(check-expect (vertical-compose-r l0)
              .)
(define (vertical-compose-r l)
  (foldr above empty-image l))


; [List-of Image] -> Image
; vertically composes the images in l into one image
; in reverse
(check-expect (vertical-compose-l l0)
              .)
(define (vertical-compose-l l)
  (foldl above empty-image l))
  
