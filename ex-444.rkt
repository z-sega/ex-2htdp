;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-444) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-444
;; ex-443 means that the design for gcd-structural
;; calls for some planning and a design-by-composition
;; approach.
;;
;; The very explanation of "greatest common denominator"
;; suggests a two-stage approach. First design a
;; function that can compute the list of divisors of
;; a natural number. Second, design a function that
;; picks the largest common number in the list of
;; divisors of n and the list of divisors of m.
;; The overall function would look like this:

;; N[>= 1] N[>= 1] -> N
;; finds the greatest common divisor of S and L
(check-expect (gcd-structural 6 25) 1)
(check-expect (gcd-structural 18 24) 6)

(define (gcd-structural S L)
  (largest-common (divisors S S)
                  (divisors S L)))

;; N[>= 1] N[>= 1] -> [List-of N]
;; computes the divisors of l smaller or equal
;; to k
(check-expect (divisors 3 9) '(1 3))
#;(check-expect (divisors 3 9) '(3 1))
(check-expect (divisors 2 9) '(1))

(define (divisors k l)
  (local (; N -> [List-of N]
          ; computes the divisors of n
          (define (divisors* n)
            (filter (lambda (k0)
                      (zero? (remainder l k0)))
                    (build-list k add1)) ;; '(1 ... k)
            #;(cond [(= 1 n) (list 1)]
                  [else
                   (if (and (<= n k)
                            (zero? (remainder l n)))
                       (cons n (divisors* (sub1 n)))
                       (divisors* (sub1 n)))])))
    (divisors* l)))

;; [NEList-of N] [NEList-of N] -> N
;; finds the largest number common to both k and l
(check-expect (largest-common '(1 2 3) '(1 2 3 4)) 3)
(check-expect (largest-common '(1 2) '(1 2 3 4)) 2)
(check-expect (largest-common '(1 2 3) '(1 2)) 2)
(check-expect (largest-common '(1 2 3) '(1)) 1)
;(check-expect (largest-common '() '()) 1)
;(check-expect (largest-common '(1 2 3) '()) 1)
;(check-expect (largest-common '() '(1 2 3)) 1)

(define (largest-common k l)
  (apply max (filter (lambda (k0) (member? k0 l)) k))
  #;(cond [(and (cons? k) (cons? l))
         (if (member? (first k) l)
             (max (first k)
                  (largest-common (rest k) l))
             (largest-common (rest k) l))]
        [else 1]))

;; Q: Why do you think divisors consumes two numbers?
;; A: From the purpose statement "computes the divisors
;;    of l smaller or equal to k",
;; we know that during processing divisors compares
;; each candidate divisor to k, ensuring that it is
;; smaller or equal to k. This is the reason why it
;; consumes two numbers. 

;; Q: Why does it consume S as the first argument
;; in both uses?
;; A: The divisors function uses S as k to ensure that
;; any calculated candidate for S or L (the inputs to
;; gcd) are relevant to S. Simply, it isn't relevant
;; as a divisor if it is greater than the smaller of the
;; inputs. Concretely, when trying to find gcd for 16
;; and 64 it does not make sense to think of 32 as a
;; relevant canditate because it isn't a divisor for 16.
