;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-382) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

;; ex-382
;; Formulate an XML configuration for the BW machine,
;; which switches from white to black and back for
;; every key event. Translate the XML configuration
;; into an XMachine representation. See ex-227 for
;; an implementation of the machine as a program.

; An FSM is a [List-of 1Transition]
; A 1Transition is a list of two items:
;  (list FSM-State FSM-State)
; *intepretation*
; '("red" "green") means transition from red->green 
; An FSM-State is a String that specifies a color

; data examples
(define fsm-traffic
  '(("red" "green")
    ("green" "yellow")
    ("yellow" "red")))

(define fsm-bw
  '(("black" "white")
    ("white" "black")))

; An XMachine is a nested list of this shape:
; (cons 'machine (cons `((initial ,FSM-State)) [List-of X1T]))
;
; An X1T is a nested list of this shape:
; `(action ((state ,FSM-State) (next ,FSM-State)))

(define bw-config
  '(machine ((initial "black"))
            (action ((state "black") (next "white")))
            (action ((state "white") (next "black")))))

(define FONT-SIZE 24)
(define FONT-COLOR 'black)

; FSM-State FSM -> FSM-State
; matches the keys pressed by a player with the given FSM
(define (simulate state0 transitions)
  (big-bang state0 ; FSM-State
    [to-draw (lambda (current)
               (square 100 "solid" current))]
    [on-key (lambda (current key-event)
              (find transitions current))]))


; [X Y] [List-of [List X Y]] X -> Y
; finds the matching Y for the given X in alist
(check-expect (find fsm-traffic "red") "green")
(check-expect (find fsm-bw "black") "white")
(check-error (find fsm-traffic "blue") "not found")
(check-error (find '() "red") "not found")

(define (find alist x)
  (local ((define fm (assoc x alist)))
    (if (cons? fm) (second fm) (error "not found"))))