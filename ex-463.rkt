;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-463) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; An SOE is a non-empty Matrix.
;; constraint: for (list r1 ... rn), (length ri) is (+ n 1)
;; interpretation: represents a system of linear equations
;;
;; An Equation is a [List-of Number]
;; constraint: an Equation contains at least two numbers
;; interpretation: if (list a1 ... an b) is an Equation,
;; a1, ..., an are the lhs variable coefficients and b
;; is the rhs.
;;
;; A Solution is a [List-of Number]

(define M ;; an SOE
  (list (list 2 2 3 10) ;; an Equation
        (list 2 5 12 31)
        (list 4 1 -2 1)))

(define S '(1 1 2)) ;; a Solution

;; Equation -> [List-of Number]
;; extracts the lhs from a row in a matrix
(check-expect (lhs (first M)) '(2 2 3))

(define (lhs e) (reverse (rest (reverse e))))
  
;; Equation -> Number
;; extracts the rhs from a row in a matrix
(check-expect (rhs (first M)) 10)

(define (rhs e) (first (reverse e)))
  

;; SOE Solution -> Boolean
;; #t if plugging in numbers from s for variables in
;; the Equations of soe produces equal lhs and rhs values.
(check-expect (check-solution M S) #t)
(check-expect (check-solution M '(3 2 1)) #f)
(check-expect (check-solution M '(3 2 1)) #f)

(define (check-solution soe s)
  (andmap (lambda (soe0)
            (local ((define lhs-value
                      (plug-in (lhs soe0) s)))
              (= lhs-value (rhs soe0))))
          soe))


;; [List-of Number] [List-of Number] -> Number
;; computes value for lhs when s
;; is plugged in
;; assume: (= (length lhs) (length s0))
(check-expect (plug-in (lhs (first M)) S) 10)
(check-expect (plug-in (lhs (second M)) S) 31)
(check-expect (plug-in (lhs (third M)) S) 1)

(define (plug-in lhs s)
  (local ((define coef-values
            (map (lambda (e0 s0) (* e0 s0)) lhs s)))
    (foldr + 0 coef-values)))

;; ex-463
;; Check that the following system of equations
;; has the same solution as the one labelled from earlier.
;; Do so by hand and with check-solution from ex-462.

(define triangulated-M
  '((2 2 3 10)
    (0 3 9 21)
    (0 0 1 2)))

(check-expect (check-solution triangulated-M S)
              (check-solution M S))