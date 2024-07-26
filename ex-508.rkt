;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-508) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Recall the relevant definitions from A
;; Graphical Editor, Revisited:
(require 2htdp/image)

(define FONT-SIZE 11)
(define FONT-COLOR "red")

; [List-of 1String] -> Image
; renders a string as an image for the editor
(define (editor-text s)
  (text (implode s) FONT-SIZE FONT-COLOR))

(define-struct editor [pre post])
; An Editor is a structure:
;   (make-editor [List-of 1String] [List-of 1String])
; Intepretation:
; if (make-editor p s) is the state of an interactive
; editor, (reverse p) corresponds to the text
; to the left of the cursor and s to the text on the
; right.
(define ex-editor
  (make-editor (reverse (explode "alp"))
               (explode "nt")))  ;; "plant"

;; ex-508
;; Design split-structural using the structural design
;; recipe. The function consumes a list of 1Strings ed and
;; and a natural number x; the former represents the
;; complete string in some Editor and the latter the
;; x-coordinate of the mouse click.
;; The function produces
;;
;; (make-editor p s)
;;
;; such that:
;; 1. p and s make up ed and
;; 2. x is larger than the image of p and smaller than
;; the image of p extended with the first 1String on s
;; (if any).
;;
;; Here is the first condition expressed with an ISL+
;; expression:

#;(string=? (string-append p s) ed)

;; The second one is

#;(<= (image-width (editor-text p))
      x
      (image-width (editor-text (append p (first s)))))

;; assuming (cons? s).
;;
;; Hints:
;; 1. The x-coordinate measures the distance from the
;; left. Hence the function must check whether larger and
;; larger prefixes of ed fit into the given width. The
;; first one that doesn't fit corresponds to the pre
;; field of the desired Editor, the remainder of ed to
;; the post field.
;; 
;; 2. Designing this function calls for thoroughly
;; developing examples and tests. See Intervals,
;; Enumerations, and Itemizations.

(define LETTER-WIDTH
  (image-width (editor-text '("a"))))


; [List-of 1String] N -> Editor
; computes an editor by splitting ed @ x
(check-expect (split-structural (explode "") 0)
              (make-editor '() '()))
(check-expect (split-structural (explode "") (add1 LETTER-WIDTH))
              (make-editor '() '()))
(check-expect (split-structural (explode "plant") 0)
              (make-editor '() (explode "plant")))
(check-expect (split-structural (explode "plant")
                                (add1 LETTER-WIDTH))
              (make-editor (reverse (explode "p"))
                           (explode "lant")))
(check-expect (split-structural (explode "plant")
                                (add1 (* 2 LETTER-WIDTH)))
              (make-editor (reverse (explode "pl"))
                           (explode "ant")))
(check-expect (split-structural (explode "plant")
                                (add1 (* 5 LETTER-WIDTH)))
              (make-editor (reverse (explode "plant"))
                           '()))

(define (split-structural ed x)
  (local [; [List-of 1String] [List-of 1String]
          ; -> Editor
          (define (fit? p s)
            (cond
              [(empty? s) (make-editor p '())]
              [(cons? s)
               (if (and
                    (string=?
                     (string-append (implode (reverse p)) ;; ***
                                    (implode s))
                     (implode ed)) 
                    (<= (image-width (editor-text p))
                        x 
                        (image-width
                         (editor-text (cons (first s) p)))))
                   (make-editor p s)
                   (fit? (cons (first s) p) (rest s)))]))]
    (fit? '() ed)))


;; ***Note***:
;; Don't overlook the simple things when debugging.
