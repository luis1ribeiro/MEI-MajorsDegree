*
A labeled transition system (LTS) is comprised by States, a sub-set
of which are Initial, connected by transitions, here represented by
Events.
*/
sig State {
        trans : Event -> State
}
sig Init in State {}
sig Event {}

/*
The LTS does not contain deadlocks, ie, each state has at least a
transition.
*/
pred inv1 {
  trans.State.Event = State
}

/*
There is a single initial state.
*/
pred inv2 {
  one Init
}

/*
The LTS is deterministic, ie, each state has at most a transition for each event.
*/
pred inv3 {
  all s: State | ~(s.trans).(s.trans) in iden
}

/*
All states are reachable from an initial state.
*/
pred inv4 {
  Init.^{x,y: State | some x.trans.y} = State
}

/*
All the states have the same events available.
*/
pred inv5 {
  all disj s, ss: State | s.trans.State = ss.trans.State
}

/*
Each event is available in at least a state.
*/
pred inv6 {
  Event in State.trans.State
}

/*
The LTS is reversible, ie, from a reacheable state it is always possible
to return to an initial state.
*/
pred inv7 {
}
