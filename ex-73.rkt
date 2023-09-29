#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)

(define MTS (empty-scene 100 100))
(define DOT (circle 3 'solid 'red))

; Posn -> Image
; adds a red spot to MTS at p
(check-expect (scene+dot (make-posn 10 20))
              (place-image DOT 10 20 MTS))
(check-expect (scene+dot (make-posn 88 73))
              (place-image DOT 88 73 MTS))
(define (scene+dot p)
  (place-image
   DOT
   (posn-x p) (posn-y p)
   MTS))

; Posn -> Posn
; increases the x-coordinate of p by 3
(check-expect (x+ (make-posn 10 0))
              (make-posn 13 0))
(define (x+ p)
  (make-posn (+ (posn-x p) 3) (posn-y p)))

; Posn -> Posn
; updater:
; consumes a Posn p and a Number n
; produces a Posn like p with n in the x field.
(check-expect (posn-up-x
               (make-posn 2 5)
               4)
              (make-posn 4 5))
(define (posn-up-x p n)
  (make-posn
   n
   (posn-y p)))

; --------------- wish-list

(define (reset-dot p) ...)

; -------------------------


; A Posn represents the state of the world.

; Posn -> Posn
(define (main p0)
  (big-bang p0
            [on-tick x+]
            [on-mouse reset-dot]
            [to-draw scene+dot]))
