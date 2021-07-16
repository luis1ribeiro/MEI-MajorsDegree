(set-logic QF_LIA)

(set-info :source |
soduku 4x4 board
author ...
|)
(set-info :smt-lib-version 2.0)

; defs. constantes
(declare-fun x11 () Int)
(declare-fun x12 () Int)
(declare-fun x13 () Int)
(declare-fun x14 () Int)
(declare-fun x21 () Int)
(declare-fun x22 () Int)
(declare-fun x23 () Int)
(declare-fun x24 () Int)
(declare-fun x31 () Int)
(declare-fun x32 () Int)
(declare-fun x33 () Int)
(declare-fun x34 () Int)
(declare-fun x41 () Int)
(declare-fun x42 () Int)
(declare-fun x43 () Int)
(declare-fun x44 () Int)

; constants bounds
(assert (and (>= x11 1) (<= x11 4)))
(assert (and (>= x12 1) (<= x12 4)))
(assert (and (>= x13 1) (<= x13 4)))
(assert (and (>= x14 1) (<= x14 4)))
(assert (and (>= x21 1) (<= x21 4)))
(assert (and (>= x22 1) (<= x22 4)))
(assert (and (>= x23 1) (<= x23 4)))
(assert (and (>= x24 1) (<= x24 4)))
(assert (and (>= x31 1) (<= x31 4)))
(assert (and (>= x32 1) (<= x32 4)))
(assert (and (>= x33 1) (<= x33 4)))
(assert (and (>= x34 1) (<= x34 4)))
(assert (and (>= x41 1) (<= x41 4)))
(assert (and (>= x42 1) (<= x42 4)))
(assert (and (>= x43 1) (<= x43 4)))
(assert (and (>= x44 1) (<= x44 4)))

; lines without repeated numbers
(assert (distinct x11 x12 x13 x14))
(assert (distinct x21 x22 x23 x24))
(assert (distinct x31 x32 x33 x34))
(assert (distinct x41 x42 x43 x44))

; columns without repeated numbers
(assert (distinct x11 x21 x31 x41))
(assert (distinct x12 x22 x32 x42))
(assert (distinct x13 x23 x33 x43))
(assert (distinct x14 x24 x34 x44))

; submatrices without repeated numbers
(assert (distinct x11 x12 x21 x22))
(assert (distinct x13 x14 x23 x24))
(assert (distinct x31 x32 x41 x42))
(assert (distinct x33 x34 x43 x44))

; Puzzle filled example
(push)
  (assert (= x11 4))
  (assert (= x13 1))
  (assert (= x22 2))
  (assert (= x33 3))
  (assert (= x42 4))
  (assert (= x44 1))

  (check-sat)
  (pop)

(exit)
