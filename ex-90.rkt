;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex-90) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

; --- RELEVANT:ex-47.rkt

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

(define WORLD-WIDTH (* 2.5 SCENE-WIDTH))
(define WORLD-HEIGHT (* 4 SCENE-HEIGHT))

(define CAT (circle 5 "solid" "blue"))
(define POSITION-CAT-Y
  (- WORLD-HEIGHT (* 0.5 (image-height CAT))))

(define FRAME-GAUGE
  ; - FRAME-GAUGE is the gauge in a container
  (overlay/align/offset
   "middle" "center"
   (rectangle FRAME-WIDTH FRAME-HEIGHT  "outline" "black")
   0 0
   (empty-scene SCENE-WIDTH SCENE-HEIGHT)))

(define FRAME-WORLD
  (empty-scene WORLD-WIDTH WORLD-HEIGHT))

(define FRAME-GAUGE/WORLD
  ; - FRAME-WORLD is the FRAME-GAUGE in the top-right
  ; - corner of the FRAME-WORLD
  (overlay/align/offset
   "right" "top"
   FRAME-GAUGE
   0 0
   FRAME-WORLD))

; Number -> Image
; draw happiness-gauge at the given level l
; in the frame
(check-expect (draw-gauge 0)
              (overlay/align/offset
               "left" "center"
               (rectangle 0 GAUGE-HEIGHT "solid" "red")
               -5 0
               FRAME-GAUGE))
(check-expect (draw-gauge 40)
              (overlay/align/offset
               "left" "center"
               (rectangle 40 GAUGE-HEIGHT "solid" "red")
               -5 0
               FRAME-GAUGE))
(define (draw-gauge l)
  (overlay/align/offset
   "left" "center"
   (rectangle l GAUGE-HEIGHT "solid" "red")
   -5 0
   FRAME-GAUGE))

; --- ex-88.rkt
; Define a structure type that keeps track of the cat's x-coordinate
; and its happiness. Then formulate a data definition for cats,
; dubbed VCat, including an interpretation.

(define-struct vcat [x happiness])
; A VCat is a structure:
;   (make-vcat Number Number)
; *interpretation*
; A VCat (make-vcat x h) describes a
; virtual cat pet positioned at x on the x-axis
; with a happiness level at h.

; --- ex-89.rkt
; Design the happy-cat world program, which manages a
; walking cat and its happiness level. Let's assume that the
; cat starts out with perfect happiness.

; WorldState is (make-vcat x h) -> VCat
; where x is the virtual cats horizontal position in the world
; and h is its happiness level.

;(define CAT (make-vcat 25 SCORE-MAX)) ; --- default happy-cat

; --- wishlist
; update-vcat-position -> controls/checks how the cat pos is +/-


; Number -> Number
; updates happiness level h by n within
; its reasonable bounds [MIN, MAX].
(check-expect (update-happiness SCORE-MIN -1) SCORE-MIN)
(check-expect (update-happiness SCORE-MAX 1) SCORE-MAX)
(check-expect (update-happiness (+ SCORE-MIN 3) 3)
              (+ (+ SCORE-MIN 3) 3))
(define (update-happiness h n)
  (cond
    [(>= SCORE-MIN (+ h n)) SCORE-MIN]
    [(<= SCORE-MAX (+ h n)) SCORE-MAX]
    [else (+ n h)]))
    
; Number -> VCat
; deplete happiness by factor on each clock tick
(check-expect (deplete-happiness (+ SCORE-MIN 3))
              (+ (+ SCORE-MIN 3) AMBIENT-DEPLETION))
(define (deplete-happiness h)
  (update-happiness h AMBIENT-DEPLETION))

(define CAT-DISPLACEMENT-X 3) ; -- 3 pixels per clock-tick

; Number -> Number
; updates vcat x position within
; the confines of the SCENE.
(check-expect (update-x
               0)
              (+ 0 CAT-DISPLACEMENT-X))
(check-expect (update-x (+ WORLD-WIDTH 5))
              (modulo
               (round (+ CAT-DISPLACEMENT-X (+ WORLD-WIDTH 5)))
               (round (+ WORLD-WIDTH (* 0.5 (image-width CAT))))))
(define (update-x x)
  (modulo
   (round (+ CAT-DISPLACEMENT-X x))
   (round (+ WORLD-WIDTH (* 0.5 (image-width CAT))))))

 
