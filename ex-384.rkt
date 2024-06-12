;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-384) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-384
;; Figure 133 mentions read-xexpr/web. See fig-132
;; for its signature and purpose statement and read
;; its documentation to determine the difference to its
;; "plain" relative.

; ->
; The functions read-xexpr/web and read-plain-xexpr/web
; perform the same operation (purpose statement and signature
; are identical) except that read-xexpr/web does not
; ignore whitespace while read-plain-xexpr/web does.

;; Fig-133 is also missing several important pieces, in
;; particular the interpretation of data and purpose
;; statements for all the locally defined functions.
;; Formulate the missing pieces so that you get to
;; understand the program.

(require 2htdp/batch-io)
(require 2htdp/universe)
(require 2htdp/image)

;; Fig-133: Web data as an event
;; -----------------------------

(define PREFIX "https://www.google.com/finance?q=")
(define SIZE 22)

(define-struct data [price delta])
; A StockWorld is a structure: (make-data String String)
; *interpretation*
; (make-data "17.45" ".06") means a price at 17.45
; with a price change of .06%

; String -> StockWorld
; retrieves the stock price of co and its change every 15s
(define (stock-alert co)
  (local ((define url (string-append PREFIX co))
          
          ; StockWorld -> StockWorld
          ; retrieves stock price and priceChange from url
          ; and represents it as (make-data price priceChange)
          (define (retrieve-stock-data __w)
            (local ((define x (read-xexpr/web url)))
              (make-data (get x "price")
                         (get x "priceChange"))))
          
          ; StockWorld -> Image
          ; represents w as an image displaying
          ; price and priceChange
          (define (render-stock-data w)
            (local (; [StockWorld String -> String] -> Image
                    ; uses selector sel to develop a text
                    ; image of colored col
                    (define (word sel col)
                      (text (sel w) SIZE col)))
              
              (overlay (beside (word data-price 'black)
                               (text "  " SIZE 'white)
                               (word data-delta 'red))
                       (rectangle 300 35 'solid 'white)))))
    
    (big-bang (retrieve-stock-data 'no-use)
      [on-tick retrieve-stock-data 15]
      [to-draw render-stock-data])))


; Xexpr.v3 String -> String
; retrieves the value of the "content" attribute
; from a 'meta element that has attribute "itemprop"
; with value s
(define (get x s) "string-ex")