;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; q2.rkt : Checking for overlapping lists and non-overlapping lists of
;;          flap-jacks and skillets

;; GOAL: A flapjack represents perfectly circular pancakes.A list of flapjacks
;;       might overlap or not overlap with each other.The overlapping function
;;       returns a list of flapjacks for each flapjack which overlap with it.
;;       The overlapping functionality hence returns a list of list of
;;       flapjacks. The non overlapping functionality returns a list of
;;       non-overlapping flapjacks.Flapjacks in skillet function returns a list
;;       of flapjacks which perfectly fit in the skillet.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require rackunit)
(require "extras.rkt")

(check-location "04" "q2.rkt")

(provide make-flapjack
         flapjack-x
         flapjack-y
         flapjack-radius
         make-skillet
         skillet-x
         skillet-y
         skillet-radius
         overlapping-flapjacks
         non-overlapping-flapjacks
         flapjacks-in-skillet)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; DATA DEFINATIONS

(define-struct flapjack (x y radius))
;; A Flapjack is a
;;      (make-flapjack Real Real PosReal)
;; INTERPRETATION:
;; x specifies the x-coordinate of the centre of the flapjack.
;; y specifies the y-coordinate of the centre of the flapjack.
;; radius specifies the radius of the flapjack.

;; TEMPLATE:
;; flapjack-fn : Flapjack -> ??
;; (define (flapjack-fn f)
;;    (... (flapjack-x f)
;;         (flapjack-y f)
;;         (flapjack-radius f)))

;; A List of Flapjacks(LOF) is either
;; -- empty
;; -- (cons Flapjack LOF)

;; TEMPLATE:
;; lof-fn : LOF -> ??
;; HALTING MEASURE: (length lst) 
;; (define (lof-fn lst)
;;   (cond
;;     [(empty? lst) ...]
;;     [else (... (flapjack-fn(first lst))
;;                (lof-fn (rest lst)))]))

(define-struct skillet (x y radius))
;; A Skillet is a
;;     (make-skillet Real Real PosReal)
;; INTERPRETATION:
;; x specifies the x-coordinate of the centre of the skillet.
;; y specifies the y-coordinate of the centre of the skillet.
;; radius specifies the radius of the skillet

