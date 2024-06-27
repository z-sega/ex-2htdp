;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-438) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; N[>= 1] N[>= 1] -> N
;; finds the greatest common divisor of n and m
(check-expect (gcd-structural 6 25) 1)
(check-expect (gcd-structural 18 24) 6)

(define (gcd-structural n m)
  (local (;; N -> N
          ;; determines the gcd of n and m less than i
          (define (greatest-divisor-<= i)
            (cond
              [(= i 1) 1]
              [else
               (if (= (remainder n i) (remainder m i) 0)
                   i
                   (greatest-divisor-<= (sub1 i)))])))
    (greatest-divisor-<= (min n m))))

;; ex-438
;; In your words:
;; Q: How does greatest-divisor-<= work?
;; Use the design recipe to find the right words.
;; A: greatest-divisor-<= is a function that consumes
;; and computes a natural number. It's purpose
;; statement says that it calculates the gcd of n and
;; m less than i. We know that i is the starting point
;; of its recursive processing, and we know that it is
;; the lower of the two numbers n and m.
;; 
;; On each recurrence, the function checks to see
;; if it has found the gcd by checking against the
;; remainder of n / i and m / i. If it has found the
;; gcd it returns it i. Else it recurs once more with
;; (sub1 i) [this is eventually how the function
;; terminates]. If i is 1, then the function gives up
;; and returns 1 because one is the universal divisor. 
;; 
;;
;; Q: Why does the locally defined greatest-divisor-<=
;; recur on (min n m)? 
;; A: The locally defined function recurs on (min n m)
;; because it only needs a starting point to find
;; the greatest-divisor between n and m. 
;; In each iteration the function knows about n and m
;; and uses their values during processing by 
;; recursively substracting 1 from its starting point
;; each time.
