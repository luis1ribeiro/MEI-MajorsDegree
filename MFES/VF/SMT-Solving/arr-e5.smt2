(set-logic QF_AUFLIA)

(set-info :source |

====== OBSERVAÇÔES sobre a modelação lógica de atribuições e arrays =======

As atribuições como x := x + 1 são codificadas criando variáveis (e.g. x0 e x1)
que representam o valor de x antes e depois da atribuição.
A codificação lógica seria neste caso (= x1 (+ x0 1)).

Um acesso ao array a[i] é codificada por (select a i).

A escrita de um valor v na posição i de um array a é representada por
(store a i v). O resultado é um novo array em tudo igual ao primeiro excepto
na posição i que tem agora o valor v.

Note que o array é modelado logicamente como uma função, pelo que a atribuição
a um array é codificada criando variáveis do tipo array que representam o array
antes e depois da atribuição.
Por exemplo, a[i] := v  é modelada assim: (= a1 (store a0 i v)))

|)


;; ======== PROGRAMA =======
;; x = a[i];
;; y = y + x;
;; a[i] = 5 + a[i];
;; a[i+1] = a[i-1] - 5;


(declare-fun a0 () (Array Int Int))
(declare-const a1 (Array Int Int))   ; outra forma de declarar constantes
(declare-const a2 (Array Int Int))
(declare-const x0 Int)
(declare-const y0 Int)
(declare-const y1 Int)
(declare-const i0 Int)

; Program Asserts
(assert (= x0 (select a0 i0)))
(assert (= y1 (+ y0 x0)))
(assert (= a1 (store a0 i0 (+ 5 (select a0 i0)))))
(assert (= a2 (store a1 (+ i0 1) (- (select a1 (- i0 1)) 5))))

(push)
  (echo "No final da execução, verifica-se a seguinte propriedade: x + a[i-1] = a[i] + a[i+1]")
  (assert (not (= (+ x0 (select a2 (- i0 1))) (+ (select a2 i0) (select a2 (+ i0 1))))))
  (check-sat)
  (pop)

(push)
  (echo "No final da execução, a soma dos valores guardados em a[i-1] e a[i] é sempre positiva.")
  (assert (not (> (+ (select a2 (- i0 1)) (select a2 i0)) 0)))
  (check-sat)
  (pop)

(push)
  (echo "Se o valor inicial de y for inferior a 5,  então no final da execução,  o valor de a[i] é superior ao de y.")
  (assert (not (=> (< y0 5) (> (select a2 i0) y1))))
  (check-sat)
  (pop)

