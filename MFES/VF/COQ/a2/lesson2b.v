(* ================================================================== *)
(* =============== Reasoning about lists and naturals =============== *)
(* ================================================================== *)

Require Import List.

Set Implicit Arguments.

Print list.
Print app.

Locate "::".
Locate "++".


(* three similar proofs by induction using different tactics *)

Theorem app_l_nil : forall (A:Set) (l:list A), app l nil = l.
Proof.
  intros A l.
  pattern l. (* pattern performs a beta-expansion *)
Check list_ind.
  apply list_ind.
  - reflexivity. (* Quando temos uma igualdade. *)
  - intros a l0 IH. simpl. rewrite IH.  (* IH: 10 ++ nil -> 10 *)
    reflexivity.
Qed.

Theorem app_l_nil' : forall (A:Set) (l:list A), app l nil = l.
Proof.
  intros A l.
  elim l. (* Vai aplicar o eliminador das listas -> list_ind *)
  - reflexivity.
  - intros a l0 IH. simpl. rewrite IH. reflexivity.
Qed.

Theorem app_l_nil'' : forall (A:Set) (l:list A), app l nil = l.
Proof.
  induction l. (* Indução sobre listas à lista l. *)
  - reflexivity.
  - simpl. rewrite IHl. reflexivity.
Qed.


Print nat.
Print length.


(*
 Exercise: prove that the length of the append of two lists is equal
           to the addition of the length of each list
*)

Proposition len_app: forall (A:Set) (l l_:list A), length (l ++ l_) = length l + length l_.
Proof.
  intros. (* Mete as 2 listas no contexto. *)
  induction l.
  - simpl. reflexivity.
  - simpl. rewrite IHl. reflexivity.
           (* f_equal. assumption. *)
Qed.

Fixpoint snoc (A:Type) (a:A) (l:list A) {struct l} : list A :=
    match l with
      | nil => a::nil
      | x::xs => x::(snoc a xs) (* chamada recursiva com termos estruturamente menores -> xs é a cauda de x:xs,
                                   garantindo a terminação da função -> valid type checking. *)
    end.


Lemma snoc_len : forall (A:Set) (a:A) (l:list A), length (snoc a l) =  1 + (length l).
Proof.
  intros.
  induction l.
  - simpl. (* l = l *) reflexivity.
  - simpl.
    rewrite IHl. simpl.
    reflexivity.
Qed.

(* Exercise: *)
Lemma snoc_app : forall (A:Set) (a:A) (l:list A), snoc a l =  l ++ (a::nil).
Proof.
  intros.
  induction l.
  - reflexivity.
  - simpl.
    rewrite IHl. simpl.
    reflexivity.
Qed.


(* A predicate defined recursively *)
Fixpoint In (A:Set) (a:A) (l:list A) {struct l} : Prop :=
    match l with
      | nil => False
      | cons x xs => x = a \/ In a xs
    end.


Lemma in_app : forall (A:Set) (l1 l2:list A) (a:A),
                           In a (app l1 l2) -> In a l1 \/ In a l2.
Proof.
  intros.
  generalize H.  (* generalize – reintroduces an hypothesis into the goal *)
  clear H.       (* clear – removes an hypothesis from the environment *)
  induction l1.
  - simpl. intro H. right. (* lado direito da dijunção. *) assumption.
  - intros.  simpl in H. (* simplificação sobre uma hipotese. *) destruct H as [H|H].
    + rewrite H. left. simpl. left. reflexivity.
    + apply IHl1 in H as [H0|H0]. (* H0 em ramos diferentes de prova. *)
      * left. simpl. right. assumption.
      * right; assumption.
Qed.


Print rev.

Lemma rev_rev_l : forall (A:Set) (l:list A), rev (rev l) = l.
Proof.
  induction l.
  - simpl. reflexivity.
  - simpl.
