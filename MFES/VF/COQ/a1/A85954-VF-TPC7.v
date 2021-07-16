(* ================================================================== *)
(* ====================== Propositional Logic ======================= *)
(* ================================================================== *)

Section PropositionalLogic.

Variables A B C D :Prop.


(* e1 - (A→C)∧(B→C)→(A∧B)→C *)
Lemma e1 : (A->C) /\ (B->C) -> (A /\ B) -> C.
Proof.
  intros.
  (* Separar os /\ para ser poder aplicar os predicados separadamente. *)
  destruct H.
  destruct H0.
  apply H1. (* Como tenho B e A no contexto posso fazer apply de H1 (A->C) ou de H2 (B->C). *)
  exact H2.
Qed.

(* e2 - ¬A∨¬B→¬(A∧B) *)
Lemma e2 : ~A \/ ~B -> ~(A /\ B).
Proof.
  intros.
  intro. (* Tirar o ~, e por como prova o False. Poderia também fazer com o red. *)
  destruct H. (* Separar o ~A \/ ~B em 2 objetivos de prova. *)
  (* ~A no contexto. *)
  - destruct H0.
    contradiction.
  (* ~B no contexto. *)
  - destruct H0.
    contradiction.
Qed.

(* e3 - (A→(B∨C))∧(B→D)∧(C→D)→(A→D) *)
Lemma e3 : (A -> (B \/ C)) /\ (B -> D) /\ (C -> D) -> (A -> D).
Proof.
  intros.
  destruct H.
  destruct H1.
  destruct H. (* destruct do A->B\/C *)
  - assumption. (* O A já está no contexto portanto é só fazer assumption. *)
  - apply H1. exact H. (* B no contexto. Aplicamos H1 a D e fazemos assumption de B. *)
  - apply H2. exact H. (* C no contexto. Aplicamos H1 a D e fazemos assumption de C. *)
Qed.

(* e4 - (A∧B)→¬(¬A∨¬B) *)
Lemma e4 : (A /\ B) -> ~ (~A \/ ~B).
Proof.
  intros.
  intro. (* Tirar o ~, e por como prova o False. *)
  destruct H0. (* Separar o ~A \/ ~B em 2 objetivos de prova. *)
  (* ~A no contexto *)
  - destruct H. (* destruct do /\ *)
    contradiction.
  (* ~B no contexto *)
  - destruct H. (* destruct do /\ *)
    contradiction.
Qed.


End PropositionalLogic.

(* ================================================================== *)
(* =======================  First-Order Logic ======================= *)
(* ================================================================== *)

Section FOLogic.

Variable X :Set.
Variable t :X.
Variables R Q P  : X -> Prop.


(* e1 - (∀x.P(x)→Q(x))→(∀y.¬Q(y))→(∀x.¬P(x)) *)
Lemma e1_fo: (forall x, P x -> Q x) -> (forall y, ~(Q y)) -> (forall x, ~(P x)).
Proof.
  intros.
  intro. (* Por o P x em contexto, pondo False como goal. *)
  apply (H0 x). (* Sendo o meu goal False, posso fazer apply no ~(Q y). Instanciei o x do forall como x que está em contexto. *)
  (* Agora a prova é direta. *)
  apply H.
  exact H1.
Qed.

(* e2 - (∀x.P(x)∨Q(x))→(∃y.¬Q(y))→(∀x.R(x)→¬P(x))→(∃x.¬R(x)) *)
Lemma e2_fo: (forall x, P x \/ Q x) -> (exists y, ~(Q y)) -> (forall x, R x -> ~(P x)) -> (exists x, ~(R x)).
Proof.
  intros.
  destruct H0 as [y H2]. (* Antes de fazer o exists declaro um y do tipo X. *)
  exists y. (* Agora posso aplicar o exists ao goal exists x. *)
  intro. (* Retiro o ~, R y em contexto e como goal False. *)
  apply (H1 y). (* Posso aplicar False a H1 porque ~(P x) : P x -> False. Resultando em 2 objetivos de Prova. *)
  (* Provar R y *)
  - exact H0.
  (* Provar P y *)
  - destruct (H y).
    + exact H3. (* O assumption é direto P y - P y *)
    + contradiction. (* (Q y) e ~(Q y) estão ambos em contexto -> contradição. *)
Qed.


End FOLogic.

(* ================================================================== *)
(* =========================  Classic Logic ========================= *)
(* ================================================================== *)

Section CLogic.

Variable X :Set.
Variables P: X -> Prop.
Variables A B: Prop.

(* Assumindo o princípio do meio excluído como axioma. *)
Axiom pme: forall A:Prop, (A \/ ~A).


(* e1 - (¬A→B)→(¬B→A) *)
Lemma e1_cl: (~A -> B) -> (~B -> A).
Proof.
  intros.
  (* Elimination do axioma usando a Proposição A, visto que tenho A como goal. *)
  destruct pme with A.
  + exact H1. (* Tenho A no contexto e A como goal, portanto posso fazer assumption. *)
  + apply H in H1. (* Posso usar a implicação de H e introduzir B no contexto. *)
    contradiction. (* Tendo B e ~B no contexto, trata-se de uma contradição. *)
Qed.


(* e2 - ¬(∃x.¬P(x)→∀x.P(x) *)
Lemma e2_cl: ~(exists x, ~(P x)) -> forall x, P x.
Proof.
  intros.
  (* Aqui a estratégia é a mesma, tendo P x como goal, uso a tática destruct do axioma no goal que quero provar. *)
  (* Elimination do axioma usando a Proposição P x. Introduzindo P x -> Goal e ~ P x -> Goal como goals. *)
  destruct pme with (P x).
  + exact H0. (* P x -> P x é provado diretamente. *)
  + destruct H. exists x. exact H0.
   (* Diretamente depois de destruir o exists, visto que posso introduzir de seguida dado que tenho uma variável do tipo x : X. *)
Qed.


(* e3 - ¬(∀x.¬P(x))→∃x.P(x) *)
Lemma e3_cl: ~(forall x, ~(P x)) -> exists x, P x.
Proof.
  intros.
  (* Aqui a estratégia é a mesma, tendo (exists x, Px) como goal, uso a tática destruct do axioma no goal que quero provar. *)
  destruct pme with (exists x, P x).
  + exact H0. (* Tenho (exists x, P x) no contexto, portanto trata-se de uma assumption. *)
  + unfold not in H. destruct H. intros. (* introduzo um x : X no contexto *)
    unfold not in H0. apply H0. (* aplico x ao exists. *)
    exists x. (* Como tenho um x no contexto, posso aplicar o exists. *)
    exact H. (* P x como goal e H1: P x, portanto trata-se de uma assumption. *)
Qed.

End CLogic.