; VCat -> VCat
; computes the state of the program
; after each clock-tick.
; - test starting position
(check-expect (update-cat/position/gauge
               (make-vcat 0 100))
              (make-vcat
               CAT-DISPLACEMENT-X
               (+ 100 AMBIENT-DEPLETION)))
(check-expect (update-cat/position/gauge
               (make-vcat 0 0))
              (make-vcat
               CAT-DISPLACEMENT-X
               0))
(define (update-cat/position/gauge c)
  (make-vcat
   (update-x (vcat-x c))
   (deplete-happiness (vcat-happiness c))))


; Number -> Image
; renders the happines-gauge in the scene
; at the level l
(check-expect (draw-world/gauge 0)
 (overlay/align/offset
   "right" "top"
   (overlay/align/offset
    "left" "center"
    (rectangle 0 GAUGE-HEIGHT "solid" "red")
    -5 0
    (overlay/align/offset
     "middle" "center"
     (rectangle FRAME-WIDTH FRAME-HEIGHT "outline" "black")
     0 0
     (empty-scene SCENE-WIDTH SCENE-HEIGHT)))
   0 0
   FRAME-WORLD))
(check-expect (draw-world/gauge 100)
 (overlay/align/offset
   "right" "top"
   (overlay/align/offset
    "left" "center"
    (rectangle 100 GAUGE-HEIGHT "solid" "red")
    -5 0
    (overlay/align/offset
     "middle" "center"
     (rectangle FRAME-WIDTH FRAME-HEIGHT "outline" "black")
     0 0
     (empty-scene SCENE-WIDTH SCENE-HEIGHT)))
   0 0
   FRAME-WORLD))
(define (draw-world/gauge l)
  (overlay/align/offset
   "right" "top"
   (overlay/align/offset
    "left" "center"
    (rectangle l GAUGE-HEIGHT "solid" "red")
    -5 0 ; --- worried about magical -5??
    (overlay/align/offset
     "middle" "center"
     (rectangle FRAME-WIDTH FRAME-HEIGHT "outline" "black")
     0 0
     (empty-scene SCENE-WIDTH SCENE-HEIGHT)))
   0 0
   FRAME-WORLD))


; VCat -> Image
; renders the cat and its happiness-gauge in
; the scene.
(define (render-cat/position/gauge c)
  (place-image
   ; ----- cat
   CAT
   (vcat-x c) POSITION-CAT-Y
   ; ----- world with gauge
   (draw-world/gauge (vcat-happiness c))))

(define FEED "up")
(define PET "down")

; VCat KeyEvent -> VCat
; computes the cats happiness level
; based on key-event k
; only two key-events are valid:
; - "up"
; - "down"
; -- test upper bound
(check-expect (update-happiness-level
               (make-vcat 0 SCORE-MAX) "up")
              (make-vcat 0 SCORE-MAX))
(check-expect (update-happiness-level
               (make-vcat 0 SCORE-MAX) "down")
              (make-vcat 0 SCORE-MAX))
; -- test within bound
(check-expect (update-happiness-level
               (make-vcat 0 50) "up")
              (make-vcat 0 (+ 50 FEEDING-RESTORATION)))
(check-expect (update-happiness-level
               (make-vcat 0 50) "down")
              (make-vcat 0 (+ 50 PETTING-RESTORATION)))
; -- test irrelevant action
(check-expect (update-happiness-level
               (make-vcat 0 50) "left")
              (make-vcat 0 50))
(define (update-happiness-level c k)
  (cond
    [(string=? k FEED)
     (make-vcat
      (vcat-x c)
      (update-happiness (vcat-happiness c) FEEDING-RESTORATION))]
    [(string=? k PET)
     (make-vcat
      (vcat-x c)
      (update-happiness (vcat-happiness c) PETTING-RESTORATION))]
    [else
     c]))

; --- ex-90.rkt
; Modify the happy-cat program from the preceding exercises
; so that it stops whenever the cat's happiness falls to 0.

; VCat -> Boolean
; #t when VCat c is depressed - when the happiness
; level is 0.
(check-expect (cat-depressed? (make-vcat 0 SCORE-MAX)) #f)
(check-expect (cat-depressed? (make-vcat 0 (+ SCORE-MIN 1))) #f)
(check-expect (cat-depressed? (make-vcat 0 SCORE-MIN)) #t)
(define (cat-depressed? c)
  (= (vcat-happiness c) SCORE-MIN))

    
(define (happy-cat c)
  (big-bang c
    [to-draw render-cat/position/gauge]
    [on-tick update-cat/position/gauge]
    [on-key update-happiness-level]
    [stop-when cat-depressed?]))

