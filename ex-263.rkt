;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex-263) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-263
;; Use DrRacket's stepper to study the steps of
;; this calculation in detail

; [NEList-of Number] -> Number
; determines the smallest number on l
(check-expect (inf.v2 (list 2 1 3)) 1)
(define (inf.v2 l)
  (cond
    [(empty? (rest l)) (first l)]
    [else
     (local ((define smallest-in-rest
               (inf.v2 (rest l))))
       ; - IN -
       (if (< (first l) smallest-in-rest)
           (first l)
           smallest-in-rest))]))

; -> 
(inf.v2 (list 2 1 3))

; ==
(cond
  [(empty? (rest (list 2 1 3))) (first (list 2 1 3))]
  [else
   (local ((define smallest-in-rest
             (inf.v2 (rest (list 2 1 3)))))
     (if (< (first (list 2 1 3))
            smallest-in-rest)
         (first (list 2 1 3))
         smallest-in-rest))])

; ==
(local ((define smallest-in-rest
          (inf.v2 (rest (list 2 1 3)))))
  (if (< (first (list 2 1 3))
         smallest-in-rest)
      (first (list 2 1 3))
      smallest-in-rest))

; ==
(define smallest-in-rest_0
  (inf.v2 (rest (list 2 1 3))))

(if (< (first (list 2 1 3))
       smallest-in-rest_0)
    (first (list 2 1 3))
    smallest-in-rest_0)

; ==
(define smallest-in-rest_0
  (cond
    [(empty? (rest (list 1 3))) (first (list 1 3))]
    [else
     (local ((define smallest-in-rest
               (inf.v2 (rest (list 1 3)))))
       (if (< (first (list 1 3))
              smallest-in-rest)
           (first (list 1 3))
           smallest-in-rest))]))

(if (< (first (list 2 1 3))
       smallest-in-rest_0)
    (first (list 2 1 3))
    smallest-in-rest_0)

; ==
(define smallest-in-rest_0
  (local ((define smallest-in-rest
            (inf.v2 (rest (list 1 3)))))
    (if (< (first (list 1 3))
           smallest-in-rest)
        (first (list 1 3))
        smallest-in-rest)))

(if (< (first (list 2 1 3))
       smallest-in-rest_0)
    (first (list 2 1 3))
    smallest-in-rest_0)

; ==
(define smallest-in-rest_1
  (inf.v2 (rest (list 1 3))))

(define smallest-in-rest_0
  (if (< (first (list 1 3))
         smallest-in-rest_1)
      (first (list 1 3))
      smallest-in-rest_1))

(if (< (first (list 2 1 3))
       smallest-in-rest_0)
    (first (list 2 1 3))
    smallest-in-rest_0)

; ==
(define smallest-in-rest_1
  (cond
    [(empty? (rest (list 3))) (first (list 3))]
    [else
     (local ((define smallest-in-rest
               (inf.v2 (rest (list 3)))))
       (if (< (first (list 3))
              smallest-in-rest)
           (first (list 3))
           smallest-in-rest))]))

(define smallest-in-rest_0
  (if (< (first (list 1 3))
         smallest-in-rest_1)
      (first (list 1 3))
      smallest-in-rest_1))

(if (< (first (list 2 1 3))
       smallest-in-rest_0)
    (first (list 2 1 3))
    smallest-in-rest_0)

; ==
(define smallest-in-rest_1
  (cond
    [(empty? (rest (list 3))) (first (list 3))]
    [else
     (local ((define smallest-in-rest
               (inf.v2 (rest (list 3)))))
       (if (< (first (list 3))
              smallest-in-rest)
           (first (list 3))
           smallest-in-rest))]))

(define smallest-in-rest_0
  (if (< (first (list 1 3))
         smallest-in-rest_1)
      (first (list 1 3))
      smallest-in-rest_1))

(if (< (first (list 2 1 3))
       smallest-in-rest_0)
    (first (list 2 1 3))
    smallest-in-rest_0)

; ==
(define smallest-in-rest_1 3)

(define smallest-in-rest_0
  (if (< (first (list 1 3))
         smallest-in-rest_1)
      (first (list 1 3))
      smallest-in-rest_1))

(if (< (first (list 2 1 3))
       smallest-in-rest_0)
    (first (list 2 1 3))
    smallest-in-rest_0)

; ==
(define smallest-in-rest_1 3)
(define smallest-in-rest_0 1)

(if (< (first (list 2 1 3))
       smallest-in-rest_0)
    (first (list 2 1 3))
    smallest-in-rest_0)

; ==
(define smallest-in-rest_1 3)
(define smallest-in-rest_0 1)

smallest-in-rest_0


; ==
1
