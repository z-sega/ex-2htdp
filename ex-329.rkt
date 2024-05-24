;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-329) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-329
;; How many times does a file named read! occur in the directory
;; tree TS?
;; -> twice

;; Can you describe the path from the root directory to
;; the occurences
;; -> in TS->read!, and in TS->Libs->Docs->read!

;; What is the total size of all the files in the tree?
(+ 10   ;; read!
   99   ;; part1
   52   ;; part2
   17   ;; part3
   8    ;; hang
   2    ;; draw
   19)  ;; read!

;; What is the total size of the directory if each
;; directory node has size 1?
(define Code (+ 1 8 2))
(define Docs (+ 1 19))
(define Text (+ 1 99 52 17))
(define Libs (+ 1 Code Docs))
(define TS (+ 1 Text 10 Libs))
 
TS

;; How many levels of directories does it contain? 
(+ 1  ;; TS
   1  ;; Text and Libs
   1) ;; Code and Docs
