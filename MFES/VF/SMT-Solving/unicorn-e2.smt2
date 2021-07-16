(set-logic QF_UF)

(declare-fun mythical () Bool)
(declare-fun immortal () Bool)
(declare-fun mammal () Bool)
(declare-fun horned () Bool)
(declare-fun magical () Bool)

; - If the unicorn is mythical, then it is immortal.
(assert (=> mythical immortal))
; - If the unicorn is not mythical, then it is a mortal mammal.
(assert (=> (not mythical) (and (not immortal) mammal)))
; - If the unicorn is either immortal or a mammal, then it is horned.
(assert (=> (or immortal mammal) horned))
; - The unicorn is magical if it is horned.
(assert (=> horned magical))

(push)
  ; - Is the unicorn magical?
  (echo "Is the unicorn magical?")
  (assert (not magical))
  ; - Dá unsat logo o unicórnio ser mágico é uma consequência lógica. (Gamma |= F)
  (check-sat)
  (pop)

(push)
  ; - Is the unicorn horned?
  (echo "Is the unicorn horned?")
  (assert (not horned))
  ; - Dá unsat logo o unicórnio ser cornudo é uma consequência lógica. (Gamma |= F)
  (check-sat)
  (pop)

(push)
  ; - Is the unicorn mythical?
  (echo "Is the unicorn mythical?")
  (assert (not mythical))
  ; - Dá sat logo não é necessariamente verdade. not (Gamma |= F)
  (check-sat)
  (pop)

