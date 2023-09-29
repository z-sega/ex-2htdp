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
; if the rocket is resting
(check-expect (launch "resting" " ") -3)
(check-expect (launch "resting" "a") "resting")
(check-expect (launch -3 " ") -3)
(check-expect (launch -1 " ") -1)
(check-expect (launch 33 " ") 33)
(check-expect (launch 33 "a") 33)
(define (launch x ke)
  (cond
    [(and (string? x) (string=? x "resting"))
     (if (string=? " " ke)
         -3
         x)]
    [(<= -3 x -1)
     x]
    [(>= x 0)
     x]))

; LRCD -> LRCD
; raises the rocket by YDELTA,
; if it is moving already

(check-expect (fly "resting") "resting")
(check-expect (fly -3) -2)
(check-expect (fly -2) -1)
(check-expect (fly -1) HEIGHT)
(check-expect (fly 10) (- 10 YDELTA))
(check-expect (fly 22) (- 22 YDELTA))

(define (fly x)
  (cond
    [(and (string? x) (string=? x "resting")) x]
    [(<= -3 x -1)
     (if (= x -1)
         ; last-count ? GROUND : continue countdown
         HEIGHT
         (+ x 1))]
    [(>= x 0) (- x YDELTA)]))

; LRCD -> Boolean
; Stops the program when the rocket is out of view

(check-expect (end? "resting") #f)
(check-expect (end? -2) #f)
(check-expect (end? 30) #f)
(check-expect (end? 0) #t)

(define (end? x)
  (and (number? x) (= x 0)))

; LRCD -> LRCD
(define (main1 s)
  (big-bang s
            [to-draw show]
            [on-tick fly 0.2]
            [on-key launch]
            [stop-when end?]))
