;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex-61) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

(define BULB-RADIUS 7.5)
(define WIDTH (* BULB-RADIUS 12))
(define HEIGHT 30)

(define RED "red")
(define GREEN "green")
(define YELLOW "yellow")

; An S-TrafficLight is one of:
; - RED
; - GREEN
; - YELLOW

; S-TrafficLight -> S-TrafficLight
; yields the next state, given current state cs
(check-expect (tl-next-numeric RED) GREEN)
(check-expect (tl-next-numeric GREEN) YELLOW)
(check-expect (tl-next-numeric YELLOW) RED)
(define (tl-next-numeric cs)
  (cond
    [(equal? cs RED) GREEN]
    [(equal? cs GREEN) YELLOW]
    [(equal? cs YELLOW) RED]))
; tl-next conveys its intention more clearly than
; the tl-next-numeric function because this is
; a traffic-light sim. The data representation
; based on the strings: "red", "yellow", and "green"
; make it very clear what the state of the program
; is and clarifies the operations in the function
; definition.
; tl-next-numeric is clever but it seems like
; mathematical magic at first glance.
; ---------------- ex-60 in the tests above


; TrafficLight -> TrafficLight
; yields the next state, given current state cs
(check-expect (tl-next "red") "green")
(check-expect (tl-next "green") "yellow")
(check-expect (tl-next "yellow") "red")
(define (tl-next cs)
  (cond
    [(string=? "red" cs) "green"]
    [(string=? "green" cs) "yellow"]
    [(string=? "yellow" cs) "red"]))

; String TrafficLight -> Bool
; #t if the bulb is active
; i.e if the given strings match
(check-expect (is-active? "red" "red") #t)
(check-expect (is-active? "red" "green") #f)
(define (is-active? color cs)
  (string=? color cs))


; String Bool -> Image
; renders a one-color bulb as an image
; if it is active, the bulb is lit.
(check-expect (draw-bulb "red" #t)
              (circle BULB-RADIUS "solid" "red"))
(check-expect (draw-bulb "red" #f)
              (circle BULB-RADIUS "outline" "red"))
(define (draw-bulb color active?)
  (circle BULB-RADIUS
          (if active? "solid" "outline")
          color))

; String TrafficLight -> Image
; renders a one-color bulb as an image
; just a sugary combination of 'draw-bulb
; and 'is-active? test.
(check-expect (draw-bulb/active "red" "red")
              (draw-bulb "red" (is-active? "red" "red")))
(check-expect (draw-bulb/active "red" "green")
              (draw-bulb "red" (is-active? "red" "green")))
(define (draw-bulb/active color cs)
  (draw-bulb color (is-active? color cs)))
      


; TrafficLight -> Image
; renders the current state cs as an image
(check-expect (tl-render "red")
              (place-images
               (list (draw-bulb/active "red" "red")
                     (draw-bulb/active "yellow" "red")
                     (draw-bulb/active "green" "red"))
               (list (make-posn 20 15)
                     (make-posn 45 15)
                     (make-posn 70 15))
               (empty-scene WIDTH 30)))
(check-expect (tl-render "yellow")
              (place-images
               (list (draw-bulb/active "red" "yellow")
                     (draw-bulb/active "yellow" "yellow")
                     (draw-bulb/active "green" "yellow"))
               (list (make-posn 20 15)
                     (make-posn 45 15)
                     (make-posn 70 15))
               (empty-scene WIDTH 30)))
(define (tl-render cs)
  (place-images
   (list (draw-bulb/active "red" cs)
         (draw-bulb/active "yellow" cs)
         (draw-bulb/active "green" cs))
   (list (make-posn 20 15)
         (make-posn 45 15)
         (make-posn 70 15))
   (empty-scene WIDTH 30)))


; TrafficLight -> TrafficLight
; simulates a clock-based American traffic light
(define (traffic-light-simulation initial-state)
  (big-bang initial-state
    [to-draw tl-render]
    [on-tick tl-next 1]))