#lang htdp/bsl

; ------- ex-77.rkt

(define-struct time [hours minutes seconds])
; A Time is a structure:
;   (make-time Number Number Number)
; 
; *intepretation*
; (make-time h m s) is a point in time since
; midnight at h hours, m minutes, and s seconds.
; 
; *intervals*
; hours - [00, 23]
; minutes - [00, 59]
; seconds - [00, 59]

; ------- ex-81.rkt

; Design the function time->seconds, which consumes instances
; of time structures and produces the number of seconds that
; have passed since midnight. For example, if you are
; representing 12 hours, 30 minutes, and 2 seconds with one
; of these structure and if you then apply time->seconds
; to this instance, the correct result is 45002.

; Number is used to represent 'seconds

; Number -> Number
; computes the number of seconds from a given
; number of hours
(check-expect (hours->seconds 2) (* 2 60 60))
(define (hours->seconds h)
  (* h 60 60))

; Number -> Number
; computes the number of seconds from a given
; number of minutes
(check-expect (minutes->seconds 2) (* 2 60))
(define (minutes->seconds m)
  (* m 60))

; Time -> Number
; computes the number of seconds since midnight from
; a given time t
(check-expect (time->seconds (make-time 0 0 5)) 5)
(check-expect (time->seconds (make-time 0 5 0)) 300)
(check-expect (time->seconds (make-time 1 0 0)) 3600)
(check-expect (time->seconds
               (make-time 12 30 2))
              45002)
(define (time->seconds t)
  (+
   (hours->seconds (time-hours t))
   (minutes->seconds (time-minutes t))
   (time-seconds t)))

