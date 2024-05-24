;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-337) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct file [name size content])
; A File.v3 is a structure:
;   (make-file String N String)

(define-struct dir.v3 [name dirs files])
; A Dir.v3 is a structure: 
;   (make-dir.v3 String [List-of Dir.v3] [List-of File.v3])

(define part1 (make-file "part1" 99 ""))
(define part2 (make-file "part2" 52 ""))
(define part3 (make-file "part3" 17 ""))
(define Text (make-dir.v3 "Text" '() (list part1 part2 part3)))

(define hang (make-file "hang" 8 ""))
(define draw (make-file "draw" 2 ""))
(define Code (make-dir.v3 "Code" '() (list hang draw)))

(define read!.1 (make-file "read!" 19 ""))
(define Docs (make-dir.v3 "Docs" '() (list read!.1)))

(define Libs (make-dir.v3 "Libs" (list Code Docs) '()))

(define read!.2 (make-file "read!" 10 ""))
(define TS (make-dir.v3 "TS" (list Text Libs) (list read!.2)))

(define Empty (make-dir.v3 "Empty" '() '()))

;; ex-337
;; Use List-of to simplify the data definition Dir.v3. Then use
;; ISL+'s list-processing functions from fig-95 and fig-96 to
;; simplify the function definitions(s) for the solution of
;; ex-336.

(require 2htdp/abstraction)

; Dir.v3 -> N
; computes the number of files in dir
(check-expect (how-many Empty) 0)
(check-expect (how-many Docs) 1)
(check-expect (how-many Code) 2)
(check-expect (how-many Libs) 3)
(check-expect (how-many Text) 3)
(check-expect (how-many TS) 7)

(define (how-many dir)
  (local (; [List-of Dir.v3] -> N
          ; computes the number of files in dl
          (define (how-many-dir* dl)
            (foldr (lambda (d acc)
                     (+ (how-many d) acc)) 0 dl)))
    (+ (length (dir.v3-files dir))
       (how-many-dir* (dir.v3-dirs dir)))))
