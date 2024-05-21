;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-315) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
(define-struct no-parent [])
(define-struct person [father mother name date eyes])
; An FT (short for family tree) is one of:
; - (make-no-parent)
; - (make-child FT FT String N String)

;; And since the "no parent" tree is going to show up a lot
;; in our programs, we define NP as a short-hand and revise
;; the data definition a bit:

(define NP (make-no-parent))
; An FT is one of:
; - NP
; - (make-child FT FT String N String)

; Examples:
(make-person NP NP "Carl" 1926 "green")
(make-person (make-person NP NP "Carl" 1926 "green")
            (make-person NP NP "Bettina" 1926 "green")
            "Adam"
            1950
            "hazel")

;; Since the records for Carl and Bettina are also needed
;; to construct records for Dave and Eva, it is better to
;; introduce definitions that name specific instances of
;; child and to use the variable names elsewhere.

;; Oldest Generation:
(define Carl (make-person NP NP "Carl" 1926 "green"))
(define Bettina (make-person NP NP "Bettina" 1926 "green"))

;; Middle Generation:
(define Adam (make-person Carl Bettina "Adam" 1950 "hazel"))
(define Dave (make-person Carl Bettina "Dave" 1955 "black"))
(define Eva (make-person Carl Bettina "Eva" 1965 "blue"))
(define Fred (make-person NP NP "Fred" 1966 "pink"))

;; Youngest Generation:
(define Gustav (make-person Fred Eva "Gustav" 1988 "brown"))

;; ---------------------------------------------
;; ex-315
;; Design the function average-age. It consumes a family
;; forest and a year (N). From this data, it produces the
;; average age of all child instances in the forest.
;; *NOTE*
;; If the trees in this forest overlap, the result isn't a
;; true average because some people contribute more than others.
;; For this exercise, act as if the trees don't overlap.

; [List-of FT]
; *interpretation* a family forest represents several
; families (say, a town) and their ancestor trees
(define lft1 (list Carl Bettina))
(define lft2 (list Fred Eva))
(define lft3 (list Fred Eva Carl))

; [List-of FT] N -> Number
; computes the average age of all people in the forest
(check-within (average-age '() 2024) 0 0.01)
(check-within (average-age lft1 2024) 98 0.01)
(check-within (average-age lft2 2024) 78.25 0.01)

(define (average-age a-forest year)
  (local ((define COUNT (count-persons-in-forest a-forest))
          (define SUM-AGES (sum-ages-in-forest a-forest year)))
    (cond
      [(empty? a-forest) 0]
      [else (/ SUM-AGES COUNT)])))

  
; [List-of FT] -> Number
; count of people in a-forest
(check-expect (count-persons-in-forest lft1) 2)
(check-expect (count-persons-in-forest lft2) 4)

(define (count-persons-in-forest a-forest)
  (foldr (lambda (t acc) (+ (count-persons t) acc))
         0
         a-forest))

; FT -> Number
; counts the child structures in the an-ftree
(check-expect (count-persons NP) 0)
(check-expect (count-persons Carl) 1)
(check-expect (count-persons Adam) 3)
(check-expect (count-persons Gustav) 5)

(define (count-persons an-ftree)
  (cond
    [(no-parent? an-ftree) 0]
    [else (+ 1
             (count-persons (person-father an-ftree))
             (count-persons (person-mother an-ftree)))]))

; [List-of FT] -> Number
; sums the ages of all persons in a-forest based
; on year
(check-expect (sum-ages-in-forest lft1 2024) 196)
(check-expect (sum-ages-in-forest lft2 2024) 313)
    
(define (sum-ages-in-forest a-forest year)
  (foldr (lambda (t acc) (+ (sum-ages t year) acc))
         0
         a-forest))

; FT -> Number
; sums the ages of all persons in an-ftree based on
; current-date
(check-expect (sum-ages Carl 2024) (- 2024 1926))
(check-expect (sum-ages Adam 2024) (+ 2024 2024 2024 -1926 -1926 -1950))

(define (sum-ages an-ftree year)
  (cond
    [(no-parent? an-ftree) 0]
    [else (+ (- year (person-date an-ftree))
             (sum-ages (person-father an-ftree) year)
             (sum-ages (person-mother an-ftree) year))]))