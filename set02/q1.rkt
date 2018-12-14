;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
;; q1.rkt :  A Test Editor

;; Goal: The editor consumes two inputs, an editor and a KeyEvent to produce
;;       another editor.The editor is a structure with pre and post strings.A
;;       cursor specifies the position within the editor.The location of the
;;       cursor for the editor is after the pre string and before the post
;;       string.The editor handles key events '\b' backspace,'\t' tab key and
;;       '\r' return key.The editor also takes single character KeyEvent and 
;;       appends the single character to the pre string.

(require rackunit)
(require 2htdp/universe)
(require "extras.rkt")

(check-location "02" "q1.rkt")

(provide
        make-editor
        editor-pre
        editor-post
        editor?
        edit)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; DATA DEFINATIONS

(define-struct editor (pre post))

;; A Editor is a
;;   (make-editor String String)
;; INTERPRETATION:
;;    pre is a string before the cursor in the editor
;;    post is a string after the cursor in the editor
;;    A cursor specifies the position within the editor.It is placed after the
;;    pre string and before the post string

;; editor-fn : Editor -> ??
#|
 (define (editor-fn ed)
   (...
      (editor-pre ed)
      (editor-post ed)))
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; edit: Editor KeyEvent -> Editor
;; GIVEN: A editor with the pre and post strings and the key event.
;;        A KeyEvent can be either of the below:
;;        "\b" - represents backspace. The last character of the pre string is
;;               removed if the "\b"(backspace) KeyEvent is encountered.
;;        "\t" - represents tab. The edit function ignores KeyEvent "\t" and
;;               returns the editor without any changes.
;;        "\r" - represents return. The edit function ignores KeyEvent "\r" and
;;               returns the editor without any changes.
;;        "left" - represents left. The edit function on encountering the left
;;                 KeyEvent removes the first character of post string and
;;                 appends it to the pre string.
;;        "right" - represents right. The edit function on encountering the
;;                 right KeyEvent removes the last character of pre string and
;;                 appends it as the first character to the post string.
;;         single character(1String) - appends the single character to the end
;;                 of the pre string.
;; RETURNS: A editor, after the changes made to the pre and post strings
;;          based on the KeyEvents mentioned above.
;; EXAMPLES: 
;; (edit (make-editor "hello" "world") "\b") = (make-editor "hell" "world")
;; (edit (make-editor "hello" "world") "left") = (make-editor "hell" "oworld")
;; (edit (make-editor "hello" "world") "right") = (make-editor "hellow" "orld")
;; (edit (make-editor "hello" "world") "\t") = (make-editor "hello" "world")
;; (edit (make-editor "hello" "world") "\r") = (make-editor "hello" "world")
;; (edit (make-editor "hello" "world") "a") = (make-editor "helloa" "world")
;; STRATEGY:Use template for Editor on ed and dividing into cases based on input

(define (edit ed ke)
    (cond [(key=? "\b" ke)
           (cursor-backspace (editor-pre ed) (editor-post ed))]
          [(key=? "\t" ke) ed]
          [(key=? "\r" ke) ed]
          [(key=? "left" ke)
           (cursor-move-left (editor-pre ed) (editor-post ed))]
          [(key=? "right" ke)
           (cursor-move-right (editor-pre ed) (editor-post ed))]
          [(= (string-length ke) 1)
           (add-text-to-pre (editor-pre ed) (editor-post ed) ke)]))

