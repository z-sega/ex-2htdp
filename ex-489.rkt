;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-489) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-489
;; Reformulate add-to-each using map and lambda.

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
                        (map (lambda (i) (+ (first l) i)) rest-of-l))]
                (cons (first l) adjusted))]))