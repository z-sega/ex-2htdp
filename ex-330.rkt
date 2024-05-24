;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-330) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A Dir.v1 (short for directory) is one of:
; - '()
; - (cons File.v1 Dir.v1)
; - (cons Dir.v1 Dir.v1)
;
; A File.v1 is a String

;; ex-330
;; Translate the directory tree in fig-123 into a data
;; representation according to model 1.

(define hang "")
(define draw "")
(define Code (list hang draw))

(define read!.1 "")
(define Docs (list read!.1))

(define Libs (list Code Docs))

(define part1 "")
(define part2 "")
(define part3 "")
(define Text (list part1 part2 part3))

(define read!.2 "")
(define TS (list Text read!.2 Libs))
