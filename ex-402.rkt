;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-402) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-402
;; Reread ex-354. Explain the reasoning behind our hint
;; to think of the given expression as an atomic value
;; at first.

;; A: The function (eval-variable* ex da) consumed two
;; arguments: a BSL-var-expr and a [List-of Association],
;; then computes ex based by making substitutions from
;; associations in da.
;; This is Case 1 from Simultaneous processing and is
;; employed here because by designing the template
;; according to da and treating ex like an atomic value
;; we focus on the main task (applying substitutions from
;; da) then delegate the actual evaluation to
;; eval-variable which is designed for processing ex.