;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-334) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-334
;; Show how to equip a directory with two more attributes: size and
;; readability. The former measure how much space the directory
;; itself (as opposed to its content) consumes; the latter
;; specifies whether anyone else besides the user may browse the
;; content of the directory.

(define-struct dir [name content size readability])
; A Dir.v2 is a structure: 
;   (make-dir String LOFD Number Boolean)
; *interpretation*
; (make-dir "Documents" (list "some-file" "some-dir") 19 #t)
; describes a directory named Documents containing "some-file" and
; "some-dir", the size of Documents is 19, and others besides the
; user are able to browse its contents.
 
; An LOFD (short for list of files and directories) is one of:
; – '()
; – (cons File.v2 LOFD)
; – (cons Dir.v2 LOFD)
 
; A File.v2 is a String.

(define hang "")
(define draw "")
(define Code (make-dir "Code" (list hang draw) 11 #f))

(define read!.1 "")
(define Docs (make-dir "Docs" (list read!.1) 20 #t))

(define Libs (make-dir "Libs" (list Code Docs) 32 #t))

(define part1 "")
(define part2 "")
(define part3 "")
(define Text (make-dir "Text" (list part1 part2 part3) 169 #t))

(define read!.2 "")
(define TS (make-dir "TS" (list Text read!.2 Libs) 212 #t))

(define Empty (make-dir "Empty" '() 1 #t))