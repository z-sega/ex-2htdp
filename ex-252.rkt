;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex-252) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)

;; ex-252
;; Design fold2, which is the abstraction of the two functions
;; below. Compare this exercise with ex-251. Even though both
;; involve the product function, this exercise poses an
;; additional challenge because the second function,
;; image*, consumes a list of Posns and produces an Image.
;; Still, the solution is within reach of the material in
;; this section, and it is especially worth comparing the
;; solution with the one to the preceding exercise. The
;; comparison yields interesting insights into abstract
;; signatures.

(define test-numbers '(1 2 3 4 5))
(define test-posns `(,(make-posn 0 0)
                     ,(make-posn 0 20)
                     ,(make-posn 20 20)
                     ,(make-posn 40 20)))

; [List-of Number] -> Number
(define (product l)
  (cond
    [(empty? l) 1]
    [else (* (first l)
             (product (rest l)))]))

; [List-of Posn] -> Image
(define (image* l)
  (cond
    [(empty? l) emt]
    [else (place-dot (first l)
                     (image* (rest l)))]))

; Posn Image -> Image
(define (place-dot p img)
  (place-image dot
               (posn-x p) (posn-y p)
               img))

; graphical constants
(define emt (empty-scene 100 100))
(define dot (circle 3 "solid" "red"))


; compare analogous differences:
; [(empty? l) <1>]
; [else (<2> (first l) (<3> (rest l)))]

; abstract over differences:
; [List-of ITEM] [ITEM ITEM -> ITEM] ITEM -> ITEM
(define (fold2 l f acc)
  (cond
    [(empty? l) acc]
    [else (f (first l)
             (fold2 (rest l) f acc))]))

; verify abstraction:
(check-expect (product-from-abstract test-numbers)
              (product test-numbers))
(define (product-from-abstract l)
  (fold2 l * 1))

(check-expect (image*-from-abstract test-posns)
              (image* test-posns))
(define (image*-from-abstract l)
  (fold2 l place-dot emt))