;; TESTS
(begin-for-test
  (check-equal? (edit (make-editor "hello" "world") "\b")
                (make-editor "hell" "world")
                "\b KeyEvent did not delete the last character from pre string")
  (check-equal? (edit (make-editor "" "world") "\b")
                (make-editor "" "world")
                "\b KeyEvent didn't delete the last character from pre string")
  (check-equal? (edit (make-editor "hello" "") "\b")
                (make-editor "hell" "")
                "\b KeyEvent didn't delete the last character from pre string")
  (check-equal? (edit (make-editor "h" "") "\b")
                (make-editor "" "")
                "\b KeyEvent didn't delete the last character from pre string")
  (check-equal? (edit (make-editor "" "") "\b")
                (make-editor "" "")
                "\b KeyEvent didn't delete the last character from pre string")
  (check-equal? (edit (make-editor "hello" "world") "left")
                (make-editor "hell" "oworld")
                "\b KeyEvent didn't move the cursor to the left ")
  (check-equal? (edit (make-editor "" "world") "left")
                (make-editor "" "world")
                "\b KeyEvent didn't move the cursor to the left ")
  (check-equal? (edit (make-editor "hello" "") "left")
                (make-editor "hell" "o")
                "\b KeyEvent didn't move the cursor to the left ")
  (check-equal? (edit (make-editor "" "world") "left")
                (make-editor "" "world")
                "\b KeyEvent didn't move the cursor to the left ")
  (check-equal? (edit (make-editor "h" "") "left")
                (make-editor "" "h")
                "\b KeyEvent didn't move the cursor to the left ")
  (check-equal? (edit (make-editor "" "w") "left")
                (make-editor "" "w")
                "\b KeyEvent didn't move the cursor to the left ")
  (check-equal? (edit (make-editor "" "") "left")
                (make-editor "" "")
                "\b KeyEvent didn't move the cursor to the left ")
  (check-equal? (edit (make-editor "hello" "world") "right")
                (make-editor "hellow" "orld")
                "\b KeyEvent didn't move the cursor to the right ")
  (check-equal? (edit (make-editor "" "world") "right")
                (make-editor "w" "orld")
                "\b KeyEvent didn't move the cursor to the right ")
  (check-equal? (edit (make-editor "hello" "") "right")
                (make-editor "hello" "")
                "\b KeyEvent didn't move the cursor to the right ")
  (check-equal? (edit (make-editor "" "world") "right")
                (make-editor "w" "orld")
                "\b KeyEvent didn't move the cursor to the right ")
  (check-equal? (edit (make-editor "h" "") "right")
                (make-editor "h" "")
                "\b KeyEvent didn't move the cursor to the right ")
  (check-equal? (edit (make-editor "" "w") "right")
                (make-editor "w" "")
                "\b KeyEvent didn't move the cursor to the right ")
  (check-equal? (edit (make-editor "" "") "right")
                (make-editor "" "")
                "\b KeyEvent didn't move the cursor to the right ")
  (check-equal? (edit (make-editor "" "") "\t")
                (make-editor "" "")
                "\t did not return the editor without changes")
  (check-equal? (edit (make-editor "hello" "world") "\r")
                (make-editor "hello" "world")
                "\r KeyEvent didn't move the cursor to the right ")
  (check-equal? (edit (make-editor "hello" "world") "y")
                 (make-editor "helloy" "world")
                 "the 1String entered is not appended to the pre string"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; cursor-backspace : String String -> Editor
;; GIVEN: a pre string and a post string
;;        pre is a string before the cursor in the editor
;;        post is a string after the cursor in the editor
;; RETURNS: A editor after removing the last character from the pre string.
;; EXAMPLES:
;; (cursor-backspace "hello" "world") = (make-editor "hell" "world")
;; (cursor-backspace "" "world") = (make-editor "" "world")
;; STRATEGY: Combining simpler functions

(define (cursor-backspace pre post)
    (make-editor (if (= (string-length pre) 0)
                     "" (substring pre 0 (- (string-length pre) 1))) post))

;; TESTS
(begin-for-test
  (check-equal? (cursor-backspace "hello" "world")(make-editor "hell" "world")
                "The last character of the pre string is not removed")
  (check-equal? (cursor-backspace "" "world")(make-editor "" "world")
                "The last character of the pre string is not removed")
  (check-equal? (cursor-backspace "hello" "")(make-editor "hell" "")
                "The last character of the pre string is not removed")
  (check-equal? (cursor-backspace "" "")(make-editor "" "")
                "The last character of the pre string is not removed"))
                
;; cursor-move-left : String String -> Editor
;; GIVEN: a pre string and a post string
;;        pre is a string before the cursor in the editor
;;        post is a string after the cursor in the editor
;; RETURNS: A editor after removing the last character from the pre string
;;          and appending to the post string.
;; EXAMPLES:
;; (cursor-move-left "hello" "world") = (make-editor "hell" "oworld")
;; (cursor-move-left "" "world") = (make-editor "" "world")
;; STRATEGY: Combining simpler functions


(define (cursor-move-left pre post)
    (make-editor (if (= (string-length pre) 0)
                     "" (substring pre 0 (- (string-length pre) 1)))
                 (string-append
                  (substring pre
                             (if (= (string-length pre) 0)
                                 0 (- (string-length pre) 1)))
                  post)))

;; TESTS
(begin-for-test
  (check-equal? (cursor-move-left "hello" "world")(make-editor "hell" "oworld")
                "The last character of pre was not appended to post string")
  (check-equal? (cursor-move-left "" "world")(make-editor "" "world")
                "The last character of pre was not appended to post string")
  (check-equal? (cursor-move-left "hello" "")(make-editor "hell" "o")
                "The last character of pre was not appended to post string")
  (check-equal? (cursor-move-left "" "")(make-editor "" "")
                "The last character of pre was not appended to post string"))

;; cursor-move-right : String String -> Editor
;; GIVEN: a pre string and a post string
;;        pre is a string before the cursor in the editor
;;        post is a string after the cursor in the editor
;; RETURNS: A editor after removing the first character from the post string
;;          and appending to the end of the pre string.
;; EXAMPLES:
;; (cursor-move-right "hello" "world") = (make-editor "hellow" "orld")
;; (cursor-move-right "" "world") = (make-editor "w" "orld")                
;; STRATEGY: Combining simpler functions
  
(define (cursor-move-right pre post)
    (make-editor (string-append pre
                         (substring post 0 (if (= (string-length post) 0) 0 1)))
                 (if (<= (string-length post) 1) "" (substring post 1))))

;; TESTS
(begin-for-test
  (check-equal? (cursor-move-right "hello" "world")(make-editor "hellow" "orld")
                "The first character of post was not appended to end of pre")
  (check-equal? (cursor-move-right "" "world")(make-editor "w" "orld")
                "The first character of post was not appended to end of pre")
  (check-equal? (cursor-move-right "hello" "")(make-editor "hello" "")
                "The first character of post was not appended to end of pre")
  (check-equal? (cursor-move-right "" "")(make-editor "" "")
                "The first character of post was not appended to end of pre"))

;; add-text-to-pre : String String KeyEvent -> Editor
;; GIVEN: a pre string and a post string and a KeyEvent
;;        pre is a string before the cursor in the editor
;;        post is a string after the cursor in the editor
;;        the KeyEvent is a 1String which has to be appended to pre string
;; RETURNS: A editor after appending the 1String to the end of the pre string.
;; EXAMPLES:
;; (add-text-to-pre "hello" "world" "o") = (make-editor "helloo" "world")
;; (add-text-to-pre "" "world" "h") = (make-editor "h" "world")
;; STRATEGY: Combining simpler functions

(define (add-text-to-pre pre post ke)
    (make-editor (string-append pre ke) post))

;;TESTS
(begin-for-test
  (check-equal? (add-text-to-pre "hello" "world" "o")
                (make-editor "helloo" "world")
                "The 1String has not been appended to pre string")
  (check-equal? (add-text-to-pre "" "" "o")
                (make-editor "o" "")
                "The 1String has not been appended to pre string"))
