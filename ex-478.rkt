;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-478) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-478
;; You can also place the first queen in all squares of
;; the top-most row, the right-most column,
;; and the bottom-most row. Explain why all of these
;; are just like the three scenarios depicted in fig-173.
;;
;; They are all the same because you can rotate any
;; of those new configurations explained in the problem
;; statement to match a corresponding configuration in
;; fig-173.
;;
;; This leaves the central square.
;; Q: Is it possible to place even a second queen
;; after you place one on the central square of a 3x3
;; board?
;; A: No, because at that position the lone queen will
;; threaten every single square.