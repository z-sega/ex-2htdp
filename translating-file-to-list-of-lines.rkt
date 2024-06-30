;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname translating-file-to-list-of-lines) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

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

;; Describing the parsing process:
;; (1) The problem is trivially solvable if the file is
;;     '()
;; (2) In that case, the file doesn't contain a line.
;; (3) Otherwise, the file contains at least one "\n"
;;     or some other 1String. These items - up to and
;;     including the first "\n", if any - must be
;;     separated from the rest of the File. The
;;     remainder is a new problem of the same kind that
;;     file->list-of-lines can solve.
;; (4) It then suffices to cons the initial segment as
;;     a single line to the [List-of Line] that result
;;     from the rest of the File.

;; B'cos the separation of the initial segment
;; from the rest of the file requires a scan of an
;; arbitrarily long list of 1Strings, we put two
;; auxilliary functions on our wish list:
;; (1) first-line, which collects all 1Strings up to,
;;     but excluding, the first occurrence of "\n" or
;;     the end of the list;
;; (2) and remove-first-line, which removes the very
;;     same items that first-line collects.

;; File -> [List-of Line]
;; converts a file into a list of lines
;; termination:
;; every recursive application consumes a list
;; that is strictly shorter than the the given one,
;; so the recursive process stops when it reaches '()
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


