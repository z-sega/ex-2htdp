#lang htdp/bsl


; Letter is one of:
; - 1String or
; - #false

; e.g
; Letters: a, b, #false

(define-struct 3Word
  [l1 l2 l3])
; 3Word is (make-3Word Letter Letter Letter)
