;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-332) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct dir [name content])

; A Dir.v2 is a structure: 
;   (make-dir String LOFD)
 
; An LOFD (short for list of files and directories) is one of:
; – '()
; – (cons File.v2 LOFD)
; – (cons Dir.v2 LOFD)
 
; A File.v2 is a String.


;; ex-332
;; Translate the directory tree in fig-123 into a data representation
;; according to model 2.

(define hang "")
(define draw "")
(define Code (make-dir "Code" (list hang draw)))

(define read!.1 "")
(define Docs (make-dir "Docs" (list read!.1)))

(define Libs (make-dir "Libs" (list Code Docs)))

(define part1 "")
(define part2 "")
(define part3 "")
(define Text (make-dir "Text" (list part1 part2 part3)))

(define read!.2 "")
(define TS (make-dir "TS" (list Text read!.2 Libs)))
