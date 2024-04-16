;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname power-from-local-function-definitions) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/universe)
(require 2htdp/image)

(define-struct transition [current next])
; A Transition is a structure:
;   (make-transition FSM-State FSM-State)

; FSM-State is a Color.
(define RED "red")
(define YELLOW "yellow")
(define GREEN "green")

(define FLOOR-1 "white")
(define FLOOR-2 "white smoke")
(define FLOOR-3 "gainsboro")
(define FLOOR-4 "light gray")
(define FLOOR-5 "silver")
(define FLOOR-6 "gray")
(define FLOOR-7 "dark gray")
(define FLOOR-8 "dim gray")
(define FLOOR-9 "black")

; An FSM is a [List-of Transition].
(define traffic-light-fsm `(,(make-transition RED GREEN)
                            ,(make-transition GREEN YELLOW)
                            ,(make-transition YELLOW RED)))

(define dark-elevator-fsm `(,(make-transition FLOOR-1 FLOOR-2)
                            ,(make-transition FLOOR-2 FLOOR-3)
                            ,(make-transition FLOOR-3 FLOOR-4)
                            ,(make-transition FLOOR-4 FLOOR-5)
                            ,(make-transition FLOOR-5 FLOOR-6)
                            ,(make-transition FLOOR-6 FLOOR-7)
                            ,(make-transition FLOOR-7 FLOOR-8)
                            ,(make-transition FLOOR-8 FLOOR-9)
                            ,(make-transition FLOOR-9 FLOOR-1)))
                            
; FSM FSM-State -> FSM-State
; matches the keys pressed by a player with the given FSM
(define (simulate fsm s0)
  (local [; State of the World: FSM-State
          ; FSM-State KeyEvent -> FSM-State
          (define (find-next-state s key-event)
            (find fsm s))]
    ; - IN -
    (big-bang s0
      [to-draw state-as-colored-square]
      [on-key find-next-state])))

; FSM-State -> Image
; renders current state as colored square
(check-expect (state-as-colored-square RED)
              (square 100 "solid" RED))
(define (state-as-colored-square s)
  (square 100 "solid" s))

; FSM FSM-State -> FSM-State
; finds the current state's successor in fsm
(check-expect (find traffic-light-fsm YELLOW) RED)
(check-error (find traffic-light-fsm "blue")
             "not found")
(define (find transitions current)
  (cond
    [(empty? transitions) (error "not found")]
    [else
     (local [(define s (first transitions))]
       ; - IN -
       (if (eq? (transition-current s) current)
           (transition-next s)
           (find (rest transitions) current)))]))


;; This program organization signals to a future reader
;; exactly the insights that the data analysis stage of
;; design recipe for world program finds:
;;
;; 1. the given representation of the finite state machine
;; remains unchanged.
;;
;; 2. what changes over the course of the simulation is
;; the current state of the finite machine (i.e s0 in
;; the big-bang expression).
