;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname accumulator-sierpinski) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

#|

Sample Problem:
Design the add-sierpinski function. It consumes an image
and three Posns describing a triangle. It uses the latter
to add a Sierpinski triangle to this image.

We are confronted with a classical generative-recursive
problem, and we can start with the classic template of
generative recursion and the four central design questions:

- The problem is trivial if the triangle is too small
  to be subdivided
- In the trivial case, the function returns the given image
- Otherwise the midpoints of the sides of the given
  triangle are determined to add another triangle. Each
  "outer" triangle is then processed recursively.
- Each of these recursive steps produces an image. The
  remaining question is how to combine these images.

|#

; Image Posn Posn Posn -> Image
; generative:
; adds the triangle (a, b, c) to scene0,
; subdivides it into three triangles by taking the
; midpoints of its sides; stop if (a, b, c) is too small
#;(define (add-sierpinski scene0 a b c)
  (cond
    [(too-small? a b c) scene0]
    [else
     (local [(define scene1 (add-triangle scene0 a b c))
             (define mid-a-b (mid-point a b))
             (define mid-b-c (mid-point b c))
             (define mid-c-a (mid-point c a))
             (define scene2
               (add-sierpinski scene0 a mid-a-b mid-c-a))
             (define scene3
               (add-sierpinski scene0 b mid-b-c mid-a-b))
             (define scene4
               (add-sierpinski scene0 c mid-c-a mid-b-c))]
       ; -IN-
       (... scene1 ... scene2 ... scene3 ... scene4 ...))]))
;; accumulators as results of generative recursions,
;; a skeleton