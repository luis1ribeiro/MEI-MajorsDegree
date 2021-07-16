(* ========================================================= *)
(* =============== TPC8 -> Coq(2) - Questões =============== *)
(* ========================================================= *)

Set Implicit Arguments.
Require Import List.

Inductive In (A:Type) (y:A) : list A -> Prop :=
  | InHead : forall (xs:list A), In y (cons y xs)
  | InTail : forall (x:A) (xs:list A), In y xs -> In y (cons x xs).

Inductive Prefix (A:Type) : list A -> list A -> Prop :=
  | PreNil : forall (l:list A), Prefix nil l
  | PreCons : forall (x:A) (l1 l2:list A), Prefix l1 l2 -> Prefix (x::l1) (x::l2).

Inductive SubList (A:Type) : list A -> list A -> Prop :=
  | SLnil : forall (l:list A), SubList nil l
  | SLcons1 : forall (x:A) (l1 l2:list A), SubList l1 l2 -> SubList (x::l1) (x::l2)
  | SLcons2 : forall (x:A) (l1 l2:list A), SubList l1 l2 -> SubList l1 (x::l2).


Theorem e1_a : SubList (5::3::nil) (5::7::3::4::nil).
Proof.
  apply SLcons1. apply SLcons2. apply SLcons1.  apply SLnil.
Qed.

Theorem e1_b : forall (A:Type) (l:list A),  SubList l l.
Proof.
  induction l.
  - apply SLnil.
  - apply SLcons1. assumption.
Qed.

Theorem e1_c : forall (A B:Type) (f:A->B) (l1 l2:list A), SubList l1 l2 -> SubList (map f l1) (map f l2).
Proof.
  intros.
  induction l2.
  - inversion H. apply SLnil.
  - elim H. intros.
    + apply SLnil.
    + intros. simpl. apply SLcons1. assumption.
    + intros. simpl. apply SLcons2. assumption.
Qed.

Theorem e1_d : forall (A:Type) (x:A) (l : list A), In x l -> exists l1, exists l2, l = l1 ++ (x::l2).
Proof.
  intros.
  induction H.
  - exists nil. exists xs. simpl. reflexivity.
  - destruct IHIn. exists (x0 :: x1). simpl. destruct H0.  exists x2. rewrite H0. reflexivity.
Qed.



(* Defina a função recursiva drop que dado um número naturalne uma lista l, retira os n primeiros elementos de l. *)
Fixpoint drop (A: Type) (n: nat) (l: list A) : list A :=
 match l with
  | nil => nil
  | cons x t => match n with
                  | 0 => l
                  | _ => drop (n-1) t
                end
  end.

Theorem e2_a : drop 2 (5::7::3::4::nil) = 3::4::nil.
Proof.
  simpl. reflexivity.
Qed.


Theorem e2_drop0_is_l : forall (A:Type) (n:nat) (l: list A), drop 0 l = l.
Proof.
  induction l.
  - reflexivity.
  - reflexivity.
Qed.

Theorem e2_b : forall (A:Type) (n:nat) (l:list A), SubList (drop n l) l.
Proof.
  intros H n. induction n.
  - intros.
    rewrite e2_drop0_is_l.
    apply e1_b. constructor.
  - induction l.
    + constructor.
    + simpl. rewrite (PeanoNat.Nat.sub_0_r n). constructor. apply IHn.
Qed.

Inductive Sorted : list nat -> Prop :=
| SNil : Sorted nil
| SCons0 : forall (x:nat), Sorted (x::nil)
| SCons1 : forall (x y:nat) (l:list nat), x <= y -> Sorted (y::l) -> Sorted (x::y::l).

Theorem ex3_a : forall (x y:nat) (l:list nat), x<=y -> (Sorted (y::l)) -> Sorted (x::l).
Proof.
  intros. induction l.
  - constructor.
  - generalize H0. generalize H.
    clear H0 H.
    constructor.
    + inversion H0.
       rewrite H3 in H. assumption.
    + inversion H0. assumption.
Qed.

Theorem ex3_b : forall (x y:nat) (l:list nat), (In y l) /\ (Sorted (x::l)) -> x <= y.
Proof.
  intros. destruct H. induction H. inversion H0.
  - assumption.
  - inversion H0. apply (ex3_a H3) in H5. apply IHIn in H5. assumption.
Qed.

Theorem e4_a : forall (A:Type) (l:list A), Prefix l l.
Proof.
  intros. induction l.
  - constructor.
  - constructor. assumption.
Qed.

SearchPattern(list _).
Theorem e4_b : forall (A:Type) (l1 l2 l3:list A), Prefix l1 l2 /\ Prefix l2 l3 -> Prefix l1 l3.
Proof.
  intros. destruct H.
  assert(forall (A: Type) (l l' : list A), Prefix l l' -> SubList l l').
  - intros. induction H1.
    + constructor.
    + constructor. assumption.
  - apply H1 in H. apply H1 in H0.
    assert(forall (A: Type) (l l' l'' : list A), SubList l l' -> SubList l' l'' -> SubList l l'').
    + intros. simpl. inversion H3.
      * assert(forall (A:Type) (l: list A), SubList l nil -> l = nil).
        ** intros. inversion H6. reflexivity.
        ** rewrite <- H4 in H2. apply H6 in H2. rewrite H2. constructor.
      * Admitted.
(* Não consegui provar este. Nem com inductions sobre as listas l1 l2 l3. *)

SearchPattern(_ = _ -> _ = _).
Theorem e4_c : forall (A:Type) (l1 l2:list A), Prefix l1 l2 /\ Prefix l2 l1 -> l1 = l2.
Proof.
  intros. destruct H. induction H.
  - assert(forall (A:Type) (l: list A), Prefix l nil -> l = nil).
    + intros. inversion H. reflexivity.
    + apply eq_sym. apply H. assumption.
  - destruct IHPrefix.
    + inversion H0. assumption.
    + reflexivity.
Qed.

