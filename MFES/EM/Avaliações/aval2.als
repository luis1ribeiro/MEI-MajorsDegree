sig Track {
  prox : lone Track,
  signal : lone Signal
}

sig Junction extends Track {}

sig Signal {}

fact {
  // Lines are acyclic
  no t : Track | t in t.^prox
}

pred inv1 {
  // Each signal belongs to one and only one track
  //signal.~signal in iden and Signal<:iden:>Signal in ~signal.signal
  signal.~signal in iden and (Signal.iden) in Signal.(~signal.signal)
}


pred inv2 {
  // Only junctions can have more than one predecessor track
  //all t : (Track - Junction) | lone prox.t
  (prox:>(Track-Junction)).~(prox:>(Track-Junction)) in iden
}



pred inv3 {
  // All tracks that meet at a junction must have a signal
	prox.Junction in signal.Signal
}
