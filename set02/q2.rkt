;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
;; q2.rkt : Finite State Machine 

;; Goal : The finite state machine accepts a sequence of letters (each letter
;;        represented as a 1String) only if it matches the regular expression
;;        (d* | d* p d* | s d* | s d* p d*) (d | d e).The regular expression
;;        represented above can be broken down as
;;        d* d
;;        d* d e
;;        d* p d* d 
;;        d* p d* d e
;;        s d* d
;;        s d* d e
;;        s d* p d* d
;;        s d* p d* d e
;;        where * represents 0 or more
;;        and | represents OR.
;;        The finite state machine designed accepts the strings which satisfy
;;        the above regular expressions.A set of functions(initial-state,
;;        next-state,accepting-state?,rejecting-state?) have been defined to
;;        illustrate the working of the finite state machine.

(require rackunit)
(require "extras.rkt")

(check-location "02" "q2.rkt")

(provide
        initial-state
        next-state
        accepting-state?
        rejecting-state?)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; DATA DEFINITIONS:

;; a LegalInput is one of
;; -- "d"
;; -- "p"
;; -- "s"
;; -- "e"
;; INTERPRETATION: self-evident
;; EXAMPLES
(define d "d")
(define p "p")
(define s "s")
(define er "e")

;; TEMPLATE
;; legalInput-fn: LegalInput -> ??
#|
   (define (legalInput-fn legal-input)
    (cond
      [(string=? legal-input "d") ...]
      [(string=? legal-input "p") ...]
      [(string=? legal-input "s") ...]
      [(string=? legal-input "e") ...]))
|#

;; a State is one of
;; -- "start-state"
;; -- "error-state"
;; -- "state-one"
;; -- "state-two"
;; -- "state-three"
;; -- "state-four"
;; -- "state-five"
;; INTERPRETATION:
;; start-state: is the initial state of the finite machine
;; error-state: when the legalInput on any state does not point to any other
;;              state it points to the error state
;; state-one: state-one is a final state which accepts some of the strings that
;;            match the regular expression (d*|d*pd*|sd*|sd*pd*)(d|de)
;;            where * represents 0 or more and | represents OR
;; state-two: state-two is one of State
;; state-three: state-three is one of State
;; state-four: state-four is a final state which accepts some of the strings 
;;             that match the regular expression (d*|d*pd*|sd*|sd*pd*)(d|de)
;;             where * represents 0 or more and | represents OR
;; state-five: state-five is a final state which accepts some of the strings 
;;             that match the regular expression (d*|d*pd*|sd*|sd*pd*)(d|de)
;;             where * represents 0 or more and | represents OR

(define start-state "start-state")
(define error-state "error-state")
(define state-one "state-one")
(define state-two "state-two")
(define state-three "state-three")
(define state-four "state-four")
(define state-five "state-five")

;; TEMPLATE
;; state-fn : State -> ??
#|
   (define (state-fn state)
    (cond
      [(string=? state "start-state") ...]
      [(string=? state "error-state") ...]
      [(string=? state "state-one") ...]
      [(string=? state "state-two") ...]
      [(string=? state "state-three") ...]
      [(string=? state "state-four") ...]
      [(string=? state "state-five") ...]))
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; initial-state : Number -> State
;; GIVEN: a number
;; RETURNS: a representation of the initial state of the finite state machine
;; EXAMPLES:
;; (initial-state 1) = "start-state"
;; (initial-state -1) = "start-state"
;; (initial-state 0) = "start-state"
;; STRATEGY: Combine simpler functions

(define (initial-state num) start-state)

;; TESTS
(begin-for-test
  (check-equal? (initial-state 1) start-state
                " start-state should be returned for the input 1")
  (check-equal? (initial-state 0) start-state
                " start-state should be returned for the input 0")
  (check-equal? (initial-state -1) start-state
                " start-state should be returned for the input -1")
  (check-equal? (initial-state 1.0) start-state
                " start-state should be returned for the input 1.0"))

