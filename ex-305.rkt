;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-305) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
;; ex-305
;; Use loops to define convert-euro. See ex-267
(require 2htdp/abstraction)

(define US-DOLLAR->EURO 1.06)

; [List-of Number] -> [List-of Number]
; convert a list of US$ amounts into a list of
; € amounts
(check-expect (convert-euro (list 0.00 1.06 2.12))
              (list 0 1 2))
(define (convert-euro lon)
  (for/list ([e lon]) (/ e US-DOLLAR->EURO)))

