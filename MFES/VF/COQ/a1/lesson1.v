(* ================================================================== *)
Section EX.

Variables (A:Set) (P : A->Prop).
Variable Q:Prop.

(*

  . intro,intros– introduction rule for A (several times)
  . apply– elimination rule for A
  . assumption– match conclusion with an hypothesis
  . exact– gives directly the exact proof term of the goal

*)

(* Check the type of an expression. *)
Check P.
Check Set.
Check A -> Prop.

Variable a:A.

Check P a.


Lemma trivial : forall x:A, P x -> P x.
Proof.
  (* intro y -> poe y no contexto como y:A invés do x. *)
  (* exact (fun (x : A) (H : P x) => H) -> Prova logo. *)
  intros. (* Passa tudo o q conseguir para contexto. *)
  assumption.
Qed.
(* Prints the definition of an identifier. *)
Print trivial.



Lemma example : forall x:A, (Q -> Q -> P x) -> Q -> P x.
Proof.
  intros x H H0. (* x: A, H: Q->Q->P x e H0:Q *)
  (* Provar P x *)
  (*
     Gamma |- A->B      Gamma |- A
     ------------------------------
                Gamma |- B
  *)
  apply H. (* Vou transformar o Px em Q->Q e provar esses Qs. *)
  assumption. (* Posso por exact H0 para provar Q, porque H0:Q *)
  exact H0. (* em vez de assumption. *)
Qed.

Print example.


Proposition nova : Q -> ~ ~ Q.
Proof.
  intros.
  unfold not.
  intros.
  apply H0.
  assumption.
Qed.           (* when we close the proof the definition of the identifier
                  "nova" goes to the global environment *)

Theorem demo : forall y,  Q -> (~ ~ Q -> P y) -> P y.
Proof.
  intros.
  apply H0.
  apply nova.   (* we can use a definition in the global environment *)
  assumption.
Qed.


End EX.

Print trivial.
Print example.
(* ================================================================== *)




(* ================================================================== *)
(* ====================== Propositional Logic ======================= *)
(* ================================================================== *)

Section ExamplesPL.

Variables Q P :Prop.

Lemma ex1 : (P -> Q) -> ~Q -> ~P.
Proof.
  tauto.
Qed.

Print ex1.

Lemma ex1' : (P -> Q) -> ~Q -> ~P.
Proof.
  intros. (* Não põe o ~P em contexto. *)
  intro.  (* Põe o ~P em contexto. P -> False e a meu goal fica False. *)
  apply H0. (* apply H0, fica como goal Q. *)
  apply H.
  assumption.
Qed.

Print ex1'.


Lemma ex2 : P /\ Q -> Q /\ P.
Proof.
  intro H. (* H -> P /\ Q *)
  split. (* split de H em 2 ramos. *)
  destruct H as [H1 H2]. (* H1 -> P e H2 -> Q *)
  (* elim H. intros H1 H2. funciona também *)
  exact H2. (* H2 assumimos verdadeiro. Só falta provar H1 -> P. H : P /\ Q. *)
  (* Tenho q dar destruct outra vez.*)
  destruct H. assumption. (* Quando tenho um ';' aplica a tatica a todas as subgoals. *)
Qed.

(* We can itemize the subgoals using - for each of them.
   Note that whem entering in this mode the other subgoals are not displayed.
   For nested item use the symbols -, +, *, --, ++, **, ...
*)
Lemma ex2' : P /\ Q -> Q /\ P.
Proof.
  intro H.  split.
  - destruct H as [H1 H2]. exact H2. (* Provar Q - subgoal *)
  - destruct H; assumption. (* Provar P - subgoal *)
Qed.


Lemma ex3 : P \/ Q -> Q \/ P.
Proof.
  intros. (* Por H em contexto *)
  destruct H as [h1 | h2]. (* H1 - P e H2 - Q*)
  - right. assumption. (* Regra de introdução do \/ *)
  - left; assumption.  (* Regra de introdução do \/ *)
Qed.



Theorem ex4 : forall A:Prop, A -> ~~A.
Proof.
  intros.
  intro. (* Poe o ~A em contexto e False como goal. *)
  apply H0. (* Posso aplicar H0 porque ~A : A->False, ficando como goal o A. *)
  exact H.
Qed.

Lemma ex4' : forall A:Prop, A -> ~~A.
Proof.
  intros.
  red.                    (* does only the unfolding of the head of the goal *)
  intro.
  unfold not in H0.       (* unfold – applies the delta rule for a transparent constant. *)
  apply H0; assumption.   (* exact (H0 H) *)
Qed.




Axiom double_neg_law : forall A:Prop, ~~A -> A.  (* classical *)

(* CAUTION: Axiom is a global declaration.
   Even after the section is closed double_neg_law is assume in the enviroment, and can be used.
   If we want to avoid this we should decalre double_neg_law using the command Hypothesis.
*)

Axiom meio_excluído : forall A:Prop, ~A \/ A.

Lemma me_e1 : ((Q -> P) -> Q) -> Q.
Admitted.

(* Ficha meio excluído *)
Lemma me_e2 : ~~Q -> Q.
Admitted.


