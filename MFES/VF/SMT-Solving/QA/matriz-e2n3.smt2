(set-logic QF_AUFLIA)

(set-info :source |

Faça a codificação lógica do programa que definiu na alínea anterior, num ficheiro em formato SMT-LIBv2.

→ M[1][1] = 2;
→ M[1][2] = 3;
→ M[1][3] = 4;
→ M[2][1] = 3;
→ M[2][2] = 4;
→ M[2][3] = 5;
→ M[3][1] = 4;
→ M[3][2] = 5;
→ M[3][3] = 6;

|)

; Inicialização, para atribuir os primeiros valores. Matriz e Array auxiliares vazios.
(declare-const m0 (Array Int (Array Int Int)))
(declare-const m00 (Array Int Int))

; Declaração das matrizes e sub-matrizes (arrays).
(declare-const m1 (Array Int (Array Int Int)))
(declare-const m11 (Array Int Int))
(declare-const m12 (Array Int Int))
(declare-const m13 (Array Int Int))

(declare-const m2 (Array Int (Array Int Int)))
(declare-const m21 (Array Int Int))
(declare-const m22 (Array Int Int))
(declare-const m23 (Array Int Int))

(declare-const matriz (Array Int (Array Int Int)))
(declare-const m31 (Array Int Int))
(declare-const m32 (Array Int Int))
(declare-const m33 (Array Int Int))

; Declaração dos i,j
(declare-const i Int)
(declare-const j Int)
(declare-const i1 Int)
(declare-const j1 Int)
(declare-const i2 Int)
(declare-const j2 Int)


;; Primeiro ciclo i = 1
  ; Inical i e j
  (assert (= i 1))
  (assert (= j 1))
  (assert (= m11 (store m00 j (+ i j))))

  (assert (= j1 (+ j 1)))
  (assert (= m12 (store m11 j1 (+ i j1))))

  (assert (= j2 (+ j1 1)))
  (assert (= m13 (store m12 j2 (+ i j2))))

  ; Primeira matriz definida
  (assert (= m1 (store m0 i m13)))

;; Segundo ciclo i = 2
  (assert (= i1 (+ i 1)))

  ; j=1
  (assert (= m21 (store m00 j (+ i1 j))))
  ; j=2
  (assert (= m22 (store m21 j1 (+ i1 j1))))
  ; j=3
  (assert (= m23 (store m22 j2 (+ i1 j2))))

  ; Segunda matriz definida
  (assert (= m2 (store m1 i1 m23)))

;; Terceiro ciclo i = 3
  (assert (= i2 (+ i1 1)))

  ; j=1
  (assert (= m31 (store m00 j (+ i2 j))))
  ; j=2
  (assert (= m32 (store m31 j1 (+ i2 j1))))
  ; j=3
  (assert (= m33 (store m32 j2 (+ i2 j2))))

  ; Matriz final definida
  (assert (= matriz (store m2 i2 m33)))


;; 1.3. Validação das Propriedades.

(push)
  (echo "=========")
  (echo "(a) Se i=j ⇒ M[i][j]≠3.")

  (declare-const i0 Int)
  (declare-const j0 Int)

  ; Como i e j são iguais, posso criar estas restrições. Note que (not (distinct)) → (=)
    ; (assert (= (select (select matriz i) j) 3))
    ; (assert (= (select (select matriz (+ i 1)) (+ j 1)) 3))
    ; (assert (= (select (select matriz (+ i 2)) (+ j 2)) 3))

  (assert (not (=> (= i0 j0) (not (= (select (select matriz i0) j0) 3)))))

  (check-sat)
  (echo "Dá sat, logo não se trata de uma consequência lógica.")

  (get-value (i0 j0))
  (get-value ((select (select matriz i0) j0)))

  (echo "=========")

  (pop)


; Para as restantes alineas, de modo a não haver repetição de restrições.
(declare-const ii Int)
(declare-const jj Int)
(declare-const aa Int)
(declare-const bb Int)

(assert (and (>= ii 1) (<= ii 3)))
(assert (and (>= jj 1) (<= jj 3)))
(assert (and (>= aa 1) (<= aa 3)))
(assert (and (>= bb 1) (<= bb 3)))


(push)
  (echo "(b) ∀i,j: i e j entre 1 e 3 então M[i][j]=M[j][i].")

  (assert (not (= (select (select matriz ii) jj) (select (select matriz jj) ii))))

  (check-sat)
  (echo "Dá unsat logo é uma consequência lógica das declarações da matriz.")
  (echo "=========")

  (pop)


(push)
  (echo "(c) Para quaisquer i e j entre 1 e 3, se i<j então M[i][j]<6.")

  (assert (not (=> (< ii jj) (< (select (select matriz ii) jj) 6))))

  (check-sat)
  (echo "Dá unsat logo é uma consequência lógica das declarações da matriz.")
  (echo "=========")

  (pop)


(push)
  (echo "(d) Para quaisquer i, a e b entre 1 e 3, se a > b então M[i][a]>M[i][b].")

  (assert (not (=> (> aa bb) (> (select (select matriz ii) aa) (select (select matriz ii) bb)))))

  (check-sat)
  (echo "Dá unsat logo é uma consequência lógica das declarações da matriz.")
  (echo "=========")

  (pop)


(push)
  (echo "(e) Para quaisquer i e j entre 1 e 3, M[i][j] + M[i+1][j+1] = M[i+1][j] + M[i][j+1].")

  (assert (not (= (+ (select (select matriz ii) jj) (select (select matriz (+ ii 1)) (+ jj 1))) (+ (select (select matriz (+ ii 1)) jj) (select (select matriz ii) (+ jj 1))))))

  (check-sat)
  (echo "Dá sat, logo não se trata de uma consequência lógica.")

  (get-value (ii jj))
  (get-value ((select (select matriz ii) (+ jj 1))))
  (get-value ((select (select matriz (+ ii 1)) (+ jj 1))))

  (echo "O valor calculado de i é 1 (ii=1) e de j é 3 (jj=3).")
  (echo "Notar que, M[i+1][j+1] → M[2][4] e M[i][j+1] → M[1][4].")
  (echo "Como a posição 4 não está definida na matriz (M[3][3]), o smt atribui valores para satisfazer o assert.")

  (echo "=========")
  (pop)