;; next-state : State LegalInput -> State
;; GIVEN: a state of the machine and a machine input
;; RETURNS: the state the machine should enter if it is in the given state
;;          and sees the given input
;; EXAMPLES:
;; (next-state start-state d) = "state-one"
;; (next-state start-state er) = "error-state"
;; (next-state state-one d) = "state-one"
;; STRATEGY:Use template for State on state and dividing into cases
;;          based on input

(define (next-state state legalInput)
  (cond
    [(string=? state start-state)(start-state-next legalInput)]
    [(string=? state state-one)(state-one-next legalInput)]
    [(string=? state state-two)(state-two-next legalInput)]
    [(string=? state state-three)(state-three-next legalInput)]
    [(string=? state state-four)(state-four-next legalInput)]
    [(string=? state state-five)(state-five-next legalInput)]
    [(string=? state error-state)(error-state-next legalInput)]))

;; TESTS
(begin-for-test
  (check-equal? (next-state start-state d) "state-one"
                "next state on giving input 'd' is not 'state-one'")
  (check-equal? (next-state start-state s) "state-two"
                "next state on giving input 's' is not 'state-two'")
  (check-equal? (next-state start-state p) "state-three"
                "next state on giving input 'p' is not 'state-three'")
  (check-equal? (next-state start-state er) "error-state"
                "next state on giving input 'e' is not 'error-state'")
  (check-equal? (next-state state-one d) "state-one"
                "next state on giving input 'd' is not 'state-one'")
  (check-equal? (next-state state-one s) "error-state"
                "next state on giving input 's' is not 'error-state'")
  (check-equal? (next-state state-one p) "state-three"
                "next state on giving input 'p' is not 'state-three'")
  (check-equal? (next-state state-one er) "state-five"
                "next state on giving input 'e' is not 'state-one'")
  (check-equal? (next-state state-two d) "state-one"
                "next state on giving input 'd' is not 'state-one'")
  (check-equal? (next-state state-two s) "error-state"
                "next state on giving input 's' is not 'state-two'")
  (check-equal? (next-state state-two p) "state-three"
                "next state on giving input 'p' is not 'state-three'")
  (check-equal? (next-state state-two er) "error-state"
                "next state on giving input 'e' is not 'error-state'")
  (check-equal? (next-state state-three d) "state-four"
                "next state on giving input 'd' is not 'state-four'")
  (check-equal? (next-state state-three s) "error-state"
                "next state on giving input 's' is not 'error-state'")
  (check-equal? (next-state state-three p) "error-state"
                "next state on giving input 'p' is not 'error-state'")
  (check-equal? (next-state state-three er) "error-state"
                "next state on giving input 'e' is not 'error-state'")
  (check-equal? (next-state state-four d) "state-four"
                "next state on giving input 'd' is not 'state-four'")
  (check-equal? (next-state state-four s) "error-state"
                "next state on giving input 's' is not 'error-state'")
  (check-equal? (next-state state-four p) "error-state"
                "next state on giving input 'p' is not 'error-state'")
  (check-equal? (next-state state-four er) "state-five"
                "next state on giving input 'e' is not 'state-five'")
  (check-equal? (next-state state-five d) "error-state"
                "next state on giving input 'd' is not 'error-state'")
  (check-equal? (next-state state-five s) "error-state"
                "next state on giving input 's' is not 'error-state'")
  (check-equal? (next-state state-five p) "error-state"
                "next state on giving input 'p' is not 'error-state'")
  (check-equal? (next-state state-five er) "error-state"
                "next state on giving input 'e' is not 'error-state'")
  (check-equal? (next-state error-state d) "error-state"
                "next state on giving input 'd' is not 'error-state'")
  (check-equal? (next-state error-state s) "error-state"
                "next state on giving input 's' is not 'error-state'")
  (check-equal? (next-state error-state p) "error-state"
                "next state on giving input 'p' is not 'error-state'")
  (check-equal? (next-state error-state er) "error-state"
                "next state on giving input 'e' is not 'error-state'"))

