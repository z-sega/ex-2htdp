;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex-509) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; ex-509
;; Design the function split. Use the accumulator design recipe to
;; improve on the result of ex-508. After all, the hints already
;; point out that when the function discovers the correct split
;; point, it needs both parts of the list, and one part is
;; obviously lost due to recursion.

(require 2htdp/image)
(require 2htdp/universe)

(define FONT-SIZE 16)
(define FONT-COLOR "black")

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

(define LETTER-WIDTH
  (image-width (editor-text '("a"))))


; [List-of 1String] N -> Editor
; computes an editor by splitting ed @ x
(check-expect (split (explode "") 0)
              (make-editor '() '()))
(check-expect (split (explode "") (add1 LETTER-WIDTH))
              (make-editor '() '()))
(check-expect (split (explode "plant") 0)
              (make-editor '() (explode "plant")))
(check-expect (split (explode "plant")
                                (add1 LETTER-WIDTH))
              (make-editor (reverse (explode "p"))
                           (explode "lant")))
(check-expect (split (explode "plant")
                                (add1 (* 2 LETTER-WIDTH)))
              (make-editor (reverse (explode "pl"))
                           (explode "ant")))
(check-expect (split (explode "plant")
                                (add1 (* 5 LETTER-WIDTH)))
              (make-editor (reverse (explode "plant"))
                           '()))

(define (split ed x)
  (local [; [List-of 1String] [List-of 1String] -> Editor
          ; recursively add more items from s to a until
          ; limit of items @ x is reached.
          ; accumulator: a represents the [List-of 1String]
          ; that fit on a @ x
          (define (split/a a s)
            (cond
              [(empty? s) (make-editor a '())]
              [(cons? s)
               (if (and
                    (string=?
                     (string-append (implode (reverse a)) 
                                    (implode s))
                     (implode ed)) 
                    (<= (image-width (editor-text a))
                        x 
                        (image-width
                         (editor-text (cons (first s) a)))))
                   (make-editor a s)
                   (split/a (cons (first s) a) (rest s)))]))]
    (split/a '() ed)))


;; Once you have solved this exercise, equip the main function
;; of A Graphical Editor, Revisited with a clause for mouse
;; clicks. As you experiment with moving the cursor via
;; mouse clicks, you notice that it does not exactly behave like
;; applications that you use on your other devices - even though
;; split passes all its tests.

(define good
  (cons "g" (cons "o" (cons "o" (cons "d" '())))))
(define all
  (cons "a" (cons "l" (cons "l" '()))))
(define lla
  (cons "l" (cons "l" (cons "a" '()))))
; *interp.* (make-editor pre post) means the letters
; pre precede the cursor in reverse order, and those
; in post succeed it. The combined test is:
; (string-append (implode (rev pre))
;                (implode post))

; data example 1:
(make-editor all good)

; data example 2:
(make-editor lla good) ; based on chosen interpretation


; Lo1s -> Lo1s
; produces a reverse version of the given list

(check-expect (rev '()) '())
(check-expect (rev (cons "a" '())) (cons "a" '()))
(check-expect (rev (cons "a" (cons "b" (cons "c" '()))))
              (cons "c" (cons "b" (cons "a" '()))))

(define (rev l)
  (cond
    [(empty? l) '()]
    [(cons? l) (add-at-end (rev (rest l))
                           (first l))]))

; Lo1s 1String -> Lo1s
; creates a new list by adding s to the end of l

(check-expect (add-at-end '() "a")
              (cons "a" '()))
(check-expect (add-at-end (cons "c" (cons "b" '())) "a")
              (cons "c" (cons "b" (cons "a" '()))))

(define (add-at-end l s)
  (cond
    [(empty? l) (cons s '())]
    [(cons? l) (cons (first l)
                     (add-at-end (rest l) s))]))


;; ex-177
;; Design the function create-editor. The function consumes
;; two strings and produces an Editor. The first string is
;; the text to the left of the cursor and the second string
;; is the text to the right of the cursor. The rest of the
;; section relies on this function.


; String String -> Editor
; Consumes pre and post, where pre comes before the cursor
; and post succeeds the cursor

(check-expect (create-editor "all" "good")
              (make-editor (explode "lla") (explode "good")))

(define (create-editor pre post)
  (make-editor (rev (explode pre))
               (explode post)))





(define HEIGHT 20)
(define WIDTH 200)

(define MT (empty-scene WIDTH HEIGHT))
(define CURSOR (rectangle 1 HEIGHT "solid" "red"))


; Editor -> Image
; renders an editor as an image of the two texts
; separated by the cursor

(check-expect (editor-render
               (create-editor "pre" "post"))
              (place-image/align
               (beside (editor-text (cons "p"
                                          (cons "r"
                                                (cons "e" '()))))
                       CURSOR
                       (editor-text (cons "p"
                                          (cons "o"
                                                (cons "s"
                                                      (cons "t" '()))))))
               1 1
               "left" "top"
               MT))

(define (editor-render e)
  (place-image/align
   (beside (editor-text (reverse (editor-pre e)))
           CURSOR
           (editor-text (editor-post e)))
   1 1
   "left" "top"
   MT))


; Lo1s -> String
; Returns a String from combining l

(check-expect (lo1s->string '()) "")
(check-expect (lo1s->string (cons "p"
                                  (cons "o"
                                        (cons "s"
                                              (cons "t" '())))))
              "post")

(define (lo1s->string l)
  (cond
    [(empty? l) ""]
    [(cons? l) (string-append (first l)
                              (lo1s->string (rest l)))]))

; Editor KeyEvent -> Editor
; deals with a key event, given some editor

(check-expect (editor-kh (create-editor "" "") "e")
              (create-editor "e" ""))
(check-expect (editor-kh (create-editor "cd" "fgh") "e")
              (create-editor "cde" "fgh"))
; - "\b" (delete)
(check-expect (editor-kh (create-editor "cd" "fgh") "\b")
              (create-editor "c" "fgh"))
(check-expect (editor-kh (create-editor "" "fgh") "\b")
              (create-editor "" "fgh"))
; - "left" (nav)
(check-expect (editor-kh (create-editor "cd" "fgh") "left")
              (create-editor "c" "dfgh"))
(check-expect (editor-kh (create-editor "" "fgh") "left")
              (create-editor "" "fgh"))
; - "right" (nav)
(check-expect (editor-kh (create-editor "cd" "fgh") "right")
              (create-editor "cdf" "gh"))
(check-expect (editor-kh (create-editor "cd" "") "right")
              (create-editor "cd" ""))
; - "up" or "down" (do-nothing)
(check-expect (editor-kh (create-editor "cd" "fgh") "up")
              (create-editor "cd" "fgh"))
(check-expect (editor-kh (create-editor "cd" "") "down")
              (create-editor "cd" ""))

(define (editor-kh ed k)
  (cond
    [(key=? k "left") (editor-lft ed)]
    [(key=? k "right") (editor-rgt ed)]
    [(key=? k "\b") (editor-del ed)]
    [(key=? k "\t") ed]
    [(key=? k "\r") ed]
    [(= (string-length k) 1) (editor-ins ed k)]
    [else ed]))


; Editor -> Editor
; moves the cursor position one 1String left,
; if possible

(check-expect (editor-lft (create-editor "cd" "fgh"))
              (create-editor "c" "dfgh"))
(check-expect (editor-lft (create-editor "" "fgh"))
              (create-editor "" "fgh"))

(define (editor-lft ed)
  (if (empty? (editor-pre ed))
      ed
      (make-editor (rest (editor-pre ed))
                   (cons (first (editor-pre ed))
                         (editor-post ed)))))

                   
; Editor -> Editor
; moves the cursor position one 1String right,
; if possible

(check-expect (editor-rgt (create-editor "cd" "fgh"))
              (create-editor "cdf" "gh"))
(check-expect (editor-rgt (create-editor "cd" ""))
              (create-editor "cd" ""))

(define (editor-rgt ed)
  (if (empty? (editor-post ed))
      ed
      (make-editor (cons (first (editor-post ed))
                         (editor-pre ed))
                   (rest (editor-post ed)))))


; Editor -> Editor
; deletes a 1String to the left of the cursor,
; if possible

(check-expect (editor-del (create-editor "cd" "fgh"))
              (create-editor "c" "fgh"))
(check-expect (editor-del (create-editor "" "fgh"))
              (create-editor "" "fgh"))

(define (editor-del ed)
  (if (empty? (editor-pre ed))
      ed
      (make-editor (rest (editor-pre ed))
                   (editor-post ed))))


; Editor 1String -> Editor
; insert the 1String k between pre and post
; explanation:
; since the intepretation of the Editor describes
; pre as the list of 1Strings to preceding the
; cursor *in reverse*, inserting k between pre and post
; is as easy as slapping it onto pre

(check-expect (editor-ins (make-editor '() '()) "e")
              (make-editor (cons "e" '()) '()))
(check-expect (editor-ins (make-editor (cons "d" '())
                                       (cons "f" (cons "g" '())))
                          "e")
              (make-editor (cons "e" (cons "d" '()))
                           (cons "f" (cons "g" '()))))

(define (editor-ins ed k)
  (make-editor (cons k (editor-pre ed))
               (editor-post ed)))

; Editor N N MouseEvent -> Editor
; positions the cursor at x
(define (editor-mouse ed x y mouse)
  (cond
    [(mouse=? mouse "button-down")
     (split (append (reverse (editor-pre ed))
                    (editor-post ed)) x)]
    [else ed]))
  

; main: String -> Editor
; launches the editor given some initial string
(define (main s)
  (big-bang (create-editor s " ")
    [on-key editor-kh]
    [on-mouse editor-mouse]
    [to-draw editor-render]))


;; Graphical programs, like editors, call for experimentation to
;; come up with the best "look and feel" experiences. In this
;; case, your editor is too simplistic with its placements of the
;; cursor. After the applications on you computer determine the
;; split point, they also determine which letter division is
;; closer to the x-coordinate and place the cursor there. 

