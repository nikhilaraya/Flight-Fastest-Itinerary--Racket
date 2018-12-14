;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q3) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
;; q3.rkt : A program to insert a '_' at a particular position of a string

;; Goal: inserting a '_' in a given string at a given position

(require rackunit)
(require "extras.rkt")

(provide string-insert)

;; DATA DEFINATIONS: none

;; string-insert: String NonNegInteger -> String
;; GIVEN: a string str and a postive integer i
;; WHERE: i = specifies a postion where the '_' has to be inserted in a given string. i lies between 0 and length of the string inclusive.
;; Examples:
;; (string-insert "assignment" 0) = "_assignment"
;; (string-insert "problemset" 2) = "pr_oblemset"
;; (string-insert "monday" 6) = "monday_"
;; (string-insert "" 1) = "_"
;; DESIGN STRATERGY : Combine simpler functions

(define (string-insert str i)
  (cond
    [(= i (string-length str))
     (string-append str "_")]
    [(= i 0)
     (string-append "_" str)]
    [(= 0 (string-length str)) "_"]
    [(> i 0)
     (string-append (substring str 0 i) "_" (substring str i))]))

;;TESTS
(begin-for-test
  (check-equal? (string-insert "assignment" 0) "_assignment"
                "_assignment should be the output string after '_' is inserted at position 0")
  (check-equal? (string-insert "problemset" 2) "pr_oblemset"
                "pr_oblemset should be the output string after '_' is inserted at position 2")
  (check-equal? (string-insert "monday" 6) "monday_"
                "monday_ should be the output string after '_' is inserted at position 6")
  (check-equal? (string-insert "" 2) "_"
                " '_' should be the output string for empty string input"))