;; accepting-state? : State -> Boolean
;; GIVEN: State,a state of the machine
;; RETURNS:  Boolean, true if the given state is a final (accepting) state
;; EXAMPLES:
;; (accepting-state? "state-one") = true
;; (accepting-state? "state-four") = true
;; (accepting-state? "state-two") = false
;; STRATEGY: Use template for State on state and dividing into cases
;;           based on input

(define (accepting-state? state)
  (cond
    [(string=? state state-one)true]
    [(string=? state state-four)true]
    [(string=? state state-five)true]
    [else false]))

;; TESTS
(begin-for-test
  (check-equal? (accepting-state? start-state) false
                "start-state should not be an accepting state")
  (check-equal? (accepting-state? state-one) true
                "state-one should be an accepting state")
  (check-equal? (accepting-state? state-two) false
                "state-two should not be an accepting state")
  (check-equal? (accepting-state? state-three) false
                "state-three should not be an accepting state")
  (check-equal? (accepting-state? state-four) true
                "state-four should not be an accepting state")
  (check-equal? (accepting-state? state-five) true
                "state-five should be an accepting state")
  (check-equal? (accepting-state? error-state) false
                "error-state should not be an accepting state"))

;; rejecting-state? : State -> Boolean
;; GIVEN: a state of the machine
;; RETURNS: true if there is no path(empty or non-empty) from the given state
;;       to an accepting state
;; EXAMPLES:
;; (rejecting-state? "start-state") = false
;; (rejecting-state? "error-state") = true
;; (rejecting-state? "state-five") = false
;; STRATEGY: Use template for State on state

(define (rejecting-state? state)
  (if (string=? state error-state) true false))

