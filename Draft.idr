module Main

%default total

data Status : Type where
  Running : Status
  Done : Status

countToStatus : Nat -> Status
countToStatus Z = Done
countToStatus (S k) = Running

record State where
  constructor MkState
  status : Status
  count, ok, skipped, not_ok : Nat

InitialState : State
InitialState = MkState Running 0 0 0 0

parseNum : List Char -> Maybe Nat
parseNum [] = Nothing
parseNum cs = case and (map (Delay . isDigit) cs) of
                  True => Just (parseNum' cs)
                  False => Nothing
  where
    parseNum' : List Char -> Nat
    parseNum' [] = 0
    parseNum' s = let
        weights = (take (length s) (iterate (*10) 1))
        values = map fromChar (reverse s)
        pairs = zip values weights
        prods = map multiplyPair pairs
      in
        toNat (foldr (+) 0 prods)
      where
        fromChar : Char -> Integer
        fromChar c = ((toIntegerNat . toNat) c) - 48

        multiplyPair : (Integer, Integer) -> Integer
        multiplyPair (a, b) = a*b

parsePlan : List Char -> Maybe Nat
parsePlan ( from :: _ :: _ :: to ) = parseNum to
parsePlan _ = Nothing

run : List String -> State -> State
run ("ok" :: desc) state@(MkState Running (S n) _ _ _) =
  record { ok $= (+1), count = n, status = (countToStatus n) } state

run ("not" :: "ok" :: desc) state@(MkState Running (S n) _ _ _) =
  record { not_ok $= (+1), count = n, status = (countToStatus n) } state

run (x :: []) state = case parsePlan (unpack x) of
                           Just n => record { count = n } state
                           Nothing => state
run _ state = state

report : State -> IO ()
report (MkState _ count ok skipped not_ok) =
  do putStrLn ("# ok " ++ (show ok))
     putStrLn ("# not ok " ++ (show not_ok))

partial
loop : State -> IO ()
loop state@(MkState Done _ _ _ _) = report state
loop state = do line <- getLine
                loop (run (words line) state)

partial
main : IO ()
main = loop InitialState
