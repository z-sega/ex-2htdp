;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-338) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require htdp/dir)

(define part1 (make-file "part1" 99 ""))
(define part2 (make-file "part2" 52 ""))
(define part3 (make-file "part3" 17 ""))
(define Text (make-dir "Text" '() (list part1 part2 part3)))

(define hang (make-file "hang" 8 ""))
(define draw (make-file "draw" 2 ""))
(define Code (make-dir "Code" '() (list hang draw)))

(define read!.1 (make-file "read!" 19 ""))
(define Docs (make-dir "Docs" '() (list read!.1)))

(define Libs (make-dir "Libs" (list Code Docs) '()))

(define read!.2 (make-file "read!" 10 ""))
(define TS (make-dir "TS" (list Text Libs) (list read!.2)))

(define Empty (make-dir "Empty" '() '()))
(define NestedEmpty (make-dir "EmptyParent" (list Empty) '()))


; Dir -> N
; computes the number of files in dir
(check-expect (how-many Empty) 0)
(check-expect (how-many NestedEmpty) 0)
(check-expect (how-many Docs) 1)
(check-expect (how-many Code) 2)
(check-expect (how-many Libs) 3)
(check-expect (how-many Text) 3)
(check-expect (how-many TS) 7)

(define (how-many dir)
  (local (; [List-of Dir] -> N
          ; computes the number of files in dl
          (define (how-many-dir* dl)
            (foldr (lambda (d acc)
                     (+ (how-many d) acc)) 0 dl)))
    (+ (length (dir-files dir))
       (how-many-dir* (dir-dirs dir)))))


;; ex-338
;; Use create-dir to turn some of your directories into ISL+
;; data representations. Then use how-many from ex-336 to count
;; how many files they contain. Why are you confident that
;; how-many produces correct results for these directories?

(define ex1
  (create-dir "/Users/ayo/Playground/racket/program-design/files/"))
(define ex2
  (create-dir "/Users/ayo/Playground/racket/program-design/media/"))

(check-expect (how-many ex1) 1)
(check-expect (how-many ex2) 3)

;; I am confident in the results because the data representation
;; matches the template that was used to design the function, the
;; extensive test suite, and I just checked the folders to ensure
;; the file count was accurate in both of them.