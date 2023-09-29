;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex-47) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

(define SCORE-MAX 300)
(define SCORE-MIN 0)
(define AMBIENT-DEPLETION -0.1)
(define PETTING-RESTORATION 1)
(define FEEDING-RESTORATION 3)


; The WorldState is a number that represents happiness.
; *interpretation*
; The interval of happiness values is [0, 100]
; where 0 is depressed and 100 is excited.

; ------------

(define GAUGE-WIDTH SCORE-MAX)
(define GAUGE-HEIGHT 20)

(define FRAME-WIDTH (+ GAUGE-WIDTH 1))
(define FRAME-HEIGHT GAUGE-HEIGHT)

(define SCENE-WIDTH (+ FRAME-WIDTH 8))
(define SCENE-HEIGHT (+ FRAME-HEIGHT 8))

(define GAUGE-FRAME
  (overlay/align/offset
   "middle" "center"
   (rectangle FRAME-WIDTH FRAME-HEIGHT  "outline" "black")
   0 0
   (empty-scene SCENE-WIDTH SCENE-HEIGHT )))

; Number -> Image
; draw happiness-gauge at the given level l
; in the frame
(check-expect (draw-gauge 0)
              (overlay/align/offset
               "left" "center"
               (rectangle 0 GAUGE-HEIGHT "solid" "red")
               -5 0
               GAUGE-FRAME))
(check-expect (draw-gauge 40)
              (overlay/align/offset
               "left" "center"
               (rectangle 40 GAUGE-HEIGHT "solid" "red")
               -5 0
               GAUGE-FRAME))
(define (draw-gauge l)
  (overlay/align/offset
   "left" "center"
   (rectangle l GAUGE-HEIGHT "solid" "red")
   -5 0
   GAUGE-FRAME))

; WorldState -> Image
; render the happiness-gauge
(check-expect (render (- SCORE-MIN 1)) (draw-gauge SCORE-MIN))
(check-expect (render 50) (draw-gauge 50))
(check-expect (render (+ SCORE-MAX 1)) (draw-gauge SCORE-MAX))
(define (render ws)
  (cond
    [(< ws SCORE-MIN) (draw-gauge SCORE-MIN)]
    [(and (>= ws SCORE-MIN) (< ws SCORE-MAX)) (draw-gauge ws)]
    [else (draw-gauge SCORE-MAX)]))

; WorldState -> WorldState
; deplete happiness by factor on each clock tick
(check-expect (deplete-happiness 0) 0)
(check-expect (deplete-happiness -1) 0)
(check-expect (deplete-happiness 40) 39.9)
(define (deplete-happiness ws)
  (cond
    [(>= SCORE-MIN ws) SCORE-MIN]
    [else (+ ws AMBIENT-DEPLETION)]))

; WorldState KeyEvent -> WorldState
; restores happiness-gauge when the following KeyEvents
; are applied:
; - "left"
; - "right"
; - "down"
(check-expect (pet 0 "up") FEEDING-RESTORATION)

(check-expect (pet 0 "right") PETTING-RESTORATION)
(check-expect (pet 0 "down") PETTING-RESTORATION)
(check-expect (pet 0 "left") PETTING-RESTORATION)

(check-expect (pet 50 "k") 50)
(define (pet ws k)
  (cond
    [(and
      (<= ws (- SCORE-MAX FEEDING-RESTORATION)) ; -- room-to-restore?
      (string=? k "up"))
     (+ ws FEEDING-RESTORATION)]
    
    [(and
      (<= ws (- SCORE-MAX PETTING-RESTORATION))
      (string=? k "right"))
     (+ ws PETTING-RESTORATION)]
    [(and
      (<= ws (- SCORE-MAX PETTING-RESTORATION))
      (string=? k "down"))
     (+ ws PETTING-RESTORATION)]
    [(and
      (<= ws (- SCORE-MAX PETTING-RESTORATION))
      (string=? k "left"))
     (+ ws PETTING-RESTORATION)]
    [else ws]))


; WorldState -> WorldState
(define (gauge-prog ws)
  (big-bang ws
    [to-draw render]
    [on-tick deplete-happiness]
    [on-key pet]))