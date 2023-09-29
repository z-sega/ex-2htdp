#lang htdp/bsl

(define-struct time [hours minutes seconds])
; Time is (make-time Number Number Number)
; 
; *intepretation*
; (make-time h m s) is a point in time since
; midnight at h hours, m minutes, and s seconds.
; 
; *intervals*
; hours - [00, 23]
; minutes - [00, 59]
; seconds - [00, 59]
