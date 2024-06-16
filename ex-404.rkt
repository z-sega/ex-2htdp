;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-404) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Present    Description
;; Boolean    String
;; ----------------------
;; #true      "presence"
;; #false     "absence"

;; Stop! Explain the table on the right in the same
;; way.
;; 1. The rule in the left-most column says that the
;; label of the column is "Present" and that
;; every piece of data in this column is a Boolean.
;; 
;; 2. The label of the right-most one is "Description";
;; its values are Strings.

;; We represent databases via structures and lists:

(define-struct db [schema content])
; A DB is a structure: (make-db Schema Content)

; A Schema is a [List-of Spec]
; A Spec is a [List Label Predicate]
; A Label is a String
; A Predicate is a [Any -> Boolean]

; A (piece of) Content is a [List-of Row]
; A Row is a [List-of Cell]
; A Cell is Any
; *constraint* cells do not contain functions.

; *integrity constraint*
; In (make-db sch con), for every row in con,
; (I1) its length is the same as (length sch), and
; (I2) its ith Cell satisfies the ith Predicate in sch

;; Stop! Translate the databases from fig-137 into the
;; chosen data representation. Note that the content of
;; the tables already uses ISL+ data.

(define name-spec `("Name" ,string?))
(define age-spec `("Age" ,integer?))
(define present-school-spec `("Present" ,boolean?))

(define school-schema `(,name-spec
                        ,age-spec
                        ,present-school-spec))

(define school-content '(("Alice" 35 #true)
                         ("Bob" 25 #false)
                         ("Carol" 30 #true)
                         ("Dave" 32 #false)))

(define school-db (make-db school-schema
                           school-content))

(define present-spec `("Present" ,boolean?))
(define description-spec `("Description" ,string?))

(define presence-schema `(,present-spec
                          ,description-spec))

(define presence-content '((#true "presence")
                           (#false "absence")))

(define presence-db (make-db presence-schema
                             presence-content))

;; *Integrity Checking*
;; The use of databases critically relies on their
;; integrity. Here "integrity" refers to constraints
;; (I1) and (I2) from the data definition.
;; Checking database integrity is clearly a task for
;; a function:

; DB -> Boolean
; #t if all rows in db satisfy (I1) and (I2)
(check-expect (integrity-check school-db) #true)
(check-expect (integrity-check presence-db) #true)

(define (integrity-check db)
  (local (; Row -> Boolean
          ; does row satisfy (I1) and (I2)
          (define (row-integrity-check row) ...))
            ;(and (length-of-row-check row)
                 ;(check-every-cell row))))
    (andmap row-integrity-check (db-content db))))

;; ex-404
;; Design the function andmap2. It consumes a function
;; f from two values to Boolean and two equally long
;; lists. Its result is also a Boolean. Specifically,
;; it applies f to pairs of corresponding values from
;; the two lists, and if f always produces #true, andmap2
;; produces #true, too. Otherwise, andmap2 produces #false.
;; In short, andmap2 is like andmap but for two lists.

; [X Y -> Boolean]
(define xy->true (lambda (x y) #true))
(define xy->false (lambda (x y) #false))

; [X Y] [X Y -> Boolean] [List-of X] [List-of Y] -> Boolean
; #t if (f (first a*) (first b*)) holds for all a* and b*
(check-expect (andmap2 xy->true '() '()) #true)
(check-expect (andmap2 xy->true '(a b) '(1 2)) #true)
(check-expect (andmap2 xy->false '(a b) '(1 2)) #false)
(check-expect (andmap2 = '(2 3) '(2 3)) #true)
(check-expect (andmap2 = '(2 3) '(2 7)) #false)
(check-expect (andmap2 (lambda (x y) (x y))
                       `(,string? ,boolean?)
                       '("a" #true))
              #true)
(check-expect (andmap2 (lambda (x y) (x y))
                       `(,string? ,boolean?)
                       '(3 #true))
              #false)

(define (andmap2 f a* b*)
  (foldr (lambda (a b acc)
           (and (f a b) acc)) #true a* b*))

