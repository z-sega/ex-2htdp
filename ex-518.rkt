;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-518) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct pair [left right])
; ConsOrEmpty is one of:
; - '()
; - (make-pair Any ConsOrEmpty)

; Any ConsOrEmpty -> ConsOrEmpty
#;(define (our-cons a-value a-list)
  (cond
    [(empty? a-list) (make-pair a-value a-list)]
    [(pair? a-list) (make-pair a-value a-list)]
    [else (error "our-cons: ...")]))

; ConsOrEmpty -> Any
; extracts the left part of the given pair
#;(define (our-first mimicked-list)
  (if (empty? mimicked-list)
      (error "our-first: ...")
      (pair-left mimicked-list)))

; ConsOrEmpty -> ConsOrEmpty
; extracts the right part of the given pair
#;(define (our-rest mimicked-list)
  (if (empty? mimicked-list)
      (error "our-rest: ...")
      (pair-right mimicked-list)))

;; The key insight is that we can add a third field to
;; the structure type definition of pair:

(define-struct cpair [count left right])
; A [MyList X] is one of:
; - '()
; - (make-cpair (tech "N") X [MyList X])
; accumulator the count field is the number of cpairs

;; The count field is used by the structure to remember
;; a fact about the construction of the list.
;; We call this kind of structure field a data accumulator.

; Any ConsOrEmpty -> ConsOrEmpty
(define (our-cons f r)
  (cond
    [(empty? r) (make-cpair 1 f r)]
    [(cpair? r) (make-cpair (+ (cpair-count r) 1) f r)]
    [else (error "our-cons: ...")]))

; Any -> N
; how many items does l contain
(define (our-length l)
  (cond
    [(empty? l) 0]
    [(cpair? l) (cpair-count l)]
    [else (error "our-length: ...")]))

;; ex-518
;; Argue that our-cons takes a constant amount of time
;; to compute its result, regardless of the size of its
;; input.

#|

Regardless of the size of its input, our-cons simply
adds a new list item and increases the count by one.
These actions are constant time actions and do not
increase in response to the input of the given list
because our-cons does not traverse the given list at
any point during its operation.

|#