module Main

%default total

data Status : Type where
  Running : Status
  Done : Status

expectedToStatus : Nat -> Status
expectedToStatus Z = Done
expectedToStatus (S k) = Running

record State where
  constructor MkState
  status : Status
  count, expected, ok, skipped, not_ok : Nat

InitialState : State
InitialState = MkState Running 0 0 0 0 0

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
run ("ok" :: desc) state@(MkState Running _ (S n) _ _ _) =
  record { ok $= (+1), expected = n, status = (expectedToStatus n) } state

run ("not" :: "ok" :: desc) state@(MkState Running _ (S n) _ _ _) =
  record { not_ok $= (+1), expected = n, status = (expectedToStatus n) } state

run (x :: []) state = case parsePlan (unpack x) of
                           Just n => record { count = n, expected = n } state
                           Nothing => state
run _ state = state

summary : (state : State) -> String
summary (MkState status count expected ok skipped not_ok) =
  let
    perc_ok = show (ceiling ( (cast ok)*100.0 / (cast count) ))
    fraction = (show ok) ++ "/" ++ (show count)
  in
    "# summary " ++ fraction ++ " tests, " ++ perc_ok ++ "% okay"

report : State -> IO ()
report state@(MkState _ count expected ok skipped not_ok) =
  do putStrLn ("# ok " ++ (show ok))
     putStrLn ("# not ok " ++ (show not_ok))
     putStrLn ("# skipped " ++ (show skipped))
     putStrLn (summary state)

partial
loop : State -> IO ()
loop state@(MkState Done _ _ _ _ _) = report state
loop state = do line <- getLine
                loop (run (words line) state)

partial
main : IO ()
main = loop InitialState
