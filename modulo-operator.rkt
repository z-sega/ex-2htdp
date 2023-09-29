#lang htdp/bsl
(require 2htdp/universe)
(require 2htdp/image)

(define WORLD-WIDTH 50)
(define WORLD-HEIGHT (* 0.25 WORLD-WIDTH))

(define CIRCLE
  (circle 5 "solid" "blue"))
(define POSITION-CIRCLE-Y
  (- WORLD-HEIGHT (* 0.5 (image-height CIRCLE))))

(define BACKGROUND
  (empty-scene WORLD-WIDTH WORLD-HEIGHT))

; WorldState -> WorldState
; move the circle by 1 pixels to the right
; whenever the circle disappears on the right
; make it reappear on the left.
(define (move-circle ws)
  (modulo
   (+ 1 ws)
   ;(round WORLD-WIDTH)
   ; taking the disappearance of the circle into account
   ; since image-width works from the center point of circle
   (round (+ WORLD-WIDTH (* 0.5 (image-width CIRCLE))))))

; WorldState -> Image
; places the circle into the BACKGROUND scene,
; according to the given world-state
(define (draw-circle ws)
  (place-image
   CIRCLE
   ws POSITION-CIRCLE-Y
   BACKGROUND))

(define (main ws)
  (big-bang ws
            (on-tick move-circle)
            (on-draw draw-circle)))
