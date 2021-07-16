module Rep where

import qualified Prelude

nat_rect :: a1 -> (Prelude.Int -> a1 -> a1) -> Prelude.Int -> a1
nat_rect f f0 n =
  (\fO fS n -> if n Prelude.== 0 then fO () else fS (n Prelude.- 1))
    (\_ -> f)
    (\n0 -> f0 n0 (nat_rect f f0 n0))
    n

type Sig a = a
  -- singleton inductive, whose constructor was exist
  
rep_spec :: a1 -> Prelude.Int -> (([]) a1)
rep_spec x n =
  nat_rect ([]) (\_ iHn -> (:) x iHn) n

