#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)

; ----------------------
; Design a program that launches a rocket when
; the user of your program presses the space bar.
; The program first displays the rocket sitting
; at the bottom of the canvas. Once launched, it
; moves upward at three pixels per clock tick.
; ----------------------

(define WIDTH 200)
(define HEIGHT 100)
(define BACKGROUND (empty-scene WIDTH HEIGHT))
(define ROCKET (bitmap/file "./media/rocket.png"))
(define ROCKET-CENTER (* 0.5 (image-height ROCKET)))
(define ROCKET-REFERENCE-POINT ROCKET-CENTER)
(define POSITION-ROCKET-X (* 0.5 WIDTH))

; An LR (short for launching rocket) is one of:
; - "resting"
; - NonnegativeNumber
; *interpretation*
; "resting" represents a grounded rocket
; a number denotes the height of a rocket in flight

; -------------- Ex. 53

; "height" definition is ambigious ...
; interpreting height as the distance between the
; ground and the rocket's point of reference.
; AND knowing that most BSL functions work with images
; by interpreting vertical distances from top to bottom.
;
; THEN the following functions make transition between
; information (height) and data (the top-to-bottom distance)
; clear.

(define (get-data-from-height n)
  (- HEIGHT n))
(define (get-info-for-height y)
  (- HEIGHT y))

; Number -> Number
; Position of rocket, respecting reference point
(check-expect (position-rocket-y 0)
              (-
               (get-data-from-height 0)
               ROCKET-REFERENCE-POINT))
(define (position-rocket-y y)
   (- (get-data-from-height y) ROCKET-REFERENCE-POINT))

; NOTE that the inverse relationship between height
; as information and it's data-representation is inverted.

; Draw some world scenarios and represent them with data.
; Pick some data examples and draw pictures that match them.

; Number -> Image
; draw scene and position rocket at y (top-to-bottom)
(check-expect (draw-scene 0)
              (place-image
               ROCKET
               POSITION-ROCKET-X (position-rocket-y 0)
               BACKGROUND))
(define (draw-scene y)
  (place-image
   ROCKET
   POSITION-ROCKET-X (position-rocket-y y)
   BACKGROUND))

; ex. 1 - information: rocket at ground position
; height (info.) is 0, data-repr. is 100 
(draw-scene 0)

; ex. 2 - information: rocket at ground position
; height (info.) is 25, data-repr. is 75 
(draw-scene 25)

; ex. 3 - information: rocket at center of scene
; height (info.) is 50, data-repr is 50
(draw-scene 50)

; ex. 4 - information: rocket at ground position
; height (info.) is 75, data-repr. is 25 
(draw-scene 75)

; ex. 5 - information: rocket at HEIGHT position
; height (info.) is HEIGHT, data-repr. is 0
(draw-scene HEIGHT)

; ex. 6 - animate lift-off!
(animate draw-scene)
  