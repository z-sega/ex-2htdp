;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex-88) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; --- ex-88.rkt
; Define a structure type that keeps track of the cat's x-coordinate
; and its happiness. Then formulate a data definition for cats,
; dubbed VCat, including an interpretation.

; VCat
(define-struct vcat [xcoord happiness])
; A VCat is a structure:
;   (make-vcat Number Number)
; *interpretation*
; A VCat (make-vcat x h) describes a
; virtual cat pet positioned at x on the x-axis
; and whos happiness level is at h