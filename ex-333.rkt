;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-333) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct dir [name content])

; A Dir.v2 is a structure: 
;   (make-dir String LOFD)
 
; An LOFD (short for list of files and directories) is one of:
; – '()
; – (cons File.v2 LOFD)
; – (cons Dir.v2 LOFD)
 
; A File.v2 is a String.

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

(define Empty (make-dir "Empty" '()))

;; ex-333
;; Design the function how-many, which determines how many files a
;; given Dir.v2 contains. Exercise 332 provides you with data
;; examples. Compare your result with that of exercise 331.

(require 2htdp/abstraction)

; Dir.v2 -> N
; computes the number of files in dir
(check-expect (how-many Empty) 0)
(check-expect (how-many Docs) 1)
(check-expect (how-many Code) 2)
(check-expect (how-many Libs) 3)
(check-expect (how-many Text) 3)
(check-expect (how-many TS) 7)

(define (how-many dir)
  (local (; LOFD -> N
          ; computes the number of files in lofd
          (define (n-files-in lofd)
            (match lofd
              [(? empty?) 0]
              [(cons (? string?) rst-lofd) (+ 1 (n-files-in rst-lofd))]
              [(cons dir rst-lofd) (+ (how-many dir)
                                      (n-files-in rst-lofd))])))
    (n-files-in (dir-content dir))))
