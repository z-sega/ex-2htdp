;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname alpha-traffic-light-sim) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

(define RED "red")
(define GREEN "green")
(define YELLOW "yellow")

; An S-TrafficLight is one of:
; - RED
; - GREEN
; - YELLOW

(define WIDTH 90)
(define HEIGHT 30)
(define RADIUS 10)
(define BACKGROUND
  (empty-scene WIDTH HEIGHT))
(define SPACE-LENGTH (/ (- WIDTH (* 3 (* 2 RADIUS)))
                        4))
(define SPACE
  (rectangle SPACE-LENGTH 1 "solid" "white"))

; ---------------------------
; S-TrafficLight -> S-TrafficLight
; yield the next state, given current state cs

(check-expect (tl-next-symbolic RED) GREEN)
(check-expect (tl-next-symbolic GREEN) YELLOW)
(check-expect (tl-next-symbolic YELLOW) RED)

(define (tl-next-symbolic cs)
  (cond
    [(equal? RED cs) GREEN]
    [(equal? GREEN cs) YELLOW]
    [(equal? YELLOW cs) RED]))
; ---------------------------

; N-TrafficLight -> N-TrafficLight
; yields the next state, given current state cs
(define (tl-next-symbolic-symbolic-numeric cs)
  (modulo (+ cs 1) 3))


; TrafficLight -> Image
; renders the current state cs as an image

(check-expect (tl-render RED)
              (overlay
               (beside
                SPACE
                (bulb-render "red" RED)
                SPACE
                (bulb-render "yellow" RED)
                SPACE
                (bulb-render "green" RED)
                SPACE)
               BACKGROUND))
(check-expect (tl-render GREEN)
              (overlay
               (beside
                SPACE
                (bulb-render "red" GREEN)
                SPACE
                (bulb-render "yellow" GREEN)
                SPACE
                (bulb-render "green" GREEN)
                SPACE)
               BACKGROUND))
(check-expect (tl-render YELLOW)
              (overlay
               (beside
                SPACE
                (bulb-render "red" YELLOW)
                SPACE
                (bulb-render "yellow" YELLOW)
                SPACE
                (bulb-render "green" YELLOW)
                SPACE)
               BACKGROUND))

(define (tl-render cs)
  (overlay
   (beside
    SPACE
    (bulb-render "red" cs)
    SPACE
    (bulb-render "yellow" cs)
    SPACE
    (bulb-render "green" cs)
    SPACE)
   BACKGROUND))

; TrafficLight String -> Image
; if the given TrafficLight cs is for the given bulb bc,
; render as ON, else OFF

(check-expect (bulb-render "red" GREEN)
              (circle RADIUS "outline" "red"))
(check-expect (bulb-render "red" RED)
              (circle RADIUS "solid" "red"))

(define (bulb-render c cs)
  (circle RADIUS (if (equal? c cs)
                     "solid"
                     "outline") c))

; -- ex-59.rkt

; TrafficLight -> TrafficLight
; simulates a clock-based American traffic light
(define (traffic-light-simulation s)
  (big-bang s
    [to-draw tl-render]
    [on-tick tl-next-symbolic 3]))