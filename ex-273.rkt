;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex-273) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-273
;; The fold functions are so powerful that you can
;; define almost any list processing functions with them.
;; Use fold to define map.

; foldr
; [X Y -> Y] Y [List-of X] -> Y

; map
; [X -> Z] [List-of X] -> [List-of Z]

; To instantiate map with foldr, we need to find the
; class of X and Y such that Y is a [List-of Z]

; [X [List-of Z] -> [List-of Z]]
;   [List-of Z] [List-of X] -> [List-of Z]
(check-expect (map-from-foldr add1 '() '(0 1 2))
              '(1 2 3))
(check-expect (map-from-foldr list-with-fish
                              '()
                              '(0 1 2))
              `(,'("fish" 0)
                ,'("fish" 1)
                ,'("fish" 2)))
(define (map-from-foldr f base l)
  (local (; X [List-of Z] -> [List-of Z]
          ; given x and lz
          ; construct a list by adding (f x)
          ; on lz
          (define (traverse x lz)
            (cons (f x) lz)))
    (foldr traverse base l)))

(check-expect (list-with-fish "cow")
              (list "fish" "cow"))
(define (list-with-fish x)
  (cons "fish"
        (cons x '())))
