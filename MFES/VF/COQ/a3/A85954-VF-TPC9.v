(* ========================================================= *)
(* =============== TPC9 -> Coq(3) - Questões =============== *)
(* ========================================================= *)

Require Import ZArith.
Require Import List.
Set Implicit Arguments.
Require Extraction.

Extraction Language Haskell.
Require Import ExtrHaskellBasic.
Require Import ExtrHaskellNatInt.

(* Função que com um n arbitrário e um valor x, produz uma lista com n elementos x. *)
Inductive rep (A: Type) : A -> nat -> list A -> Prop :=
    | rep_nil  : forall x, rep x 0 nil
    | rep_cons : forall x n l, rep x n l -> rep x (S n) (x::l) .

Theorem rep_spec : forall (A:Type) (x: A) (n:nat), { l: list A | rep x n l }.
Proof.
  intros.
  induction n.
  - exists nil. constructor.
  - destruct IHn. exists (x::x0). apply rep_cons in r. assumption.
Qed.

Extraction "rep" rep_spec.

(* Função que recebe uma lista de pares de números naturais, e produz a lista com as somas das partes constituintes de cada par da lista. *)
Inductive sum_zip  : list (nat * nat) -> (list nat) -> Prop :=
    | sz_nil  : sum_zip nil nil
    | sz_cons : forall x y l1 l2, sum_zip l1 l2 -> sum_zip ((x,y)::l1) ((x+y)::l2) .

Theorem sum_zip_spec : forall (A:Type) (l':list (nat * nat)), { l: list nat | sum_zip l' l }.
Proof.
  induction l'; intros.
  - exists nil. constructor.
  - destruct IHl'. induction a. exists ((a+b)::x). constructor. assumption.
Qed. 

Extraction "sum_zip" sum_zip_spec.



(* Recorde a função count que conta o número de ocorrencias de um inteiro numa lista de inteiros. *)
Fixpoint count (z:Z) (l:list Z) {struct l} : nat :=
  match l with
    | nil => 0%nat
    | (z' :: ll) => if (Z.eq_dec z z')
                    then S (count z ll)
                    else count z ll
  end.

Theorem len_corr : forall (x:Z) (a:Z) (l:list Z), x <> a ->  count x (a :: l) = count x l.
Proof.
  induction l.
  - simpl. intros. destruct (Z.eq_dec x a).
    + contradiction.
    + reflexivity.
  - simpl count. destruct (Z.eq_dec x a); intros.
    + contradiction.
    + reflexivity.
Qed.

(* Print Z.eq_dec. *)
Inductive countI : Z -> (list Z) -> nat -> Prop :=
  | count_nil   : forall (z: Z), countI z nil 0
  | count_cons1 : forall (z: Z) (l: list Z) (n: nat), countI z l n -> countI z (z::l) (S n)
  | count_cons2 : forall (z z' :Z) (l: list Z) (n: nat), z <> z' -> countI z l n -> countI z (z'::l) n.


Theorem len_corr_v2 : forall (x:Z) (a:Z) (l:list Z) (n:nat) , x <> a ->  countI x (a :: l) n <-> countI x l n.
Proof.
  intros.
  split.
  - intros. inversion H0.
    + contradiction.
    + assumption.
  - constructor; assumption.
Qed.
