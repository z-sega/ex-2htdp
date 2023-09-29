;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex-95) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

;; **Sample Problem**
;; 
;; Design a game program using the 2htdp/universe teachpack
;; for playing a simple space invader game. The player is in
;; control of a tank (a small rectangle) that must defend our
;; planet (the botton of the canvas) from a UFO
;; (see *Intervals* for one possibility) that descends from
;; the top of the canvas to the bottom.
;;
;; In order to stop the UFO from landing, the player
;; may fire a single missile (a triangle smaller than the tank)
;; by hitting the space bar. In response,
;; the missile emerges from the tank.
;; 
;; If the UFO collides with the missile, the player wins;
;; otherwise the UFO lands and the player loses.

;; **details**
;;
;; First, the tank moves a constant speed along the bottom of
;; the canvaas, though the player may use the left arrow key
;; and the right arrow key to change directions.
;;
;; Second, the UFO descends at a constant velocity but makes small
;; random jumpts to the left or right.
;;
;; Third, once fired, the missile ascends along a straight vertical
;; line at a constant speed at least twice as fast as the UFO
;; descends.
;;
;; Finally, the UFO and the missile collide if their reference points
;; are close enough, for whatever you think "close enough" means.

;; -- ex-94.rkt
(define WIDTH 200)
(define HEIGHT 400)
(define CENTER-X (* 0.5 WIDTH))

(define BACKGROUND
  (empty-scene WIDTH HEIGHT))
(define TANK
  (rectangle 50 20 "solid" "blue"))
(define UFO
  (overlay
   (circle 10 "solid" "green")
   (rectangle 50 5 "solid" "green")))
(define MISSILE
  (triangle 15 "solid" "red"))

(define TANK-Y (- HEIGHT (image-height TANK)))
(define UFO-Y
  (+
   0 ; -- TOP of the SCENE
   10 ; -- ALLOWANCE
   (image-height UFO)))
(define MISSILE-Y ; -- initial
  (- HEIGHT (+ (image-height TANK) (* 0.5 (image-height TANK)))))

; - initial scene
(define INITIAL-SCENE/AIM
  (place-images/align
   (list UFO TANK)
   (list (make-posn CENTER-X UFO-Y)
         (make-posn CENTER-X TANK-Y))
   "center" "top"
   BACKGROUND))

(define INITIAL-SCENE/FIRED
  (place-images/align
   (list UFO TANK MISSILE)
   (list (make-posn CENTER-X UFO-Y)
         (make-posn CENTER-X TANK-Y)
         (make-posn CENTER-X MISSILE-Y))
   "center" "top"
   BACKGROUND))


;; -- defining itemizations


; A UFO is a Posn.
; *interp.* (make-posn x y) is the UFO's location
; (using the top-down, left-to-right convention)

(define-struct tank [loc vel])
; A Tank is a structure:
;   (make-tank Number Number)
; *interp.* (make-tank x dx) specifies the position:
; (x, HEIGHT) and the tank's speed: dx pixels/tick

; A Missile is a Posn.
; *interp.* (make-posn x y) is the missile's place


(define-struct aim [ufo tank])
; Aim is a structure:
;   (make-aim UFO Tank)
; *interp.* (make-aim u t) describes when the
; player is trying to get the tank in position for
; a shot.
; The UFO is at position ((posn-x u), (posn-y u)),
; and the tank is at x-position (tank-x t) moving
; at a velocity of (tank-vel t).


(define-struct fired [ufo tank missile])
; Fired is a structure:
;   (make-fired UFO Tank Missile)
; *interp.*
; (make-fired u t m) describes when the missile
; is fired.
; The UFO is at position ((posn-x u), (posn-y u)),
; and the tank is at x-position (tank-x t) moving
; at a velocity of (tank-vel t). And the missile
; is at ((posn-x m), (posn-y m)).


; A SIGS is one of:
; - (make-aim UFO Tank)
; - (make-fired UFO Tank Missile)
; *interp.* represents the complete state of a
; space invader game

;; -- ex-95.rkt
;; Explain why the three instances are generated according to
;; the first or second clause of the data definition.

;; They are generated this way because the three instances
;; represent the state of the world program. Which as described
;; in the SIGS data definition is one of;
;; - Aim (clause 1)
;; - Fired (clause 2)