;; TEMPLATE:
;; skillet-fn : Skillet -> ??
;; (define (skillet-fn s)
;;    (... (skillet-x s)
;;         (skillet-y s)
;;         (skillet-radius s)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; defining lists for testing

(define LIST-0F-FLAPJACK
    (list (make-flapjack -10  2 5)
          (make-flapjack  -3  0 4)
          (make-flapjack   4 -2 4.6)
          (make-flapjack 7.2  6 5)
          (make-flapjack  20  4 4.2)))

(define LIST-OF-OVERLAPPING-FLAPJACKS
      (list
          (list (make-flapjack -10  2 5)
                (make-flapjack  -3  0 4))
          (list (make-flapjack -10  2 5)
                (make-flapjack  -3  0 4)
                (make-flapjack   4 -2 4.6))
          (list (make-flapjack  -3  0 4)
                (make-flapjack   4 -2 4.6)
                (make-flapjack 7.2  6 5))
          (list (make-flapjack   4 -2 4.6)
                (make-flapjack 7.2  6 5))
          (list (make-flapjack  20  4 4.2))))

(define LIST-OF-FLAPJACKS-IN-SKILLET
       (list (make-flapjack  -3  0 4)
             (make-flapjack   4 -2 4.6)
             (make-flapjack 7.2  6 5)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; overlapping-flapjacks : ListOfFlapjack -> ListOfListOfFlapjack
;; GIVEN: a list of flapjacks
;; RETURNS: a list of list of flapjacks. Each flapjack checks with the other
;;          flapjacks in the list if it is overlapping with the other flapjacks.
;;          If the flapjack overlaps with the other flapjacks then a list of all
;;          the overlapping flapjacks along with itself is returned.All these
;;          individual lists are returned in another list.
;; EXAMPLES:
;;   (overlapping-flapjacks empty)  =>  empty
;;   (overlapping-flapjacks LIST-0F-FLAPJACK)
;;   =>
;;    (list
;;          (list (make-flapjack -10  2 5)
;;                (make-flapjack  -3  0 4))
;;          (list (make-flapjack -10  2 5)
;;                (make-flapjack  -3  0 4)
;;                (make-flapjack   4 -2 4.6))
;;          (list (make-flapjack  -3  0 4)
;;                (make-flapjack   4 -2 4.6)
;;                (make-flapjack 7.2  6 5))
;;          (list (make-flapjack   4 -2 4.6)
;;                (make-flapjack 7.2  6 5))
;;          (list (make-flapjack  20  4 4.2)))
;; STRATEGY : Combine simpler functions

(define (overlapping-flapjacks lst)
  (if(empty? lst) empty (checking-overlapping-flapjacks lst lst)))

;; TESTS
(begin-for-test
  (check-equal?
   (overlapping-flapjacks LIST-0F-FLAPJACK)
   LIST-OF-OVERLAPPING-FLAPJACKS
   "the list of overlapping flapjacks is not as expected")
  (check-equal?
   (overlapping-flapjacks '())
   empty
   "the list of overlapping flapjacks for empty flapjack list is empty"))
                
;; checking-overlapping-flapjacks : LOF LOF -> ListOFListOfFlapjack
;; GIVEN: two Lists of Flapjacks to compare each flapjack from one list with
;;        each flapjack on the other list of flapjacks.
;; RETURNS: a list of list of flapjacks.If the flapjack overlaps with the other
;;          flapjacks then a list of all the overlapping flapjacks along with
;;          itself is returned.All these individual lists are returned in
;;          another list.
;; HALTING MEASURE: (length lst) 
;; EXAMPLES:
;;   (checking-overlapping-flapjacks empty empty)  =>  empty
;;   (checking-overlapping-flapjacks
;;    (list (make-flapjack 7.2  6 5)
;;          (make-flapjack  20  4 4.2))
;;    (list (make-flapjack 7.2  6 5)
;;          (make-flapjack  20  4 4.2)))
;;   =>
;;    (list
;;          (list (make-flapjack 7.2  6 5))
;;          (list (make-flapjack  20  4 4.2)))
;; STRATEGY: Use template of ListOfFlapjack(LOF) on lst and complete-list

(define (checking-overlapping-flapjacks lst complete-list)
  (if (empty? lst) empty
      (cons (check-flapjack-with-flapjacks (first lst) complete-list)
            (checking-overlapping-flapjacks (rest lst) complete-list))))

;; check-flapjack-with-flapjacks : Flapjack LOF -> LOF
;; GIVEN: A Flapjack and a ListOfFlapjack (LOF)
;; RETURNS: a ListOfFlapjack(LOF) is returned. The flapjack is checked with
;;         every flapjack in the input ListOfFlapjack and if the any of the
;;         flapjack overlaps with the given flapjack it is added to a the list.
;;         If the flapjack is not overlapping it is not appended to the list.
;; HALTING MEASURE: (length lst) 
;; EXAMPLES:
;; (check-flapjack-with-flapjacks (make-flapjack -10 2 5) LIST-OF-FLAPJACK)
;;     = (list (make-flapjack -10 2 5) (make-flapjack -3 0 4))
;; STRATEGY: Use template for ListOfFlapjack(LOF) on lst

(define (check-flapjack-with-flapjacks flapjack lst)
  (if (empty? lst) empty
      (if (overlapping-condition-flapjack? flapjack (first lst))
          (cons (first lst)
                (check-flapjack-with-flapjacks flapjack (rest lst)))
          (check-flapjack-with-flapjacks flapjack (rest lst)))))

;; distance-between-two-points: Real Real Real Real -> NonNegativeReal
;; GIVEN: x and y coordinates of two points.
;; RETURNS: the distance between the two given points.
;; EXAMPLES:
;; (distance-between-two-points 2 1 2 1) = 0
;; STRATEGY: Combining simpler functions

(define (distance-between-two-points x1 y1 x2 y2)
  (sqrt (+ (sqr (- x1 x2))
           (sqr (- y1 y2)))))

;; overlapping-condition-flapjack?: Flapjack Flapjack -> Boolean
;; GIVEN: two flapjacks,to check if the two flapjacks overlap with each other.
;; RETURNS: a Boolean value,that is,either true or false.The function returns
;;          true if the condition for two flapjacks to overlap is satisfied and
;;          false if the two flapjacks do not overlap.The condition for checking
;;          if two flapjacks overlap is if the distance between the centres of
;;          two flapjack is lesser than or equal to the sum of the radius of
;;          both the flapjacks.
;; EXAMPLES:
;; (overlapping-condition-flapjack?
;;         (make-flapjack -10  2 5)(make-flapjack -10  2 5)) = #true
;; STRATEGY: Use template for Flapjack on flapjack

(define (overlapping-condition-flapjack? flapjack1 flapjack2)
  (<= (distance-between-two-points
       (flapjack-x flapjack1) (flapjack-y flapjack1)
       (flapjack-x flapjack2) (flapjack-y flapjack2))
      (+ (flapjack-radius flapjack1) (flapjack-radius flapjack2))))

;; non-overlapping-flapjacks: LOF-> LOF
;; GIVEN: a LOF(List of Flapjacks)
;; RETURNS: a list of flapjacks (LOF),a list of flapjacks which do not overlap
;;          with any other flapjack.
;; EXAMPLES:
;;   (non-overlapping-flapjacks empty)  =>  empty
;;   (non-overlapping-flapjacks LIST-0F-FLAPJACK) =
;;             (list (make-flapjack  20  4 4.2))
;; STRATEGY: Combining simpler functions

(define (non-overlapping-flapjacks lst)
  (if(empty? lst) empty (check-non-overlapping-flapjacks lst lst)))

;; TESTS
(begin-for-test
  (check-equal? (non-overlapping-flapjacks LIST-0F-FLAPJACK)
                (list (make-flapjack  20  4 4.2))
                "the non-overlapping flapjacks returned are not as expected")
  (check-equal? (non-overlapping-flapjacks '())'()
                "the list returned for an empty list is not empty"))

;; check-non-overlapping-flapjacks: LOF LOF -> LOF
;; GIVEN: two List of Flapjacks(LOF)to compare each flapjack of one list with
;;        every flapjack on the other list.
;; RETURNS: a LOF,with the flapjacks which do not overlap with any other
;;          flapjack in the list.
;; HALTING MEASURE: (length lst) 
;; EXAMPLES:
;; (check-non-overlapping-flapjacks LIST-0F-FLAPJACK LIST-0F-FLAPJACK) =
;;      (list (make-flapjack  20  4 4.2))
;; STRATEGY: Use template for LOF on lst and complete-list

(define (check-non-overlapping-flapjacks lst complete-list)
(cond
  [(empty? lst) empty]
  [else
   (if(= (length (check-flapjack-with-flapjacks (first lst) complete-list)) 1)
      (cons  (first(check-flapjack-with-flapjacks (first lst) lst))
             (check-non-overlapping-flapjacks (rest lst) complete-list))
    (check-non-overlapping-flapjacks (rest lst) complete-list))]))
          
;; flapjacks-in-skillet : LOF Skillet -> LOF
;; GIVEN: a list of flapjacks and a skillet
;; RETURNS:  a list of the given flapjacks that fit entirely within the skillet.
;; HALTING MEASURE: (length lst) 
;; EXAMPLE:
;; (flapjacks-in-skillet LIST-0F-FLAPJACK (make-skillet 2 3 12)) =
;;       (list (make-flapjack  -3  0 4)
;;             (make-flapjack   4 -2 4.6)
;;             (make-flapjack 7.2  6 5))
;; STRATEGY: Use template for LOF on lst

(define (flapjacks-in-skillet lst skillet)
  (cond
    [(empty? lst) empty]
    [else (if (check-for-flapjack-in-skillet? (first lst) skillet)
              (cons (first lst) (flapjacks-in-skillet (rest lst) skillet))
              (flapjacks-in-skillet (rest lst) skillet))]))

;; TESTS
(begin-for-test
  (check-equal?
   (flapjacks-in-skillet LIST-0F-FLAPJACK (make-skillet 2 3 12))
   LIST-OF-FLAPJACKS-IN-SKILLET
   "The list of flapjacks which fit in the skillet is not as expected"))
                

;; check-for-flapjack-in-skillet?: Flapjack Skillet -> Boolean
;; GIVEN: a Flapjack and a Skillet
;; RETURNS: a Boolean value,that is true if the difference between the two
;;          radius of the skillet and flapjack is greater than or equal to the
;;          distance between the cetres of the flapjack and the skillet.
;; EXAMPLE:
;; (check-for-flapjack-in-skillet?
;;          (make-flapjack  -3  0 4)
;;           (make-skillet 2 3 12)) = true
;; STRATEGY: Use template for Flapjack on flapjack and Skillet on skillet

(define (check-for-flapjack-in-skillet? flapjack skillet)
  (>= (- (skillet-radius skillet)(flapjack-radius flapjack))
      (distance-between-two-points (flapjack-x flapjack) (flapjack-y flapjack)
                                   (skillet-x skillet) (skillet-y skillet))))


     
             