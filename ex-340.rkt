;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-340) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

;; ex-340
;; Design the function ls, which lists the names of all files
;; and directories in a given Dir.


; Dir -> [List-of String]
; lists the names of all files and directories in dir
(check-expect (ls Code) '("hang" "draw"))
(check-expect (ls Docs) '("read!"))
(check-expect (ls Libs) '("Code" "Docs"))
(check-expect (ls TS) '("read!" "Text" "Libs"))
(check-expect (ls Text) '("part1" "part2" "part3"))
(check-expect (ls Empty) '())
(check-expect (ls NestedEmpty) '("Empty"))

(define (ls dir)
  (append (map file-name (dir-files dir))
          (map dir-name (dir-dirs dir))))
  