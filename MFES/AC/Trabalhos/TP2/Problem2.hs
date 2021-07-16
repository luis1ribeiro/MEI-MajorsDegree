module Problem2 where

import DurationMonad
import Problem1
import Data.Maybe
import Control.Arrow
import Control.Monad
import Data.List
import Data.Bool

{- 1. *Labelled* graph structure: nodes and labelled adjacency matrix
(i.e. the labelled edges of the graph)
-}
adjT :: (Node,Node) -> Maybe Int
adjT p = case p of
           (A,B) -> Just 2
           (A,C) -> Just 3
           (A,F) -> Just 6
           (B,A) -> Just 30
           (B,C) -> Just 0
           (B,E) -> Just 4
           (B,F) -> Just 3
           (C,A) -> Just 60
           (C,B) -> Just 3
           (C,D) -> Just 50
           (D,C) -> Just 2
           (D,E) -> Just 3
           (E,B) -> Just 1
           (E,D) -> Just 3
           (E,F) -> Just 2
           (F,A) -> Just 4
           (F,B) -> Just 5
           (F,E) -> Just 3
           (_,_) -> Nothing

-- 2. Auxiliary functions
{- Given a node n and a list of nodes ns the function returns the nodes
in ns that can be reached from n in one step together with the time
necessary to reach them.
-}
-- !! to implement !!
tadjacentNodes :: Node -> [Node] -> [Duration Node]
tadjacentNodes n ns = ns >>= \x -> case adjT(n,x) of Just y -> return $ Duration (y, x)
                                                     Nothing -> []

-- 3. Main body
{- For each node a in ns, if a is not already in p the function creates
   a new path (like in the previous problem) and computes its cost.
-}
-- !! to implement !!
taddToEnd :: Duration Path -> [Duration Node] -> [Duration Path]
taddToEnd p@(Duration (cp, ps)) ns = ns >>= \d@(Duration (c,n)) -> if checkAdj n && alreadyInPath n ps then return $ addCost p d else [] where
    checkAdj n = adj (n, last ps)
    alreadyInPath n = not . elem n
    addCost p (Duration (c,n)) = p >>= \x -> Duration (c,x ++ [n])

-- .......
hCyclesCost :: Node -> [Duration Path]
hCyclesCost n = branch (return [n]) >>= hCyclesAux where
    hCyclesAux d@(Duration (c,p)) | ended p = bool [] (return $ d >>= addLast) $ adj (head p, last p)
                                  | otherwise = branch d >>= hCyclesAux
    ended p = sort p == sort allNodes
    branch d@(Duration (_,p)) = taddToEnd d (tadjacentNodes (last p) allNodes)
    addLast p = Duration (fromJust $ adjT (last p, head p), p ++ [head p])

{-
Alternative version
hCyclesCostPF :: Node -> [Duration Path]
hCyclesCostPF = addHead <$> removeNonAdj <$> flip (foldM $ flip ($)) expansions . (Duration . (const 0 &&& return)) where
    addHead = map (addLast =<<)
    removeNonAdj = filter $ adj . (last &&& head) . getValue
    expansions = replicate (length allNodes - 1) branch

tspPF = minimum . hCyclesCostPF
-}

-- the main program
tsp = minimum . hCyclesCost
