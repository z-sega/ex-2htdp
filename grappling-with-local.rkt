#lang htdp/isl

;; ----------------------------------
;; Organizing a function with 'local'

(define-struct address [first-name last-name street])
; An Addr is a structure:
;   (make-address String String String)
; *interpretation* associates an address with a person's name
(define a1 (make-address "Robert"   "Findler" "South"))
(define a2 (make-address "Matthew"  "Flatt"   "Canyon"))
(define a3 (make-address "Shriram"  "Krishna" "Yellow"))

; [List-of Addr]
(define ex0
  (list a1 a2 a3))        

; [List-of Addr] -> String
; creates a string of first names,
; sorted in alphabetical order,
; separated and surrounded by blank spaces
(check-expect (listing.v2 ex0) " Matthew Robert Shriram ")
(define (listing.v2 l)
  (local (; 1. extract names
          (define names (map address-first-name l))
          
          ; 2. sort the names
          (define sorted-names (sort names string<?))
          
          ; 3. append them, add spaces
          (define concat+spaces
            (local (; String String -> String
                    ; appends two strings, prefix with " "
                    (define (helper s t)
                      (string-append " " s t)))
              (foldr helper " " sorted-names))))
    concat+spaces))

;; The visually most appealing difference concerns the
;; overall organization. It clearly brings across that the
;; function achieves three tasks and in which order.
;; As a matter of fact, this example demonstrates a general
;; principle of readability:
;;
;; Use 'local' to reformulate deeply nested expressions.
;; Use well-chosen names to express what the expressions
;; compute.
;;
;; Future readers appreciate it because they can
;; comprehend the code by looking at just the names and
;; the body of the 'local' expression.

;; ---------------------------------------------------
;; Organizing interconnected function definitions with
;; 'local'

; [List-of Number] [Number Number -> Boolean]
; -> [List-of Number]
; produces a version of alon0, sorted according to cmp
(check-expect (sort-cmp (list 4 5 2 1) <)
              (list 1 2 4 5))
(define (sort-cmp alon0 cmp)
  (local (; [List-of Number] -> [List-of Number]
          ; produces the sorted version of alon
          (define (isort alon)
            (cond
              [(empty? alon) '()]
              [else (insert (first alon)
                            (isort (rest alon)))]))

          ; Number [List-of Number] -> [List-of Number]
          ; inserts n into the sorted list of numbers
          ; alon
          (define (insert n alon)
            (cond
              [(empty? alon) (cons n '())]
              [else (if (cmp n (first alon))
                        (cons n alon)
                        (cons (first alon)
                              (insert n (rest alon))))])))
    (isort alon0)))

