-- The Hoover dam is a famous, very big dam in the U.S. that regulates
-- the water flow of the Colorado river in the Black Canyon. Until a
-- few decades ago, in order to get from Las Vegas to Arizona by car
-- we would need to cross the Hoover dam. However, the dam is old and
-- the engineer responsible for it told us that only three cars can be
-- on top of it at the same time.

type NCars = Int

-- the dam opens.
damOpens :: Maybe NCars
damOpens = Just 0

-- A car reaches the top of the dam
carEnters :: NCars -> Maybe NCars
carEnters n = if (n < 3) then Just (n + 1) else Nothing
-- Increment the counter

-- A car leaves the top of the dam
carLeaves :: NCars -> Maybe NCars
carLeaves n = if (n >= 1) then Just (n - 1) else Just n
-- Decrement the counter

-- A propagação de erros é tratada pelo monad, portanto o Nothing propaga-se.
run = do x1 <- damOpens
         x2 <- carEnters x1
         x3 <- carEnters x2
         x4 <- carEnters x3
         x5 <- carEnters x4 -- Nothing
         x6 <- carLeaves x5
         x7 <- carLeaves x6
         return x7
-- The do syntax provides a simple shorthand for chains of monadic operations.
runv2 = damOpens >>= carEnters >>= return

-- A calculator that handles the problem of dividing by zero
myDiv :: Integral a => a -> a -> Maybe a
myDiv a b = if b /= 0 then return (div a b) else Nothing

mySum :: Integral a => a -> a -> Maybe a
mySum a b = return (a + b)

myMult :: Integral a => a -> a -> Maybe a
myMult a b = return (a * b)


-- (a / b) + (b / a)
calc (a,b) = do x <- myDiv a b
                y <- myDiv b a
                z <- mySum x y
                return z

