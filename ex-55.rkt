#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)

(define HEIGHT 300)
(define WIDTH 100)
(define YDELTA 3)

(define BACKG (empty-scene WIDTH HEIGHT))
(define ROCKET (rectangle 5 30 "solid" "red"))

(define CENTER (* 0.5 (image-height ROCKET)))


; An LRCD (short for launching rocket countdown) is one of:
; - "resting"
; - a Number between -3 and -1
; - a NonnegativeNumber
; *interpretation* a grounded rocket, in countdown mode,
; a number denotes the number of pixels between the
; top of the canvas and the rocket (its height)


; LRCD -> Image
; renders the state as a resting or flying rocket
(check-expect
 (show "resting")
 (draw-rocket-scene HEIGHT))
(check-expect
 (show -3)
 (place-image (text "-3" 20 "red")
              10 (* 3/4 WIDTH)
              (draw-rocket-scene HEIGHT)))
(check-expect
 (show -2)
 (place-image (text "-2" 20 "red")
              10 (* 3/4 WIDTH)
              (draw-rocket-scene HEIGHT)))
(check-expect
 (show -1)
 (place-image (text "-1" 20 "red")
              10 (* 3/4 WIDTH)
              (draw-rocket-scene HEIGHT)))

(check-expect
 (show HEIGHT)
 (draw-rocket-scene HEIGHT))
(check-expect
 (show 53)
 (draw-rocket-scene 53))
(check-expect
 ; TODO: Figure out why this is supposed
 ; to be a special test-case
 (show 0)
 (draw-rocket-scene 0))
(define (show x)
  (cond
    [(and (string? x) (string=? x "resting"))
     (draw-rocket-scene HEIGHT)]
    [(<= -3 x -1)
     (place-image (text (number->string x) 20 "red")
                  10 (* 3/4 WIDTH)
                  (draw-rocket-scene HEIGHT))]
    [(>= x 0)
     (draw-rocket-scene x)]))

; LRCD -> Image
; renders a rocket appropriately positioned in the scene
(check-expect (draw-rocket-scene 40)
              (place-image
               ROCKET
               10 (- 40 CENTER)
               BACKG))
(define (draw-rocket-scene x)
  (place-image
   ROCKET
   10 (- x CENTER)
   BACKG))

; LRCD KeyEvent -> LRCD
; starts the countdown when space bar is pressed,
; if the rocket is still resting
(define (launch x ke)
  x)

; LRCD -> LRCD
; raises the rocket by YDELTA,
; if it is moving already
(define (fly x)
  x)