;; TESTS
(begin-for-test
  (check-equal? (rejecting-state? start-state) false
                "start-state should not be a rejecting-state")
  (check-equal? (rejecting-state? state-one) false
                "state-one should not be a rejecting-state")
  (check-equal? (rejecting-state? state-two) false
                "state-two should not be a rejecting-state")
  (check-equal? (rejecting-state? state-three) false
                "state-three should not be a rejecting-state")
  (check-equal? (rejecting-state? state-four) false
                "state-four should not be a rejecting-state")
  (check-equal? (rejecting-state? state-five) false
                "state-five should not be a rejecting-state")
  (check-equal? (rejecting-state? error-state) true
                "error-state should be a rejecting-state"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; start-state-next : LegalInput -> State
;; GIVEN:LegalInput,either 'd','s','p','e'
;; RETURNS:a state, which is based on the legalInput given to the start-state
;;       if 'd' is the legalInput the next-state from start-state is state-one
;;       if 's' is the legalInput the next-state from start-state is state-two
;;       if 'p' is the legalInput the next-state from start-state is state-three
;;       if 'e' is the legalInput the next-state from start-state is error-state
;; EXAMPLES:
;; (start-state-next "d") = "state-one"
;; (start-state-next "p") = "state-three" 
;; STRATEGY: Use template for LegalInput on legalInput

(define (start-state-next legalInput)
  (cond
    [(string=? legalInput d) state-one]
    [(string=? legalInput s) state-two]
    [(string=? legalInput p) state-three]
    [(string=? legalInput er) error-state]))

;; TESTS
(begin-for-test
  (check-equal? (start-state-next d) "state-one"
                "next state from start-state on input 'd' is not 'state-one'")
  (check-equal? (start-state-next s) "state-two"
                "next state from start-state on input 's' is not 'state-two'")  
  (check-equal? (start-state-next p) "state-three"
                "next state from start-state on input 'p' is not 'state-three'")
  (check-equal? (start-state-next er) "error-state"
                "next state from start-state on input 'e' isn't 'error-state'"))

;; state-one-next : LegalInput -> State
;; GIVEN:LegalInput,either 'd','s','p','e'
;; RETURNS:a state, which is based on the legalInput given to state-one
;;       if 'd' is the legalInput the next-state from state-one is state-one
;;       if 's' is the legalInput the next-state from state-one is error-state
;;       if 'p' is the legalInput the next-state from state-one is state-three
;;       if 'e' is the legalInput the next-state from state-one is state-five
;; EXAMPLES:
;; (state-one-next "d") = "state-one"
;; (state-one-next "p") = "state-three"
;; STRATEGY: Use template for LegalInput on legalInput
  
(define (state-one-next legalInput)
  (cond
    [(string=? legalInput d) state-one]
    [(string=? legalInput s) error-state]
    [(string=? legalInput p) state-three]
    [(string=? legalInput er) state-five]))

;; TESTS
(begin-for-test
  (check-equal? (state-one-next d) "state-one"
                "next state from state-one on input 'd' is not 'state-one'")
  (check-equal? (state-one-next s) "error-state"
                "next state from state-one on input 's' is not 'error-state'")  
  (check-equal? (state-one-next p) "state-three"
                "next state from state-one on input 'p' is not 'state-three'")
  (check-equal? (state-one-next er) "state-five"
                "next state from state-one on input 'e' is not 'state-five'"))

;; state-two-next : LegalInput -> State
;; GIVEN:LegalInput,either 'd','s','p','e'
;; RETURNS:a state, which is based on the legalInput given to state-two
;;       if 'd' is the legalInput the next-state from state-two is state-one
;;       if 's' is the legalInput the next-state from state-two is error-state
;;       if 'p' is the legalInput the next-state from state-two is state-three
;;       if 'e' is the legalInput the next-state from state-two is error-state
;; EXAMPLES:
;; (state-two-next "d") = "state-one"
;; (state-two-next "p") = "state-three"
;; STRATEGY: Use template for LegalInput on legalInput and dividing into
;;           cases based on input

(define (state-two-next legalInput)
  (cond
    [(string=? legalInput d) state-one]
    [(string=? legalInput s) error-state]
    [(string=? legalInput p) state-three]
    [(string=? legalInput er) error-state]))

;;TESTS
(begin-for-test
  (check-equal? (state-two-next d) "state-one"
                "next state from state-two on input 'd' is not 'state-one'")
  (check-equal? (state-two-next s) "error-state"
                "next state from state-two on input 's' is not 'error-state'")
  (check-equal? (state-two-next p) "state-three"
                "next state from state-two on input 'p' is not 'state-three'")
  (check-equal? (state-two-next er) "error-state"
                "next state from state-two on input 'e' is not 'error-state'"))

;; state-three-next : LegalInput -> State
;; GIVEN:LegalInput,either 'd','s','p','e'
;; RETURNS:a state, which is based on the legalInput given to state-three
;;       if 'd' is the legalInput the next-state from state-three is state-four
;;       if 's' is the legalInput the next-state from state-three is error-state
;;       if 'p' is the legalInput the next-state from state-three is error-state
;;       if 'e' is the legalInput the next-state from state-three is error-state
;; EXAMPLES:
;; (state-three-next "d") = "state-four"
;; (state-three-next "p") = "error-state"
;; STRATEGY: Use template for LegalInput on legalInput and dividing into
;;           cases based on input

(define (state-three-next legalInput)
  (cond
    [(string=? legalInput d) state-four]
    [(string=? legalInput s) error-state]
    [(string=? legalInput p) error-state]
    [(string=? legalInput er) error-state]))

;;TESTS
(begin-for-test
  (check-equal? (state-three-next d) "state-four"
                "next state from state-three on input 'd' is not 'state-four'")
  (check-equal? (state-three-next s) "error-state"
                "next state from state-three on input 's' is not 'error-state'")
  (check-equal? (state-three-next p) "error-state"
                "next state from state-three on input 'p' is not 'error-state'")
  (check-equal? (state-three-next er) "error-state"
                "next state from state-three on input 'e' isn't 'error-state'"))

;; state-four-next : LegalInput -> State
;; GIVEN:LegalInput,either 'd','s','p','e'
;; RETURNS:a state, which is based on the legalInput given to state-four
;;       if 'd' is the legalInput the next-state from state-four is state-four
;;       if 's' is the legalInput the next-state from state-four is error-state
;;       if 'p' is the legalInput the next-state from state-four is error-state
;;       if 'e' is the legalInput the next-state from state-four is state-five
;; EXAMPLES:
;; (state-four-next "d") = "state-four"
;; (state-four-next "s") = "error-state"
;; STRATEGY: Use template for LegalInput on legalInput and dividing into
;;           cases based on input

(define (state-four-next legalInput)
  (cond
    [(string=? legalInput d) state-four]
    [(string=? legalInput s) error-state]
    [(string=? legalInput p) error-state]
    [(string=? legalInput er) state-five]))

;;TESTS
(begin-for-test
  (check-equal? (state-four-next d) "state-four"
                "next state from state-four on input 'd' is not 'state-four'")
  (check-equal? (state-four-next s) "error-state"
                "next state from state-four on input 's' is not 'error-state'")
  (check-equal? (state-four-next p) "error-state"
                "next state from state-four on input 'p' is not 'error-state'")
  (check-equal? (state-four-next er) "state-five"
                "next state from state-four on input 'e' is not 'state-five'"))

;; state-five-next : LegalInput -> State
;; GIVEN:LegalInput,either 'd','s','p','e'
;; RETURNS:a state, which is based on the legalInput given to state-five
;;       if 'd' is the legalInput the next-state from state-five is error-state
;;       if 's' is the legalInput the next-state from state-five is error-state
;;       if 'p' is the legalInput the next-state from state-five is error-state
;;       if 'e' is the legalInput the next-state from state-five is error-state
;; EXAMPLES:
;; (state-five-next "d") = "error-state"
;; (state-five-next "s") = "error-state"
;; STRATEGY: Use template for LegalInput on legalInput and dividing into
;;           cases based on input

(define (state-five-next legalInput)
  (cond
    [(string=? legalInput d) error-state]
    [(string=? legalInput s) error-state]
    [(string=? legalInput p) error-state]
    [(string=? legalInput er) error-state]))

;;TESTS
(begin-for-test
  (check-equal? (state-five-next d) "error-state"
                "next state from state-five on input 'd' is not 'error-state'")
  (check-equal? (state-five-next s) "error-state"
                "next state from state-five on input 's' is not 'error-state'")
  (check-equal? (state-five-next p) "error-state"
                "next state from state-five on input 'p' is not 'error-state'")
  (check-equal? (state-five-next er) "error-state"
                "next state from state-five on input 'e' is not 'error-state'"))

;; error-state-next : LegalInput -> State
;; GIVEN:LegalInput,either 'd','s','p','e'
;; RETURNS:a state, which is based on the legalInput given to error-state
;;       if 'd' is the legalInput the next-state from error-state is error-state
;;       if 's' is the legalInput the next-state from error-state is error-state
;;       if 'p' is the legalInput the next-state from error-state is error-state
;;       if 'e' is the legalInput the next-state from error-state is error-state
;; EXAMPLES:
;; (error-state-next "d") = "error-state"
;; (error-state-next "s") = "error-state"
;; STRATEGY: Use template for LegalInput on legalInput and dividing into
;;           cases based on input

(define (error-state-next legalInput)
  (cond
    [(string=? legalInput d) error-state]
    [(string=? legalInput s) error-state]
    [(string=? legalInput p) error-state]
    [(string=? legalInput er) error-state]))

;;TESTS
(begin-for-test
  (check-equal? (error-state-next d) "error-state"
                "next state from error-state on input 'd' is not 'error-state'")
  (check-equal? (error-state-next s) "error-state"
                "next state from error-state on input 's' is not 'error-state'")
  (check-equal? (error-state-next p) "error-state"
                "next state from error-state on input 'p' is not 'error-state'")
  (check-equal? (error-state-next er) "error-state"
                "next state from error-state on input 'e' isn't 'error-state'"))




