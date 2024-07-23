;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-490) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-490
;; Develop a formula that describes the abstract running time
;; of relative->absolute.
;; Hint: Evaluate the expression
;; (relative->absolute (build-list size add1))
;; by hand. Start by replacing size with 1, 2, and 3.
;; How many recursions of relative->absolute and add-to-each are
;; required each time?

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

;; ----------- A:
(relative->absolute (build-list 1 add1))
(relative->absolute '(1))
;; n: 1
;; r-1: 1
;; r-2: 1
(cons 1 (add-to-each 1 (relative->absolute '())))

(relative->absolute (build-list 2 add1))
(relative->absolute '(1 2))
;; n: 2
;; r-1: 2
;; r-2: 2
(cons 1 (add-to-each 1 (relative->absolute '(2))))
(cons 1 (add-to-each 1 (cons 2 (add-to-each 2 (relative->absolute '())))))

(relative->absolute (build-list 3 add1))
(relative->absolute '(1 2 3))
;; n: 3
;; r-1: 3
;; r-2: 3
(cons 1 (add-to-each 1 (relative->absolute '(2 3))))
(cons 1 (add-to-each 1 (cons 2 (add-to-each 2 (relative->absolute '(3))))))
(cons 1 (add-to-each 1 (cons 2 (add-to-each 2 (cons 3 (add-to-each 3 (relative->absolute '())))))))

