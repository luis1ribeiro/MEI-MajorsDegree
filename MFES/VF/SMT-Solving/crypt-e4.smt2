(set-logic QF_LIA)

(set-info :source |
    → TWO + TWO = FOUR
    → SEND + MORE = MONEY
|)
(set-info :smt-lib-version 2.0)

(push)

  ; letters declaration
  (declare-fun t () Int)
  (declare-fun w () Int)
  (declare-fun o () Int)
  (declare-fun f () Int)
  (declare-fun u () Int)
  (declare-fun r () Int)
  (declare-fun two () Int)
  (declare-fun four () Int)

  ; constants bounds
  (assert (and (>= t 0) (<= t 9)))
  (assert (and (>= w 0) (<= w 9)))
  (assert (and (>= o 0) (<= o 9)))
  (assert (and (>= f 0) (<= f 9)))
  (assert (and (>= u 0) (<= u 9)))
  (assert (and (>= r 0) (<= r 9)))

  ; Must be different from each other
  (assert (distinct t w o f u r))

  ; Arithmetic exp. where each letter is multiplied by "his own specific weight" (base 10)
  (assert (and (> t 0) (= two (+ (* 100 t) (* 10 w) o))))
  (assert (and (> f 0) (= four (+ (* 1000 f) (* 100 o) (* 10 u) r))))
  (assert (= (+ two two) four))

  (check-sat)
  (get-value (t w o f u r))
  (pop)
