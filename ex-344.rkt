;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-344) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

(define SameName (make-dir "SameName" '() (list draw)))
(define Nesting (make-dir "Nesting" (list SameName) '()))
(define SomeDir (make-dir "SomeDir" (list SameName Nesting) '()))

; A Path is [List-of String]
; *interpretation* directions into a directory tree
(define pathTSToPart1 '("TS" "Text" "part1"))
(define pathTSToCode '("TS" "Libs" "Code"))

;; ex-344
;; Redesign find-all from ex-342 using ls-R from ex-343.
;; This is design by composition, and if you solved the challenge
;; part of ex-342 your new function can find directories, too.

(require 2htdp/abstraction)

; Dir -> [List-of Path]
; lists the paths of all files in dir
(check-expect (ls-R Code) '(("Code")
                            ("Code" "hang")
                            ("Code" "draw")))
(check-expect (ls-R Libs) '(("Libs")
                            ("Libs" "Code")
                            ("Libs" "Code" "hang")
                            ("Libs" "Code" "draw")
                            ("Libs" "Docs")
                            ("Libs" "Docs" "read!")))
(check-expect (ls-R TS) '(("TS")
                          ("TS" "read!")
                          ("TS" "Text")
                          ("TS" "Text" "part1")
                          ("TS" "Text" "part2")
                          ("TS" "Text" "part3")
                          ("TS" "Libs")
                          ("TS" "Libs" "Code")
                          ("TS" "Libs" "Code" "hang")
                          ("TS" "Libs" "Code" "draw")
                          ("TS" "Libs" "Docs")
                          ("TS" "Libs" "Docs" "read!")))
(check-expect (ls-R SomeDir) '(("SomeDir")
                               ("SomeDir" "SameName")
                               ("SomeDir" "SameName" "draw")
                               ("SomeDir" "Nesting")
                               ("SomeDir" "Nesting" "SameName")
                               ("SomeDir" "Nesting" "SameName" "draw")))

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
    (append (list (list (dir-name dir)))
            (for/list ([path (paths-for-files (dir-files dir))])
              (append (list (dir-name dir)) path))
            (for/list ([path (paths-in-dirs (dir-dirs dir))])
              (append (list (dir-name dir)) path)))))


; Dir String -> [List-of Path]
; computes the list of all paths that
; lead to f/d (short for file or directory) in d
(check-expect (find-all Text "part2") '(("Text" "part2")))
(check-expect (find-all TS "part2") '(("TS" "Text" "part2")))
(check-expect (find-all TS "read!") '(("TS" "read!")
                                      ("TS" "Libs" "Docs" "read!")))
(check-expect (find-all TS "something") '())
(check-expect (find-all Empty "read!") '())
;; finding directories!
;; TODO: update ls-R to include path to directories
(check-expect (find-all TS "Code") '(("TS" "Libs" "Code")))
(check-expect (find-all SomeDir "SameName")
              '(("SomeDir" "SameName")
                ("SomeDir" "Nesting" "SameName")))

(define (find-all d f/d)
  (filter (lambda (p0)
           (local ((define path-dest (first (reverse p0))))
             (equal? path-dest f/d))) (ls-R d)))
       
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
            (foldr (lambda (d acc) (or (find? d s) acc)) #f dl))

          ; [List-of File] -> Boolean
          ; #t if file names s occurs in fl
          (define (one-of-files? fl)
            (ormap (lambda (f-name) (equal? f-name s))
                   (map file-name fl))))
    (or (in-dirs? (dir-dirs dir))
        (one-of-files? (dir-files dir)))))