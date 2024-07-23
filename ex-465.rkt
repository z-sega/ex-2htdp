;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-465) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

(define triangulated-M
  '((2 2 3 10)
    (0 3 9 21)
    (0 0 1 2)))

(check-expect (check-solution triangulated-M S)
              (check-solution M S))

(define triangulated-M2
  '((2 2 3 10)
    (0 3 9 21)
    (0 -3 -8 -19)))

(check-expect (check-solution triangulated-M2 S)
              (check-solution M S))


;; ex-465
;; Design subtract. The function consumes two Equations of
;; equal length. It "subtracts" a multiple of the second
;; equation from the first, item by item, so that the resulting
;; Equation has a 0 in the first position. Since the leading
;; coefficient is known to be 0, subtract returns the rest of
;; the list that results from the subtractions.

;; Equation Equation -> Equation
;; "subtracts" a multiple of b from a, item by item,
;; so that the result has 0 in the first position.
;; assume: (= (length a) (length b))
(check-expect (subtract '(2 5 12 31)
                        '(2 2 3 10))
              '(3 9 21))
(check-expect (subtract '(-3 -8 -19)
                        '(3 9 21))
              '(1 2))

(define (subtract a b)
  (local ((define multiple (/ (first a)
                              (first b))))
    (foldr (lambda (a0 b0 rst)
             (local ((define diff (- a0 (* b0 multiple))))
               (if (zero? diff)
                   rst
                   (cons diff rst))))
           '() a b)))
