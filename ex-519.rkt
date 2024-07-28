;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-519) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

;; ex-519
;; Is it acceptable to impose the extra cost on cons
;; for all programs to turn length into a constant-time
;; function?

#|

It depends on the situation, most of the programs written
do not depend on the knowing the length of lists to process
them. However, if there was a situation where such
a computation was required at several steps, it would be
prudent to save compute and sacrifice space.

|#