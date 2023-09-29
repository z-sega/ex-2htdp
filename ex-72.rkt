#lang htdp/bsl

; Data definitions are very important
; Even more so when it comes to structure definitions
; Notice how the same ball structure could have
; 2 very different data definitions.

(define-struct ball [location velocity])

; A Ball-1d is a structure:
;   (make-ball Number Number)
; *interpretation 1* distance to top and velocity
; *interpretation 2* distance to left and velocity

; A Ball-2d is a structure:
;   (make-ball Posn Vel)
; *interpretation* a 2-dimensional position and velocity

; Posn is built-in, but Vel is not an deserves its own
; data definition.
(define-struct vel [deltax deltay])
; A Vel is a structure:
;   (make-vel Number Number)
; *interpretation* (make-vel dx dy) means a velocity of
; dx pixels [per tick] along the horizontal and
; dy pixels [per tick] along the vertical direction

; ---------------- ex-72.rkt

(define-struct phone [area number])

; A Phone is a structure:
;   (make-phone Number String)
; *interpretation* (make-phone area number) instantiates
; a phone-number where:
; area is the area-code
; number is the phone-number

(define-struct phone# [area switch num])
; A phone# is a structure:
;   (make-phone# Number Number Number)
; *interpretation*
; (make-phone# area switch num) makes a phone# where:
; - area is the area-code [000, 999]
; - switch is the switch-code [000, 999]
; - num is the phone-number [0000, 9999]

