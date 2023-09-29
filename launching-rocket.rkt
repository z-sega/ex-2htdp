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


; An LR (short for launching rocket) is one of:
; - "resting"
; - NonnegativeNumber
; *interpretation*
; "resting" represents a grounded rocket
; a number denotes the height of a rocket in flight


