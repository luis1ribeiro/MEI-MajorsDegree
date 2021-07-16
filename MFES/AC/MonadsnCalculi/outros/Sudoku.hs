module Sudoku where

import Data.List.Split hiding (split)
import Data.List
import Cp

n = 2
nsq = n^2

fst3 (a,_,_) = a
snd3 (_,a,_) = a
thr3 (_,_,a) = a

sortTpl :: (Int, Int) -> (Int, Int)
sortTpl = cond (uncurry (>)) swap id

tpl3 ((a,b),c) = (a,b,c)

vars = zip [(l,c,num) | l <- lines, c <- cols, num <- nums] nvars
  where
    lines = [1..nsq]
    cols = [1..nsq]
    nums = [1..nsq]
    nvars = [1..nsq^3]

filterN x = filter ((== x) . thr3 . fst) vars

filterL l = filter ((== l) . fst3 . fst) vars

filterC c = filter ((== c) . snd3 . fst) vars

filterLN l x = filter (uncurry (&&) . split lineExpr numExpr) vars
  where
    lineExpr = (== l) . fst3 . fst
    numExpr = (== x) . thr3 . fst

filterCN c x = filter (uncurry (&&) . split colExpr numExpr) vars
  where
    colExpr = (== c) . snd3 . fst
    numExpr = (== x) . thr3 . fst

filterLCN tpl = filter ((== tpl) . fst) vars

notSameSq :: Int -> Int -> [String]
notSameSq a b = zipWith (curry ((++ " 0") . unwords . tplToList)) (neg a) (neg b)
  where
    neg = map (show . negate . snd) . filterN
    tplToList = conc . (singl >< singl)

oneNumPerSq = concatMap (uncurry notSameSq) comb
  where
    comb = nub $ [sortTpl (a,b) | a <- [1..nsq], b <- [1..nsq], a /= b]

allNumLine l = map (rest . filterLN l) [1..nsq]
  where
    rest = (++ " 0") . unwords . map (show . snd)

complAllLines = concatMap allNumLine [1..nsq]

allNumCol c = map (rest . filterCN c) [1..nsq]
  where
    rest = (++ " 0") . unwords . map (show . snd)

complAllCols = concatMap allNumCol [1..nsq]

submatrices = concatMap (chunksOf nsq . concat) . transpose . map (chunksOf n) $ matrix
  where
    matrix = chunksOf nsq $ [(x,y) | x <- [1..nsq], y <- [1..nsq]]

complAllSubM = map (rest . concatMap filterLCN) org
  where
    rest = (++ " 0") . unwords . map (show . snd)
    org = concatMap (chunksOf nsq . map (tpl3 . swap) . sort) comb
    comb = map csubm submatrices
    csubm subm = [(y,x) | x <- subm, y <- [1..nsq]]


cnfRest = oneNumPerSq ++ complAllLines ++ complAllCols ++ complAllSubM


printLines :: [String] -> IO()
printLines = mapM_ putStrLn


main = do
  rules <- readFile "rules"
  writeFile "generated.cnf" (unlines $ cnfRest ++ nr (tail . lines $ rules))
    where
    comb rules = map ((\[a,b,c] -> (a,b,c)) . map read . words) rules :: [(Int,Int,Int)]
    nr rules = map ((++ " 0") . show . snd) . concatMap filterLCN $ comb rules

