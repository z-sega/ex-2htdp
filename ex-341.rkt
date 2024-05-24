;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-341) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

;; ex-341
;; Design du, a function that consumes a Dir and computes the total
;; size of all the files in the entire directory tree. Assume that
;; storing a directory in a Dir structure costs 1 file storage unit.
;; In the real world, a directory is basically a special file, and
;; its size depends on how large its associated directory is.


; Dir -> N
; computes the total size of all the files in the
; directory tree of dir

; nested directories have a size of 1
(define SUBDIR-SIZE 1)

(check-expect (du Code) (+ 8 2))
(check-expect (du Docs) 19)
(check-expect (du Libs) (+ SUBDIR-SIZE 8 2 SUBDIR-SIZE 19))
(check-expect (du Text) (+ 99 52 17))
(check-expect
 (du TS)
 (+ SUBDIR-SIZE 99 52 17 10 SUBDIR-SIZE SUBDIR-SIZE 8 2 1 19))

(define (du dir)
  (local (; [List-of Dir] -> N
          ; computes the total size of dl
          (define (size-of-dirs dl)
            (foldr (lambda (d acc)
                     (+ SUBDIR-SIZE (du d) acc)) 0 dl))

          ; [List-of File] -> N
          ; computes the total size of fl
          (define (size-of-files fl)
            (foldr (lambda (f acc)
                     (+ (file-size f) acc)) 0 fl)))
    (+ (size-of-dirs (dir-dirs dir))
       (size-of-files (dir-files dir)))))
