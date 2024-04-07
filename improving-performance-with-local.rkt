;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname improving-performance-with-local) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; performance improvements with (local [def ...] expression)

(define list1 '(4 5 55 40 48 28 482 49
                  53 4 4 53 4 69 90 2 1 5))

;; consider this:

; [NEList-of Number] -> Number
; determines the smallest number on l
(check-expect (inf list1) 1)
(define (inf l)
  (cond
    [(empty? (rest l)) (first l)]
    [else (if (< (first l) (inf (rest l)))
              (first l)
              (inf (rest l)))]))

;; improved with local like this:
;; -> because (inf (rest l)) is evaluated once while the body
;; of the local expression refers to the result twice 
;; (instead of being evaluated twice)

; [NEList-of Number] -> Number
; determines the smallest number on l
(check-expect (inf.v2 list1) 1)
(define (inf.v2 l)
  (cond
    [(empty? (rest l)) (first l)]
    [else (local [(define smallest-in-rest
                    (inf.v2 (rest l)))]
            ; - IN -
            (if (< (first l) smallest-in-rest)
                (first l)
                smallest-in-rest))]))
  

; Benchmark:
(time (inf list1))
(time (inf.v2 list1))

(define list2 '(4 5 55 40 48 28 482 49
                  5 55 40 48 28 482 49
                  5 55 40 48 28 482 49
                  5 55 40 48 28 482 49
                  5 55 40 48 28 482 49
                  5 55 40 48 28 482 49
                  5 55 40 48 28 482 49
                  5 55 40 48 28 482 49
                  5 55 40 48 28 482 49
                  5 55 40 48 28 482 49
                  5 55 40 48 28 482 49
                  5 55 40 48 28 482 49
                  53 4 4 53 4 69 90 2 1 5))

(time (inf.v2 list2)) ; the performance improvement is unreal