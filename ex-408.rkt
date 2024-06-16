;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-408) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

(define bad-i1-db (make-db `(("Name" ,string?)
                             ("Age" ,number?))
                           '(("Rashid" 31)
                             ("Bella" 38 #true)
                             ("Angie" 38))))
(define bad-i2-db (make-db `(("Name" ,string?)
                             ("Age" ,number?))
                           '(("Rashid" #true)
                             ("Bella" 39)
                             ("Angie" 38))))

; DB -> Boolean
; #t if all rows in db satisfy (I1) and (I2)
(check-expect (integrity-check school-db) #true)
(check-expect (integrity-check presence-db) #true)
(check-expect (integrity-check bad-i1-db) #false)
(check-expect (integrity-check bad-i2-db) #false)

(define (integrity-check db)
  (local ((define schema (db-schema db))
          (define content (db-content db))
          (define width (length schema))
          ; Row -> Boolean
          ; does row satisfy (I1) and (I2)
          (define (row-integrity-check row)
            (and (= (length row) width)
                 (andmap (lambda (s c) [(second s) c])
                         schema
                         row))))
    (andmap row-integrity-check content)))

;; *Projections and Selections* Programs need to
;; extract data from databases. One kind of extraction
;; is to select content, which is explained in Real-World
;; Data: iTunes. The other kind of extraction produces
;; a reduced database; it is dubbed projection. More
;; specifically, a project constructs a database by
;; retaining only certain columns from a given database.
;; 
;; The description of a projection suggests the following:

(define labels '("Name" "Present"))

(define projected-content
  '(("Alice" #true)
    ("Bob" #false)
    ("Carol" #true)
    ("Dave" #false)))

(define projected-schema
  `(("Name" ,string?)
    ("Present" ,boolean?)))

(define projected-db
  (make-db projected-schema projected-content))

; DB [List-of Label] -> DB
; retains a column from db if its label is in labels
(check-expect (db-content
               (project school-db '("Name" "Present")))
              projected-content)

(define (project db labels)
  (local ((define schema (db-schema db))
          (define content (db-content db))

          ; Spec -> Boolean
          ; does this spec belong to the new schema
          (define (keep? c)
            (member? (first c) labels))
          
          ; Row -> Row
          ; retains those columns whose name is in labels
          (define (row-project row)
            (foldr (lambda (cell m acc)
                     (if m (cons cell acc) acc))
                   '()
                   row
                   mask))
          
          ; [List-of Boolean]
          (define mask (map keep? schema)))
    (make-db (filter keep? schema)
             (map row-project content))))


;; ex-408
;; Design the function select. It consumes a database, a
;; list of labels, and a predicate on rows. The result
;; is a list of rows that satisfy the given predicate,
;; projected down to the given set of labels.

; [Row -> Boolean]
(define present? (lambda (r) (third r)))
(define youth? (lambda (r) (< (second r) 30)))

(define *all* '("Name" "Age" "Present"))
(define name-age '("Name" "Age"))
(define name-present '("Name" "Present"))

; DB [List-of Label] [Row -> Boolean] -> Content
; computes the rows that satisfy given p? in db,
; projected down by l*
(check-expect (select school-db *all* (lambda (r) #true))
              (db-content school-db))
(check-expect (select school-db name-age (lambda (r) #true))
              (db-content (project school-db name-age)))
(check-expect (select school-db *all* youth?)
              '(("Bob" 25 #false)))
(check-expect (select school-db name-age youth?)
              '(("Bob" 25)))
(check-expect (select school-db '("Name") present?)
              '(("Alice")
                ("Carol")))

(define (select db l* p?)
  (local ((define projection (project db l*)) ; DB
          (define mask ; [List-of Boolean]
            (map p? (db-content db)))) 
    (foldr (lambda (row m acc)
             (if m (cons row acc) acc))
           '()
           (db-content projection)
           mask)))
  