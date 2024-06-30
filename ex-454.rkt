;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-454) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-454
;; Design create-matrix. The function consumes a
;; number n and a list of n-squared numbers. It produces
;; an n * n matrix

(define ERR "(length l) must equal n squared")

;; N [List-of Number] -> [List-of [List-of Number]]
;; checked: creates an nxn matrix from n and l
(check-expect (checked-create-matrix 2 '(1 2 3 4))
              (create-matrix 2 '(1 2 3 4)))
(check-error (checked-create-matrix 3 '(1 2 3 4))
             ERR)

(define (checked-create-matrix n l)
  (if (= (length l) (* n n))
      (create-matrix n l)
      (error ERR)))

;; N [List-of Number] -> [List-of [List-of Number]]
;; what:
;; creates an nxn matrix from n and l
;; how:
;; conses first n elements of l until l is exhausted
;; termination:
;; eventually because the recurrence receive l minus 
;; the first n elements on each call the process will
;; end
(check-expect (create-matrix 0 '()) '())
(check-expect (create-matrix 1 '(2)) '((2)))
(check-expect (create-matrix 2 '(1 2 3 4))
              '((1 2)
                (3 4)))
(check-expect (create-matrix 3 '(1 2 3 4 5 6 7 8 9))
              '((1 2 3)
                (4 5 6)
                (7 8 9)))

(define (create-matrix n l)
  (cond
    [(empty? l) '()]
    [else
     (cons (first-row n l)
           (create-matrix n (rm-first-row n l)))]))

;; [X] N [List-of X] -> [List-of X]
;; retrieves the first n elements from l
(check-expect (first-row 1 '(2)) '(2))
(check-expect (first-row 2 '(1 2 3 4)) '(1 2))
(check-expect (first-row 3 '(1 2 3 4 5 6 7 8 9))
              '(1 2 3))

(define (first-row n l)
  (local (;; N [List-of X]-> [List-of X]
          (define (helper i l)
            (cond
              [(= n i) '()]
              [else
               (cons (first l)
                     (helper (add1 i) (rest l)))])))
    (helper 0 l)))

;; [X] N [List-of X] -> [List-of X]
;; removes the first n elements from l
(check-expect (rm-first-row 1 '(2)) '())
(check-expect (rm-first-row 2 '(1 2 3 4)) '(3 4))
(check-expect (rm-first-row 3 '(1 2 3 4 5 6 7 8 9))
              '(4 5 6 7 8 9))

(define (rm-first-row n l)
  (local (;; N [List-of X]-> [List-of X]
          (define (helper i l)
            (cond
              [(= n i) l]
              [else (helper (add1 i) (rest l))])))
    (helper 0 l)))
  

                 

