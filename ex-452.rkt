;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-452) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(define NEWLINE "\n")

;; A File is one of:
;; - '()
;; - (cons NEWLINE File)
;; - (cons 1String File)
;; interpretation:
;; represents the content of a file
;; "\n" is the newline character
(define file1 '())
(define file2 '("\n"))
(define file3 '("\n" "\n"))
(define file4
  (list "a" "b" "c" "\n"
        "d" "e" "\n"
        "f" "g" "h" "\n"))

;; A Line is a [List-of 1String]

;; [List-of Line]
(define list-of-line1 '())
(define list-of-line2 (list '()))
(define list-of-line3 (list '()
                            '()))
(define list-of-line4
  (list (list "a" "b" "c")
        (list "d" "e")
        (list "f" "g" "h")))


;; File -> [List-of Line]
;; converts a file into a list of lines.
;; how:
;; conses the initial segment of afile as a single
;; line to the list of Lines that result from the rest
;; of afile.
;; termination:
;; every recursive application consumes a list
;; that is strictly shorter than the the given one,
;; so the recursive process stops when it reaches '().
(check-expect (file->list-of-lines file1)
              list-of-line1)
(check-expect (file->list-of-lines file2)
              list-of-line2)
(check-expect (file->list-of-lines file3)
              list-of-line3)
(check-expect (file->list-of-lines file4)
              list-of-line4)

(define (file->list-of-lines afile)
  (cond [(empty? afile) '()]
        [else (cons (first-line afile)
                    (file->list-of-lines
                     (remove-first-line afile)))]))


;; File -> Line
;; retrieves the prefix of afile up to the first
;; occurrence of NEWLINE
(check-expect (first-line file1) '())
(check-expect (first-line file2) '())
(check-expect (first-line file3) '())
(check-expect (first-line file4) '("a" "b" "c"))

(define (first-line afile)
  (cond
    [(empty? afile) '()]
    [(string=? (first afile) NEWLINE) '()]
    [else (cons (first afile)
                (first-line (rest afile)))]))

;; File -> File
;; drops the prefix of afile up to the first
;; occurence of NEWLINE
(check-expect (remove-first-line file1) '())
(check-expect (remove-first-line file2) '())
(check-expect (remove-first-line file3) (list "\n"))
(check-expect (remove-first-line file4)
              (list "d" "e" "\n" "f" "g" "h" "\n"))

(define (remove-first-line afile)
  (cond
    [(empty? afile) '()]
    [(string=? (first afile) NEWLINE) (rest afile)]
    [else (remove-first-line (rest afile))]))


