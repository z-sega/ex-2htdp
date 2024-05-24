;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-336) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct file [name size content])
; A File.v3 is a structure:
;   (make-file String N String)

(define-struct dir.v3 [name dirs files])
; A Dir.v3 is a structure: 
;   (make-dir.v3 String Dir* File*)
     
; A Dir* is one of: 
; – '()
; – (cons Dir.v3 Dir*)
     
; A File* is one of: 
; – '()
; – (cons File.v3 File*)

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

;; ex-336
;; Design the function how-many, which determines how many files
;; a given Dir.v3 contains. ex-335 provides you with data examples.
;; Compare your result with that of ex-333.

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
  (local (; Dir* -> N
          ; computes number of files in d*
          (define (how-many-dir* d*)
            (cond
              [(empty? d*) 0]
              [else (+ (how-many (first d*))
                       (how-many-dir* (rest d*)))]))

          ; File* -> N
          ; computes number of files in f*
          (define (how-many-file* f*) (length f*)))

    (+ (how-many-file* (dir.v3-files dir))
       (how-many-dir* (dir.v3-dirs dir)))))


;; Given the complexity of the data definition, contemplate how
;; anyone can design correct functions. Why are you confident that
;; how-many produces correct results?
;; ->
;; I am confident regardless of the complexity because of 2 reasons:
;; 1. the extensive test suite
;; 2. the natural mutual recursions in the definition of Dir.v3
;; were used to form the template employed during the design - the
;; number of recursive calls and the type of recursive call and the data
;; had to match the data definition.

;; systematic design is incredible
