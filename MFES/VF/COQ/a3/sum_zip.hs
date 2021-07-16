module Sum_zip where

import qualified Prelude

prod_rect :: (a1 -> a2 -> a3) -> ((,) a1 a2) -> a3
prod_rect f p =
  case p of {
   (,) x x0 -> f x x0}

prod_rec :: (a1 -> a2 -> a3) -> ((,) a1 a2) -> a3
prod_rec =
  prod_rect

list_rect :: a2 -> (a1 -> (([]) a1) -> a2 -> a2) -> (([]) a1) -> a2
list_rect f f0 l =
  case l of {
   ([]) -> f;
   (:) y l0 -> f0 y l0 (list_rect f f0 l0)}

list_rec :: a2 -> (a1 -> (([]) a1) -> a2 -> a2) -> (([]) a1) -> a2
list_rec =
  list_rect

type Sig a = a
  -- singleton inductive, whose constructor was exist
  
sum_zip_spec :: (([]) ((,) Prelude.Int Prelude.Int)) -> (([]) Prelude.Int)
sum_zip_spec l' =
  list_rec ([]) (\a _ iHl' ->
    prod_rec (\a0 b -> (:) ((Prelude.+) a0 b) iHl') a) l'