(* This auxiliary lemma would help...
Lemma rev_aux : forall (A:Set) (l: list A) (a:A), rev (l ++ (a :: nil)) = a :: (rev l).
You can prove it before this lemma or you can use the tactic assert as follows.
*)
    assert (rev_aux : forall (A:Set) (l: list A) (a:A), rev (l ++ (a :: nil)) = a :: (rev l)).
    + induction l0.
      * reflexivity.
      * intro. simpl. rewrite IHl0.
        simpl. reflexivity.
    + rewrite rev_aux. (* f_equal. assumption. *)
      rewrite IHl. reflexivity.
Qed.



Print nat.

(* A property (predicate) on natural numbers *)
Inductive Even : nat -> Prop :=
| Even_base : Even 0
| Even_step : forall n, Even n -> Even (S (S n)).

(*

  ------ (Even base)
  Even 0

  Even n
  ------ (Even_step)
  Even(S (S n)) --> Sucessor do sucessor também é par.

*)

Lemma not_1_even : ~(Even 3).
Proof.
  red.
  intros.
  inversion H. (* Even 1 porque Suc Suc 1 = 3 *) inversion H1. (* False, porque o 1 não é Suc Suc de nenhum x. *)
(* inversion_clear H. inversion H0.  *)
Qed.



Proposition sum_even : forall n m:nat, Even n -> Even m -> Even (n+m).
Proof.
  intros.
  induction H.
  - simpl. assumption.
  - simpl. apply Even_step. (* constructor whould work here also *)
    assumption.
Qed.


Lemma  s_n_even : forall n:nat, Even n -> ~ Even (1+n).
Proof.
  intros n H. simpl.
  induction H.
  - intro. inversion H.
  - intro. inversion_clear H0. (* Even (S(S(S n))) -> Even (S n) *) contradiction.
Qed.


Lemma double_even : forall n:nat, Even (2*n).
Proof.
  intros. simpl. elim n.
  - simpl. constructor.  (* apply Even_base. *)
  - intros. simpl.
    cut (forall x y:nat, x+(S y) = S (x+y)).   (* similar to assert *)
    + intros. rewrite H0. constructor. assumption.
    + clear H. intros. induction x.
      * reflexivity.
      * simpl. rewrite IHx. reflexivity.
Qed.

(*
 Exercise: rewrite the prove of the previous lemma without using the cut tactic.
           Hint: use the command "SearchAbout plus." to find out a useful lemma in the database.

 Lemma double_even' : forall n:nat, Even (2*n).
*)



(*
 Exercise: define the "Odd" predicate and prove that for every n, (Even n)->(Odd (S n)).
*)



(* An inductive relation "x is the last element of list l" *)
Inductive Last (A:Type) (x:A) : list A -> Prop :=
| last_base : Last x (cons x nil)
| last_step : forall l y, Last x l -> Last x (cons y l).


Lemma last_nil : forall (A:Type) (x:A), ~(Last x nil).
Proof.
  intros. red. intro. inversion H. (* não tem nenhum construtor possível para construir o termo H: Last x nil. *)
Qed.


(* The prove of  ~(Last x nil)  without using the inversion tactic. *)

Lemma last_nil_aux : forall (A:Type) (l: list A) (x:A), Last x l -> l=nil -> False.
Proof.
  intros A l x H. elim H.
  - intro H0. (* H0 : x :: nil = nil, uma lista não vazia não pode ser uma lista vazia. *) discriminate H0.
  - intros.   (* H2 : y :: 10 = nil,  uma lista não vazia não pode ser uma lista vazia. *) discriminate H2.
Qed.

Theorem last_nil' : forall (A:Type) (x:A), ~(Last x nil).
Proof.
  intros. intro.
  apply last_nil_aux with A nil x.
  - assumption.
  - reflexivity.
Qed.



(* Exercise:
Lemma rev_last : forall (A:Type) (x:A) (l: list A), (Last x (rev (x::l))).
(* An auxiliary lemma can be useful! *)

*)

