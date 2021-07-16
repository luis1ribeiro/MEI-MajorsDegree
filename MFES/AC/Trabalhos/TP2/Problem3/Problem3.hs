module Problem3 where

import Control.Monad
import Control.Arrow
import Data.List.Split
import Data.Char
import Control.Monad.Trans.State.Lazy
import Control.Monad.IO.Class
import Data.Maybe
import List.Transformer hiding (foldM)
import Data.Bool
import Control.Monad.Trans.Except
import System.Random hiding (next)
import Data.List
import Control.Monad.Trans.Writer.Lazy

type Node = Char
type Path = [Node]
type Edge = (Node,Node)
type Battery = Int

type Recharges = [(Node, Int)]
type Adjacencies = [(Edge, Int)]
type TrafficInfo = [CustomError]

data Info = Info {
    battery :: Int,
    adjs :: Adjacencies,
    recharges :: Recharges,
    traffic :: TrafficInfo
} deriving Show

type App a = ExceptT CustomError (StateT Info (WriterT Path (ListT IO))) a

data CustomError = Hole Edge | RoadBlock Edge | TrafficKilledBattery Node deriving (Show, Eq)

{-
    Helper functions that allow us to easily obtain or manipulate certain values.
-}

(.:) :: (c -> d) -> (a -> b -> c) -> a -> b -> d
(.:) = (.) . (.)

adj :: Adjacencies -> Edge -> Bool
adj as = flip elem (map fst as)

getLoss :: Adjacencies -> Edge -> Int
getLoss = fromJust .: flip lookup

getError :: TrafficInfo -> Edge -> Maybe CustomError
getError ti e = find (\x -> x == Hole e || x == RoadBlock e) ti

getGain :: Recharges -> Node -> Int
getGain = curry $ fromJust . uncurry (flip lookup)
--getGain r = fromJust . flip lookup r -- also would work, fun

changeBattery :: (Int -> Int) -> Info -> Info
changeBattery k (Info bat as rs ti) = Info (k bat) as rs ti

-- Turns a ListT into a regular list in the same context
toList :: Monad m => ListT m a -> m [a]
toList = next >=> uncurry (bool cons (return . const [])) . (isNil &&& id) where
    isNil Nil = True
    isNil _ = False
    cons (Cons a l') = (a:) <$> toList l'

{-
    Lifting functions. They help with making the code more readable and also easier to change when change is needed.
-}

liftList :: ListT IO a -> App a
liftList = lift . lift . lift

liftState :: StateT Info (WriterT Path (ListT IO)) a -> App a
liftState = lift

liftWriter :: WriterT Path (ListT IO) a -> App a
liftWriter = lift . lift

{-
    Parsing functions.
-}

-- Cleans blank space
readLines = return . map (filter (not . isSpace)) . lines <=< readFile

{-
    Actual problem resolution.
-}

addtoEnd :: Adjacencies -> Path -> [Node] -> [Path]
addtoEnd as p ns = ns >>= (\n -> if adj as (last p, n) && not (elem n p) then return $ p ++ [n] else [])

-- Uses the previous addToEnd for the same end as before but also deals with the battery spending.
addToEndState :: Path -> App Path
addToEndState p = do
    (Info b as rs _) <- liftState $ get
    operationWrapper $ addtoEnd as p (map fst rs)

-- Closes the hamiltonian paths by going back to the starting node
close :: Path -> App Path
close p = do
    (Info b as rs _) <- liftState $ get
    operationWrapper $ if adj as (head p, last p) then return $ p ++ [head p] else []

-- Generic function that takes care of the repeated aspects of any interaction we need to do
operationWrapper :: [Path] -> App Path
operationWrapper ps = do
    (Info b as rs ti) <- liftState $ get
    new_ps <- liftList $ select ps
    let adj@(from, to) = (last $ init new_ps, last new_ps)
    midBat <- liftState $ adjustBattery adj
    liftWriter $ logPath from
    dealWithFailure (bool [] new_ps (midBat >0)) from $ getError ti adj

-- Adjust the battery level according to the edge we are traversing
adjustBattery :: Monad m => Edge -> StateT Info m Int
adjustBattery adj@(from,to) = do
    (Info b as rs ti) <- get
    modify (changeBattery (+ getLoss as adj))
    midBat <- battery <$> get
    modify (changeBattery (+ getGain rs to))
    return midBat

-- In case of failure throw an error, otherwise return the desired value
dealWithFailure :: MonadIO m => a -> Node -> Maybe CustomError -> ExceptT CustomError m a
dealWithFailure _ _ (Just error) = throwE error
dealWithFailure value from Nothing = do
    batteryFailed <- liftIO $ (> 99) <$> randomRIO (0::Int, 100::Int)
    if batteryFailed then throwE $ TrafficKilledBattery from else return value

logPath :: Monad m => Node -> WriterT Path m ()
logPath node = do
    tell [node]
    return ()

{-
    Final operations
-}

hCycles :: Node -> App Path
hCycles n = do
    (Info b as rs _) <- liftState $ get
    p <- foldr (=<<) (return [n]) $ replicate (length rs - 1) addToEndState
    if null p then return [] else close p

-- Converts an Int to an Error
edgeError :: Edge -> Int -> Maybe CustomError
edgeError e i | i > 99 = Just $ Hole e
              | i > 98 = Just $ RoadBlock e
              | otherwise = Nothing

prettyPrint :: ((Either CustomError Path, Int), Path) -> Either (CustomError,Path) (Path,Int)
prettyPrint ((Left e, _),y) = Left (e,y)
prettyPrint ((Right p, x),_) = Right (p,x)

main :: Battery -> IO [Either (CustomError,Path) (Path,Battery)]
main bat = do
    allNodes <- map (\x -> read x :: (Node,Int)) <$> readLines "nodes"
    adj <- map (\x -> read x :: ((Node, Node),Int)) <$> readLines "adjs"
    trafficInfo <- mapM (\(e,_) -> edgeError e <$> (randomRIO (0::Int,100::Int))) adj
    n <- liftIO $ putStr "Starting point: " >> getLine >>= return . toUpper . head
    -- Perform TSP from the starting node
    let r = runWriterT $ runStateT (runExceptT $ hCycles n) (Info bat adj allNodes (catMaybes trafficInfo))
    -- Filter the paths that didn't made it to the end, appearing with an empty sequence of nodes
    errorsAndPaths <- filter ((const True ||| not . null) . fst . fst) <$> toList r
    -- Adjust the output to look a little better
    return $ map (prettyPrint . ((id *** battery) *** id)) errorsAndPaths
