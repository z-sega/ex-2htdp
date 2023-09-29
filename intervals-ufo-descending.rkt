#lang htdp/bsl
(require 2htdp/image)
(require 2htdp/universe)

; ------------------------
; Requirements:
; 1.
; Design a program that simulates the descent of a UFO.
; 
; 2.
; Add a status line. It says 'descending' when the UFO's height
; is above one third of the height of the canvas. It switches
; to 'closing in' below that. And finaly, when the UFO has
; reached the bottom of the canvas, the status notifies the
; player that the UFO has 'landed'. You are free to use
; appropriate colors for the status line.
;
; 3. Add a status line, positioned at (20, 20), that says
; "descending" when the UFO's height is above one third
; of the height of the canvas.

; ------------------------


; A WorldState is a Number.
; *interpretation number of pixels between the top and the UFO

(define WIDTH 300)
(define HEIGHT 300)

(define CLOSE (/ HEIGHT 3))
(define MTSCN (empty-scene WIDTH HEIGHT))
(define UFO (overlay
             (circle 10 "solid" "green")
             (rectangle 40 4 "solid" "green")))


; Worldstate -> WorldState
(define (main y0)
  (big-bang y0
            (on-tick calc-next-location)
            (to-draw render/status)
            (stop-when landed?)))


; WorldState -> WorldState
; computes next location of UFO
(check-expect (calc-next-location 11) 14)
(define (calc-next-location y)
  (+ y 3))

; -----------
(define POSITION-UFO-X (* 0.5 (image-width MTSCN)))

; WorldState -> Image
; places the UFO at given height into the center of MTSCN
(check-expect (render 11)
              (place-image UFO POSITION-UFO-X 11 MTSCN))
(define (render y)
  (place-image UFO POSITION-UFO-X y MTSCN))

; ------------
(define GROUND-POSITION-UFO-X
  (- (image-height MTSCN) (* 0.5 (image-height UFO))))

; WorldState -> WorldState
; Returns #t if the UFO has landed, #f otherwise
; --or--
; determines whether the UFO has landed
(check-expect (landed? (+ GROUND-POSITION-UFO-X 1)) #t)
(check-expect (landed? (- GROUND-POSITION-UFO-X 1)) #f)
(define (landed? y)
  (if (>= y GROUND-POSITION-UFO-X)
      #t
      #f))


; A WorldState falls into one of three intervals:
; - between 0 and CLOSE
; - between CLOSE and HEIGHT
; - below HEIGHT

; ---------------------
(define HEIGHT-ADJUSTED ;; ---- adjusted for stop-when logic
  (- GROUND-POSITION-UFO-X 5))

; WorldState -> WorldState
; adds a status line to the scene created by render
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (check-expect (render/status 10)                          ;;
;;               (place-image (text "descending" 11 "green") ;;
;;                            20 10                          ;;
;;                            (render 10)))                  ;;
;;                                                           ;;
;; (define (render/status y)                                 ;;
;;   (cond                                                   ;;
;;     ((<= 0 y CLOSE)                                       ;;
;;      (place-image (text "descending" 11 "green")          ;;
;;                   20 10                                   ;;
;;                   (render y)))                            ;;
;;     ((and (< CLOSE y) (< y HEIGHT))                       ;;
;;      (place-image (text "closing in" 11 "orange")         ;;
;;                   20 10                                   ;;
;;                   (render y)))                            ;;
;;     ((>= y HEIGHT)                                        ;;
;;      (place-image (text "landed" 11 "red")                ;;
;;                   20 10                                   ;;
;;                   (render y)))))                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; WorldState -> WorldState
; adds a status line to the scene created by render
; adjusts the 'landed' interval to account for the rocket
; actually landing and ending the world-program
(check-expect (render/status 10)
              (place-image (text "descending" 11 "green")
                           40 20
                           (render 10)))
(check-expect (render/status (+ CLOSE 1))
              (place-image (text "closing in" 11 "orange")
                           40 20
                           (render (+ CLOSE 1))))
(check-expect (render/status (+ HEIGHT-ADJUSTED 1))
              (place-image (text "landed" 11 "red")
                           40 20
                           (render (+ HEIGHT-ADJUSTED 1))))
(define (render/status y)
  (place-image
   (cond
     ((<= 0 y CLOSE)
      (text "descending" 11 "green"))
     ((and (< CLOSE y) (<= y HEIGHT-ADJUSTED))
      (text "closing in" 11 "orange"))
     ((> y HEIGHT-ADJUSTED)
      (text "landed" 11 "red")))
   40 20
   (render y)))
