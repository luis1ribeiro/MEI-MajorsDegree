(set-logic QF_BV)

;; The 4 rows are represented by 4 bitvectors of length 4
;; (_ bv10 32) -→ bitvector detamanho 32 em formato decimal.

(declare-fun r1 () (_ BitVec 4))
(declare-fun r2 () (_ BitVec 4))
(declare-fun r3 () (_ BitVec 4))
(declare-fun r4 () (_ BitVec 4))

;; constrain rows
; Ter apenas um bit a 1.
(assert (= #b0000 (bvand r1 (bvsub r1 #x1))))
(assert (= #b0000 (bvand r2 (bvsub r2 #x1))))
(assert (= #b0000 (bvand r3 (bvsub r3 #x1))))
(assert (= #b0000 (bvand r4 (bvsub r4 #x1))))
; #x1 é a mesma coisa que $b0001

;; constrain columns
; Apenas 1 row tem o bit a 1 nessa coluna: 1 queen por coluna.
(assert (= #b1111 (bvxor r1 r2 r3 r4)))

;; constrain diagonals
(assert (and

  ; row 1:
  (distinct r1 (bvshl  r2 (_ bv1 4)))
  (distinct r1 (bvshl  r3 (_ bv2 4)))
  (distinct r1 (bvshl  r4 (_ bv3 4)))
  ; r1 tem que ser diferente da r2 após ter feito shift right. O bv#n define o número de shifts.
  (distinct r1 (bvlshr r2 (_ bv1 4)))
  (distinct r1 (bvlshr r3 (_ bv2 4)))
  (distinct r1 (bvlshr r4 (_ bv3 4)))

  ; Agora para a row 2:
  (distinct r2 (bvshl  r3 (_ bv1 4)))
  (distinct r2 (bvshl  r4 (_ bv2 4)))
  (distinct r2 (bvlshr r3 (_ bv1 4)))
  (distinct r2 (bvlshr r4 (_ bv2 4)))

  ; Agora para a row 3:
  (distinct r3 (bvshl  r4 (_ bv1 4)))
  (distinct r3 (bvlshr r4 (_ bv1 4)))

))

(check-sat)
(echo "
  0100
  0001
  1000
  0010
")



