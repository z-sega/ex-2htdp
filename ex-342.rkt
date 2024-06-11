;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-342) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

;; ex-342
;; Design find. The function consumes a directory d and a
;; file name f. If (find? d f) is #true, find produces a
;; path to a file with name f; otherwise it produces #false
;;
;; *Hint*
;; While it is tempting to first check whether the file name
;; occurs in the directory tree, you have to do so for
;; every single sub-directory. Hence it is better to combine
;; the functionality of find? and find.

(require 2htdp/abstraction)

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


;; *Challenge*
;; The find function discovers only one of the two files named
;; read! in fig-123. Design find-all, which generalizes find
;; and produces the list of all paths that lead to f in
;; d. What should find-all produce when (find? d f) is #false?
;; Is this part of the problem really a challenge compared to
;; the basic problem?

; Dir String -> [List-of Path]
; computes the list of all paths that
; lead to f in d
(check-expect (find-all Text "part2") '(("Text" "part2")))
(check-expect (find-all TS "part2") '(("TS" "Text" "part2")))
(check-expect (find-all TS "read!") '(("TS" "read!")
                                      ("TS" "Libs" "Docs" "read!")))
(check-expect (find-all TS "something") '())
(check-expect (find-all Empty "read!") '())

(define (find-all d f)
  (local (; Dir -> [List-of Path]
          ; computes a list of paths from d to f
          (define (find-all-dir d)
            (local (;; compute search for (dir-dirs d)
                    (define found-in-dirs
                      (find-all-dirs (dir-dirs d)))
                    ;; append (dir-name d) to search result
                    (define dir-name+found-in-dirs
                      (map (lambda (p) (cons (dir-name d) p))
                           (filter cons? found-in-dirs))))
              (if (find? d f)
                  (if (find-all-files? (dir-files d))
                      (cons (list (dir-name d) f)
                            dir-name+found-in-dirs)
                      dir-name+found-in-dirs)
                  '())))

          ; [List-of Dir] -> [List-of Path]
          ; computes a list of paths from d to f
          ; for all d in dl
          (define (find-all-dirs dl)
            (foldr (lambda (d0 acc) (if (find? d0 f)
                                        (append (find-all-dir d0) acc)
                                        acc)) '() dl))

          ; [List-of File] -> Boolean
          ; #t if f is in fl
          (define (find-all-files? fl)
            (ormap (lambda (f-name) (equal? f-name f))
                   (map file-name fl))))
    (find-all-dir d)))

       
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
            (ormap (lambda (f-name) (equal? f-name s))
                   (map file-name fl))))
    (or (in-dirs? (dir-dirs dir))
        (one-of-files? (dir-files dir)))))