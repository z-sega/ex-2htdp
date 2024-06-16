;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-403) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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
;** A Spec is a [List Label Predicate] **
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

;; ex-403
;; A Spec combines a Label and a Predicate into a list.
;; While acceptable, this choice violates our guideline
;; of using a structure type for a fixed number of
;; pieces of information.
;;
;; Here is an alternative data representation:

(define-struct spec [label predicate])
; A Spec is a structure: (make-spec Label Predicate)

(define school-schema `((make-spec "Name" ,string?)
                        (make-spec "Age" ,integer?)
                        (make-spec "Present" ,boolean?)))

(define school-content '(("Alice" 35 #true)
                         ("Bob" 25 #false)
                         ("Carol" 30 #true)
                         ("Dave" 32 #false)))

(define school-db (make-db school-schema
                           school-content))

(define presence-schema
  `((make-spec "Present" ,boolean?)
    (make-spec "Description" ,string?)))

(define presence-content '((#true "presence")
                           (#false "absence")))

(define presence-db (make-db presence-schema
                             presence-content))

