#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)

; --- dealing with nested structures

; Sample Problem:
; Your team is desiging a game program that keeps track
; of an object that moves across the canvas at changing
; speed. The chosen data representation requires two
; data definitions

(define-struct ufo [loc vel])
; A UFO is a structure:
;   (make-ufo Posn Vel)
; *interpretation*
; (make-ufo p v) is at location p
; moving at velocity v

(define-struct vel [deltax deltay])
; A Vel is a structure:
;   (make-vel Number Number)
; *interpretation* (make-vel dx dy) means a velocity of
; dx pixels [per tick] along the horizontal and
; dy pixels [per tick] along the vertical direction

; --------- explore the data definitions:

(define v1 (make-vel 8 -3))
(define v2 (make-vel -5 -3))

(define p1 (make-posn 22 80))
(define p2 (make-posn 30 77))

(define u1 (make-ufo p1 v1))
(define u2 (make-ufo p1 v2))
(define u3 (make-ufo p2 v1))
(define u4 (make-ufo p2 v2))

; UFO -> UFO
; determines where u moves in one clock tick;
; leaves the velocity as is
(check-expect (ufo-move-1 u1) u3)
(check-expect (ufo-move-1 u2)
              (make-ufo (make-posn 17 77) v2))
(define (ufo-move-1 u)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; (... (ufo-loc u) ... (ufo-vel u) ...) ;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (make-ufo (posn+ (ufo-loc u) (ufo-vel u))
            (ufo-vel u)))


; Posn Vel -> Posn
; adds v to p
(check-expect (posn+ p1 v1) p2)
(check-expect (posn+ p1 v2) (make-posn 17 77))
(define (posn+ p v)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; (... (posn-x p) ... (posn-y p) ...          ;;
  ;;  ... (vel-deltax v) ... (vel-deltay v) ...) ;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (make-posn (+ (posn-x p) (vel-deltax v))
             (+ (posn-y p) (vel-deltay v))))


; A UFO represents the state of the world.
; UFO -> UFO
(define (main u0)
  (big-bang u0
            [on-tick ufo-move-1]
            [to-draw ...]))


;; The key part of this how `posn+' simplifies
;; the definition of `ufo-move-1'.
;; The elegance can be summarized as follows:
;; 
;; `If a function deals with nested structures,
;; develop one function per level of nesting.`
;;
;; ufo-move-1 deals with a nested structure,
;; a wish that manifested as posn+ simplifies
;; how the nested data is handled to actually
;; make the ufo move.
