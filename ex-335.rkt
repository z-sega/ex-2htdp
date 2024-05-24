;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-335) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

;; ex-335
;; Translate the directory tree in fig-123 into a data
;; representation according to model 3. Use "" for the
;; content of files.

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
