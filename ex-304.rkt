;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-304) (read-case-sensitive #true) (teachpacks ()) (htdp-settings #(#true constructor repeating-decimal #false #true none #false () #false)))
(require 2htdp/abstraction)


;; ex-304
;; Evaluate ... in the interactions area of DrRacket.

(for/list ([i 2]
           [j '(a b)])
  (list i j))

(for*/list ([i 2]
           [j '(a b c)])
  (list i j))

