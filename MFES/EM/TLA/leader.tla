------------------------------- MODULE leader -------------------------------

EXTENDS Naturals, Sequences, FiniteSets

CONSTANTS N, id
Node == 1 .. N

ASSUME
    /\ N \in Nat \ {0}
    /\ id \in Seq(Nat) \* Todas as possíveis sequências de naturais
    /\ Len(id) = N
    /\ \A m,n \in Node : m # n => id[m] # id[n]

succ(n) == IF n = N THEN 1 ELSE n+1

Id == {i \in Nat : \E n \in Node : id[n] = i} \* Definir um conjunto por compreensão

VARIABLES inbox, outbox, elected

Init ==
    \* Definir funções por compreensão
    /\ inbox = [n \in Node |-> {}] \* no inbox
    /\ outbox = [n \in Node |-> {id[n]}] \* cada nodo põe na caixa outbox
    /\ elected = {} \* elected encontra-se vazio

send(n) == \E i \in outbox[n] :
        /\ outbox' = [outbox EXCEPT ![n] = @ \ {i} ] \* @ = outbox[n]
        /\ inbox' =  [inbox EXCEPT ![succ(n)] = @ \cup {i} ] \* @ = inbox[succ(n)]
        /\ UNCHANGED << elected >>

compute(n) == \E i \in inbox[n] :
        /\ inbox'  = [inbox EXCEPT ![n] = @ \ {i}]
        /\ outbox' = [outbox EXCEPT ![n] = @ \cup IF i > id[n] THEN {i} ELSE {}]
        /\ elected' = elected \cup IF i = id[n] THEN {i} ELSE {}

Next == \E n \in Node : send(n) \/ compute(n)

state == << inbox, outbox, elected >>

Spec == Init /\ [] [Next]_state /\ WF_state(Next)

\* Invariante de tipos
TypesOk ==
   /\ elected \subseteq Id
   /\ inbox \in [Node -> SUBSET(id)]
   /\ outbox \in [Node -> SUBSET(id)]

Safety == [] (Cardinality(elected) <= 1)
Liveness == <> (Cardinality(elected) >=1)

\* Abstract == INSTANCE abstract
\* Refinment == Spec => Abstract!Spec
\* Continua a não poder existir stutters invariance
=============================================================================
\* Modification History
\* Last modified Thu Dec 17 11:30:38 GMT 2020 by luis
\* Created Thu Dec 17 10:41:39 GMT 2020 by luis