Lemma ex5 : (~Q -> ~P) -> P -> Q.     (* this result is only valid classically *)
Proof.
  intros.
  apply double_neg_law. (* Usar o axioma em cima feito *)
  intro.
  (* apply H; assumption. *)
  apply H.
  - assumption.
  - assumption.
Qed.


Lemma ex6 : (P\/Q)/\~P -> Q.
Proof.
  intros.
  elim H. intros.
  destruct H0. (* Por o P em contexto para uma contradiction. Posso fazer tbm destrcut H. destruct H. *)
  - contradiction. (* Tenho P no contexto e ~P, logo é uma contradição. *)
  - assumption. (* match H0: Q com Q a provar *)
Qed.


Lemma ex7 : ~(P \/ Q) <-> ~P /\ ~Q.
Proof.
  red.
  split.
  - intros.
    split.
    + unfold not in H.
      intro H1. (* H1: P *)
      apply H.
      left. assumption. (* Dar match de H1 com P *)
    + intro H1; apply H; right; assumption.
  - intros H H1.
    destruct H.
    destruct H1.
    + contradiction.
    + contradiction.
Qed.


Lemma ex7' : ~(P \/ Q) <-> ~P /\ ~Q.
Proof.
  tauto.
Qed.



Variable B :Prop.
Variable C :Prop.


(* exercise *)
Lemma ex8 : (P->Q) /\ (B->C) /\ P /\ B -> Q/\C.
Proof.
  intros.
  split.
  - elim H. intros.
    elim H1. intros.
    elim H3. intros. (* O mesmo que: destruct *)
    apply H0.
    assumption.
  - elim H. intros.
    elim H1. intros.
    destruct H3. (* O mesmo que: elim H3. intros. *)
    apply H2.
    assumption.
Qed.

(* exercise *)
Lemma ex9 : ~ (P /\ ~P).
Proof.
  red. (* Tira o ~ e mete -> False. Assim podemos fazer o intros. *)
  intro.
  elim H. intros. (* H0: P e H1: ~P -> posso aplicar o contradiction. *)
  contradiction.
Qed.


End ExamplesPL.

(* ================================================================== *)
(* =======================  First-Order Logic ======================= *)
(* ================================================================== *)

Section ExamplesFOL.

Variable X :Set.
Variable t :X.
Variables R W : X -> Prop.

Lemma ex10 : R(t) -> (forall x, R(x)->~W(x)) -> ~W(t).
Proof.
  intros.
  apply H0.
  exact H.
Qed.


Lemma ex11 : forall x, R x -> exists x, R x.
Proof.
  intros.
  exists x.
  assumption.
Qed.


Lemma ex11' : forall x, R x -> exists x, R x.
Proof.
  firstorder.
Qed.



Lemma ex12 : (exists x, ~(R x)) -> ~ (forall x, R x).
Proof.
  intros H H1.
  destruct H as [x0 H0].
  apply H0.
  apply H1.
Qed.


(* Exercise *)
Lemma ex13 : (forall x, R x) \/ (forall x, W x) -> forall x, (R x) \/ (W x).
Admitted.

Variable G : X->X->Prop.

(* Exercise *)
Lemma ex14 : (exists x, exists y, (G x y)) -> exists y, exists x, (G x y).
Admitted.

(* Exercise *)
Proposition ex15: (forall x, W x)/\(forall x, R x) -> (forall x, W x /\ R x).
Admitted.


(* ------- Note that we can have nested sections ----------- *)
Section Relations.

Variable D : Set.
Variable Rel : D->D->Prop.

Hypothesis R_symmetric : forall x y:D, Rel x y -> Rel y x.
Hypothesis R_transitive : forall x y z:D, Rel x y -> Rel y z -> Rel x z.


Lemma refl_if : forall x:D, (exists y, Rel x y) -> Rel x x.
Proof.
  intros.
  destruct H.
  (* try "apply R_transitive" to see de error message *)
  apply R_transitive with x0.
  - assumption.
  - apply R_symmetric.
    assumption.
Qed.

Check refl_if.

End Relations.

Check refl_if. (* Note the difference after the end of the section Relations. *)



(* ====== OTHER USES OF AXIOMS ====== *)

(* --- A stack abstract data type --- *)
Section Stack.

Variable U:Type.

Parameter stack : Type -> Type.
Parameter emptyS : stack U.
Parameter push : U -> stack U -> stack U.
Parameter pop : stack U -> stack U.
Parameter top : stack U -> U.
Parameter isEmpty : stack U -> Prop.

Axiom emptyS_isEmpty : isEmpty emptyS.
Axiom push_notEmpty : forall x s, ~isEmpty (push x s).
Axiom pop_push : forall x s, pop (push x s) = s.
Axiom top_push : forall x s, top (push x s) = x.

End Stack.

Check pop_push.

(* Now we can make use of stacks in our formalisation!!! *)

(* A NOTE OF CAUTION!!! *)
(* The capability to extend the underlying theory with arbitary axiom
   is a powerful but dangerous mechanism. We must avoid inconsistency.
*)
Section Caution.

Check False_ind.

Hypothesis ABSURD : False.

Theorem oops : forall (P:Prop), P /\ ~P.
elim ABSURD.
Qed.

End Caution. (* We have declared ABSURD as an hypothesis to avoid its use outside this section. *)



