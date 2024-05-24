;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-331) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A Dir.v1 (short for directory) is one of:
; - '()
; - (cons File.v1 Dir.v1)
; - (cons Dir.v1 Dir.v1)
;
; A File.v1 is a String

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


;; ex-331
;; Design the function how-many, which determines how many files
;; a given Dir.v1 contains. Remember to follow the design recipe;
;; ex-330 provides you with data examples.

(require 2htdp/abstraction)

; Dir.v1 -> N
; computes the number of files in dir
(check-expect (how-many Docs) 1)
(check-expect (how-many Code) 2)
(check-expect (how-many Libs) 3)
(check-expect (how-many Text) 3)
(check-expect (how-many TS) 7)

(define (how-many dir)
  (match dir
    [(? empty?) 0]
    [(cons (? string?) sub-dir-rst) (+ 1 (how-many sub-dir-rst))]
    [(cons sub-dir-fst sub-dir-rst) (+ (how-many sub-dir-fst)
                                       (how-many sub-dir-rst))]))