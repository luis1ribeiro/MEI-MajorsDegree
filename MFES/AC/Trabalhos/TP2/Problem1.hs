module Problem1 where

import Control.Monad
import Control.Arrow
import Data.Bool
import Data.List

-- 1. Graph structure: nodes and adjacency matrix (i.e. the edges)
data Node = A | B | C | D | E | F deriving (Show,Eq,Ord)

adj :: (Node,Node) -> Bool
adj p = case p of
  (A,B) -> True
  (A,C) -> True
  (A,F) -> True
  (B,A) -> True
  (B,C) -> True
  (B,E) -> True
  (B,F) -> True
  (C,A) -> True
  (C,B) -> True
  (C,D) -> True
  (D,C) -> True
  (D,E) -> True
  (E,B) -> True
  (E,D) -> True
  (E,F) -> True
  (F,A) -> True
  (F,B) -> True
  (F,E) -> True
  (_,_) -> False

type Path = [Node]

-- 2. Auxiliary functions
adjacentNodes :: Node -> [Node] -> [Node]
adjacentNodes n ns = filter (\x -> adj(n,x)) ns

allNodes :: [Node]
allNodes = [A,B,C,D,E,F]

choice :: ([a],[a]) -> [a]
choice = uncurry (++)

-- 3. Main body
{- For each node a in ns, if a is not already in p the function
   creates a new path by adding to the end of p the element a.
-}
-- !! To implement !!
addtoEnd :: Path -> [Node] -> [Path]
addtoEnd p ns = ns >>= (\n -> if adj(n, last p) && not (elem n p) then return $ p ++ [n] else [])

addtoEndFolded :: Path -> [Node] -> [Path]
addtoEndFolded p = foldr (\a b -> if not (elem a p) && adj(a,last p) then (p ++ [a]) : b else b) []

-- Computes all Hamiltonian cycles starting from a given node
-- !! To implement !!
hCycles :: Node -> [Path]
hCycles n = addtoEnd [n] allNodes >>= hCyclesAux where
  hCyclesAux p | ended p = bool [] (return $ p ++ [head p]) $ adj (head p, last p)
               | otherwise = addtoEnd p allNodes >>= hCyclesAux
  ended p = sort p == sort allNodes

{-
Alternative version

hCyclesPF :: Node -> [Path]
hCyclesPF = addHead <$> removeNonAdj <$> flip (foldM $ flip ($)) expansions . return where
    addHead = map $ choice . (id &&& (return . head))
    removeNonAdj = filter $ adj . (head &&& last)
    expansions = replicate (length allNodes - 1) $ flip addtoEnd allNodes
-}
