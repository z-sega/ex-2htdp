;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname forests-from-family-trees) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
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

; An FF (short for family forest) is one of:
; - '()
; - (cons FT FF)
; *interpretation* a family forest represents several
; families (say, a town) and their ancestor trees
(define ff1 (list Carl Bettina))
(define ff2 (list Fred Eva))
(define ff3 (list Fred Eva Carl))

;; The first two forests contain two unrelated families,
;; and the third one illustrates that unlike in
;; real forests, trees in family forests can overlap.

;; *Sample Problem*
;; Design the function blue-eyed-child-in-forest?, which
;; determines whether a family forest contains a child with
;; "blue" in the eyes field.

; FF -> Boolean
; does the forest contain any child with "blue" eyes
(check-expect (blue-eyed-person-in-forest? ff1) #false)
(check-expect (blue-eyed-person-in-forest? ff2) #true)
(check-expect (blue-eyed-person-in-forest? ff3) #true)

(define (blue-eyed-person-in-forest? a-forest)
  (cond
    [(empty? a-forest) #false]
    [else (or (blue-eyed-person-in-tree? (first a-forest))
              (blue-eyed-person-in-forest? (rest a-forest)))]))

;; Concerning the template, the design may employ the list
;; template because the function consumes a list. If each
;; item on the list were a structure with an eyes field
;; and nothing else, the function would iterate over those
;; structures using the selector function for the eyes
;; field and a string comparison. In this case, each item
;; is a family tree, but, luckily, we already know how to
;; process family trees ...
;; (*cough* blue-eyed-person-in-tree *cough*)

; FT -> Boolean
; does an-ftree contain a child structure with
; "blue" in the eyes field
(check-expect (blue-eyed-person-in-tree? Carl) #false)
(check-expect (blue-eyed-person-in-tree? Gustav) #true)

(define (blue-eyed-person-in-tree? an-ftree)
  (cond
    [(no-parent? an-ftree) #false]
    [else (or (string=? (person-eyes an-ftree) "blue")
              (blue-eyed-person-in-tree? (person-father an-ftree))
              (blue-eyed-person-in-tree? (person-mother an-ftree)))]))

;; The function definitions refer to each other the same
;; way the data definitions refer to each other. Early chapters
;; gloss over this kind of relationship, but now the situation
;; is sufficiently complicated and deserves attention.
