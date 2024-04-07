;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex-261) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-261
;; Consider the function definition in fig. 101. Both clauses
;; in the nested cond expression extract the first item from
;; an-inv and both compute (extract1 (rest an-inv)).
;; Use local to name this expression. Does this help increase
;; the speed at which the function computes its result?
;; Significantly? A little bit? Not al all?

(define-struct IR [name price])
; An IR is a structure:
;  (make-IR String Number)
(define ir1 (make-IR "rubber duck" 0.99))
(define ir2 (make-IR "AK-47" 1799.99))
(define ir3 (make-IR "Flying couch action figure" 99.99))
(define ir4 (make-IR "Control - The video game" 79.99))
(define ir5 (make-IR "Financial Freedom" 1200000))
(define ir6 (make-IR "Nothing useful" 0))

; [List-of IR]
(define l-ir `(,ir1
               ,ir2
               ,ir3
               ,ir4
               ,ir4 ,ir4 ,ir4 ,ir4 ,ir4 ,ir4
               ,ir4 ,ir4 ,ir4 ,ir4 ,ir4 ,ir4
               ,ir4 ,ir4 ,ir4 ,ir4 ,ir4 ,ir4
               ,ir4 ,ir4 ,ir4 ,ir4 ,ir4 ,ir4
               ,ir4 ,ir4 ,ir4 ,ir4 ,ir4 ,ir4
               ,ir4 ,ir4 ,ir4 ,ir4 ,ir4 ,ir4
               ,ir5
               ,ir6))

;; fig. 101:
; [List-of IR] -> [List-of IR]
; creates an Inventory from an-inv for all those
; items that cost less than a dollar
(check-expect (extract1 l-ir)
              `(,ir1 ,ir6))
(define (extract1 an-inv)
  (cond
    [(empty? an-inv) '()]
    [else (cond
            [(<= (IR-price (first an-inv)) 1.0)
             (cons (first an-inv)
                   (extract1 (rest an-inv)))]
            [else (extract1 (rest an-inv))])]))

; There will be no noticable speed improvement, because the
; natural recursion computation in extract1 is in a
; mutually-exclusive structure - cond - which will only
; evaluate one natural recursion expression in each iteration.

; [List-of IR] -> [List-of IR]
; creates an Inventory from an-inv for all those
; items that cost less than a dollar
(check-expect (extract1.v2 l-ir)
              `(,ir1 ,ir6))
(define (extract1.v2 an-inv)
  (cond
    [(empty? an-inv) '()]
    [else (local [(define extracted
                    (extract1.v2 (rest an-inv)))]
            ; - IN -
            (cond
              [(<= (IR-price (first an-inv)) 1.0)
               (cons (first an-inv) extracted)]
              [else extracted]))]))

