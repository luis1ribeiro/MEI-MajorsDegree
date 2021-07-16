--------------------------------- MODULE e1 ---------------------------------
\* A ESPECIFICAÇÃO TEM QUE SER ESCRITA NESTE MODULE

EXTENDS Naturals

CONSTANTS N
\* Número natural positivo
ASSUME N \in Nat \ {0}

Worker == 1 .. N

VARIABLES Prepared, Committed, Aborted

\* PREDICADO INICIAL - Como não há tipos, não sabe que Committed está dentro do Prepared
Init == Prepared = {} /\ Committed = {} /\ Aborted = {}

Finish(w) ==
    /\ w \notin Prepared
    /\ w \notin Aborted
    \* \cup é a união e temos que englobar o w num conjunto
    /\ Prepared' = Prepared \cup {w}
    /\ UNCHANGED << Committed, Aborted >>
    \* Significa Committed'=Committed e Aborted'=Aborted

Abort(w) ==
    /\ w \notin Aborted
    /\ w \in Prepared => Aborted # {}
    /\ Prepared' = Prepared \ {w}
    /\ Aborted' = Aborted \cup {w}
    /\ UNCHANGED << Committed >>

Commit(w) ==
    /\ w \in Prepared \ Committed
    /\ Aborted = {}
    /\ Committed' = Committed \cup {w}
    /\ UNCHANGED << Prepared, Aborted >>

\* Quando um evento acontece
Next == \E w \in Worker : Finish(w) \/ Abort(w) \/ Commit(w)

state == << Prepared, Committed, Aborted >>
\* [] -> Always / <> -> Eventually
\* Next ou nops (Nada acontece)
Spec == Init /\ [] [Next]_state /\ WF_state (\E w \in Worker : Commit(w))

Consistency == [] (Committed = {} \/ Aborted = {})

Stability == \A w \in Worker :
                    /\ [] (w \in Committed => [] (w \in Committed))
                    /\ [] (w \in Aborted => [] (w \in Aborted))

\* Se existe alguém em Committed então eventualmente todos os Workers vão estar Committed
\* Pode adicionar nops ou stutter steps sempre e impedir que não aconteça nada - FAIRNESS (add WF ao Spec)                 
Progress == [] (Committed # {} => <> (Worker \subseteq Committed))
=============================================================================
\* Modification History
\* Last modified Thu Dec 17 10:40:05 GMT 2020 by luis
\* Created Thu Dec 17 09:17:12 GMT 2020 by luis
