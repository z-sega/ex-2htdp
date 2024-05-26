;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-343) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

; A Path is [List-of String]
; *interpretation* directions into a directory tree
(define pathTSToPart1 '("TS" "Text" "part1"))
(define pathTSToCode '("TS" "Libs" "Code"))



; A [Maybe X] is one of:
; - #false
; - X
; e.g [Maybe Path]

; Dir String -> [Maybe Path]
; if (find? d f) is #true, computes a path to
; a file named f; otherwise #false
(check-expect (find Text "part2") '("Text" "part2"))
(check-expect (find TS "part2") '("TS" "Text" "part2"))
(check-expect (find TS "read!") '("TS" "read!"))
(check-expect (find TS "something") #false)
(check-expect (find Empty "read!") #false)

(define (find d f)
  (local (; [List-of File] -> Path
          ; computes path to f from fl
          (define (path-in-files fl)
            (foldr (lambda (file acc)
                     (if (equal? (file-name file) f)
                         (list (file-name file))
                         acc)) '() fl))

          ; [List-of Dir] -> [Maybe Path]
          ; computes path to f from dl
          (define (path-in-dirs dl)
            (foldr (lambda (dir acc)
                     (if (find? dir f) (find dir f) acc)) '() dl)))

    (if (find? d f)
        (local ((define path-from-files (path-in-files (dir-files d)))
                (define path-from-dirs (path-in-dirs (dir-dirs d))))
          (cons (dir-name d)
                (cond
                  [(not (empty? path-from-files)) path-from-files]
                  [(not (empty? path-from-dirs)) path-from-dirs])))
        #false)))

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

;; ex-343
;; Design the function ls-R, which lists the paths to all files
;; contained in a given Dir.

(require 2htdp/abstraction)

; Dir -> [List-of Path]
; lists the paths of all files in dir
(check-expect (ls-R Code) '(("Code" "hang")
                            ("Code" "draw")))
(check-expect (ls-R Libs) '(("Libs" "Code" "hang")
                            ("Libs" "Code" "draw")
                            ("Libs" "Docs" "read!")))
(check-expect (ls-R TS) '(("TS" "read!")
                          ("TS" "Text" "part1")
                          ("TS" "Text" "part2")
                          ("TS" "Text" "part3")
                          ("TS" "Libs" "Code" "hang")
                          ("TS" "Libs" "Code" "draw")
                          ("TS" "Libs" "Docs" "read!")))

(define (ls-R dir)
  (local (; [List-of Dir] -> [List-of Path]
          ; lists the paths in dl
          (define (paths-in-dirs dl)
            (foldr (lambda (d acc)
                     (append (ls-R d) acc)) '() dl))

          ; [List-of File] -> [List-of Path]
          ; lists the paths of fl
          (define (paths-for-files fl)
            (map (lambda (f) (list (file-name f))) fl)))
    (append (for/list ([path (paths-for-files (dir-files dir))])
              (append (list (dir-name dir)) path))
            (for/list ([path (paths-in-dirs (dir-dirs dir))])
              (append (list (dir-name dir)) path)))))
