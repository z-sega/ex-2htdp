;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex-250) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-250
;; Design tabulate, which is the abstraction of the two
;; functions below.
;; When tabulate is properly designed, use it to define a
;; tabulation function for sqr and tan.


; Number -> [List-of Number]
; tabulates sin between n and 0 (incl.) in a list
(define (tab-sin n)
  (cond
    [(= n 0) (list (sin 0))]
    [else (cons (sin n)
                (tab-sin (sub1 n)))]))

; Number -> [List-of Number]
; tabulates sqrt between n and 0 (incl.) in a list
(define (tab-sqrt n)
  (cond
    [(= n 0) (list (sqrt 0))]
    [else (cons (sqrt n)
                (tab-sqrt (sub1 n)))]))


;; pairs of differences:
; [(= n 0) (list (<1> 0))]
; [else (cons (<2> n) (<3> (sub1 n)))]

; define abstraction:
; Number [Number -> Number] -> [List-of Number]
(define (tabulate n f)
  (cond
    [(= n 0) (list (f 0))]
    [else (cons (f n)
                (tabulate (sub1 n) f))]))

;; verify abstraction:
; TODO: check how to compare inexactness in tests
;(check-expect (tab-sin-from-abstract 0)
;              (tab-sin 0))
;(check-expect (tab-sin-from-abstract 4)
;              (tab-sin 4))
; Number -> [List-of Number]
(define (tab-sin-from-abstract n)
  (tabulate n sin))

; Number -> [List-of Number]
(define (tab-sqrt-from-abstract n)
  (tabulate n sqrt))

; Number -> [List-of Number]
(define (tab-sqr n)
  (tabulate n sqr))

(define (tab-tan n)
  (tabulate n tan))

