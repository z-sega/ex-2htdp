;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-339) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

;; ex-339
;; Design find?. The function consumes a Dir and a file name
;; and determines whether or not a file with this name occurs
;; in the directory tree.


; Dir String -> Boolean
; #t if a file named s occurs in dir
(check-expect (find? Code "hang") #t)
(check-expect (find? Libs "hang") #t)
(check-expect (find? TS "hang") #t)
(check-expect (find? Text "hang") #f)
(check-expect (find? Text "draw") #f)
(check-expect (find? Text "part2") #t)
(check-expect (find? TS "part2") #t)
(check-expect (find? Empty "draw") #f)
(check-expect (find? NestedEmpty "draw") #f)

(define (find? dir s)
  (local (; [List-of Dir] -> Boolean
          ; #t if file named s occurs in dl
          (define (in-dirs? dl)
            (foldr (lambda (d acc)
                     (or (find? d s) acc)) #f dl))

          ; [List-of File] -> Boolean
          ; #t if file names s occurs in fl
          (define (one-of-files? fl)
            (foldr (lambda (f acc)
                     (or (equal? (file-name f) s) acc)) #f fl)))
    (or (in-dirs? (dir-dirs dir))
        (one-of-files? (dir-files dir)))))

