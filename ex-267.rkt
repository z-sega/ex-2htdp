;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-267) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-267
;; Use map to define the function convert-euro, which
;; converts a list of US$ amounts into a list of €
;; amounts based on an exchange rate of US$1.06 per
;; € (on April 13, 2017).

; [X Y] [X -> Y] [List-of X] -> [List-of Y]
; X <- Number
; Y <- Number
; need a function that converts dollar to euro
; (Number -> Number) then use with map

(define US-DOLLAR->EURO 1.06)

; [List-of Number] -> [List-of Number]
; convert a list of US$ amounts into a list of
; € amounts
(check-expect (convert-euro (list 1.06 2.12))
              (list 1 2))
(define (convert-euro lon)
  (local (; Number -> Number
          ; convert us-dollar to euro
          ; 1.06 -> 1
          ; n -> 
          (define (us-dollar->euro n)
            (* (/ n US-DOLLAR->EURO))))
    (map us-dollar->euro lon)))
          

;; Also use map to define convertFC, which converts
;; a list of Fahrenheit measurements to a list
;; of Celsius measurements.

; [List-of Number] -> [List-of Number]
; convert a list of F measurements to
; deg-celsius measurements
(check-expect (convertFC (list 32 212 14 68))
              (list 0 100 -10 20))
(define (convertFC lon)
  (local (; Number -> Number
          ; convert a Fahrenheit measure to Celsius
          (define (f->c f)
            (* (- f 32)
               (/ 5 9))))
    (map f->c lon)))

;; Finally, try your hand at translate, a function
;; that translates a list of Posns into a list of
;; lists of pairs of numbers.

; [X Y] [X -> Y] [List-of X] -> [List-of Y]

; [Pair-of Number] is (cons Number (cons Number '()))

; [List-of Posn] -> [List-of [Pair-of Number]]
; translates a list of Posns into a list of lists
; of pairs of numbers.
(check-expect (translate (list (make-posn 20 30)
                               (make-posn 49 39)))
              (list (list 20 30)
                    (list 49 39)))
(define (translate lop)
  (local (; Posn -> [Pair-of Number]
          ; translates a Posn to a list of two
          ; numbers: the x and y coord.
          (define (posn->pairing p)
            (list (posn-x p) (posn-y p))))
    (map posn->pairing lop)))