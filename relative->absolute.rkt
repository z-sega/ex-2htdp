;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname relative->absolute) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of Number] -> [List-of Number]
; converts a list of relative to absolute distances
; the first number represents the distance to the origin
(check-expect (relative->absolute '(50 40 70 30 30))
              '(50 90 160 190 220))

(define (relative->absolute l)
  (cond [(empty? l) '()]
        [else (local [(define rest-of-l
                        (relative->absolute (rest l)))
                      (define adjusted
                        (add-to-each (first l) rest-of-l))]
                (cons (first l) adjusted))]))

; Number [List-of Number] -> [List-of Number]
; adds n to each number on l
(check-expect (add-to-each 50 '(40 110 140 170))
              '(90 160 190 220))

(define (add-to-each n l)
  (map (lambda (i) (+ n i)) l))


; [List-of Number] -> [List-of Number]
; converts a list of relative to absolute distances
; the first number represents the distance to the origin
(check-expect (relative->absolute.v2 '(50 40 70 30 30))
              '(50 90 160 190 220))

(define (relative->absolute.v2 l0)
  (local [; [List-of Number] -> [List-of Number]
          (define (relative->absolute/a l acc-dist)
            (cond
              [(empty? l) '()]
              [else
               (local [(define acc (+ (first l) acc-dist))]
                 (cons
                  acc
                  (relative->absolute/a (rest l) acc)))]))]
    (relative->absolute/a l0 0)))
