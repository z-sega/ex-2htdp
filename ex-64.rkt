;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex-64) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; posn -> Number
; computes the manhattan-distance of a point ap
; from the origin
(check-expect (manhattan-distance-to-origin
               (make-posn 0 4))
               4)
(check-expect (manhattan-distance-to-origin
               (make-posn 3 0))
               3)
(check-expect (manhattan-distance-to-origin
               (make-posn 4 5))
              9)
(define (manhattan-distance-to-origin ap)
  (+ (posn-x ap)
     (posn-y ap)))