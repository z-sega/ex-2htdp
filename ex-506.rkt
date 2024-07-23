;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-506) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-506
;; Design an accumulator-style version of map.

; [X -> Y] [List-of X] -> [List-of Z]
; constructs a new list by applying function f
; to each item on l0
(check-expect (my-map (lambda (x) x) '(0 1 2 3))
              '(0 1 2 3))
(check-expect (my-map integer->char '(0 1 2 3))
              (map integer->char '(0 1 2 3)))

(define (my-map f l0)
  (local [; [List-of X] [List-of Z] -> [List-of Z]
          ; applies f to each item on l
          ; accumulator: a is a list of items
          ; of l0 not on l with f applied.
          (define (map/a l a)
            (cond
              [(empty? l) a]
              [else
               (map/a (rest l)
                      (cons (f (first l)) a))]))]
    (map/a (reverse l0) '())))