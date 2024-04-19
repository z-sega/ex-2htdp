;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-268) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-268
;; An inventory record specifies the name of an item,
;; a description, the acquisition price, and the
;; recommended sales price.
;;
;; Define a function that sorts a list of inventory
;; records by the difference between the two prices.

(define-struct IR [name desc acq-price rec-price])
; An IR is a structure:
;   (make-IR String String Number Number)
; *interpretation*
; (make-IR "blueberry" "smartphone" 480.00 500.00)
; describes an inventory item that is blueberry
; described as a smartphone acquired for 480.00
; to be sold at 500
(define blueberry
  (make-IR "blueberry" "smartphone" 480.00 500.00))
(define iphone
  (make-IR "iphone" "smartphone" 640.00 700.00))
(define soccer-ball
  (make-IR "soccer-ball" "smartphone" 5.00 50.00))
(define toyota-corolla
  (make-IR "corolla" "small sedan" 2340.00 2700.00))

; [List-of IR]
(define target-inventory
  (list blueberry
        iphone
        soccer-ball
        toyota-corolla))

; [List-of IR] -> [List-of IR]
; sorts a loir in descending order of price-diff
; between recommended-price and acquisition-price
(check-expect (sort-inventory target-inventory)
              (list toyota-corolla
                    iphone
                    soccer-ball
                    blueberry))
(define (sort-inventory loir)
  (local (; IR IR -> Boolean
          ; #t if price-diff is greater in a
          ; than in b
          (define (greater-price-diff a b)
            (> (price-diff a) (price-diff b)))
                
          ; IR -> Number
          ; compute the price-diff between the
          ; recommended price and the acquisition
          ; price
          (define (price-diff ir)
            (- (IR-rec-price ir) (IR-acq-price ir))))
    (sort loir greater-price-diff)))

