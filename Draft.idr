module Main

record State where
  constructor MkState
  count, ok, skipped, not_ok : Nat

parseNum : String -> Maybe Integer
parseNum "" = Nothing
parseNum s = let
    weights = (take (length s) (iterate (*10) 1))
    values = map fromChar (reverse (unpack s))
    pairs = zip values weights
    prods = map multiplyPair pairs
  in
    Just (foldr (+) 0 prods)
  where
    fromChar : Char -> Integer
    fromChar c = ((toIntegerNat . toNat) c) - 48

    multiplyPair : (Integer, Integer) -> Integer
    multiplyPair (a, b) = a*b

run : State -> IO (State)
run state@(MkState Z ok skipped failed) = pure state
run state@(MkState (S n) _ _ _)  =
  do line <- getLine
     let parts = split (== ' ') line
     putStr "."
     case parts of
          ["ok", _] => run (record { ok $= (+1), count = n } state)
          ["not", "ok", _] => run (record { not_ok $= (+1), count = n } state)
          _ => pure state

report : State -> IO ()
report (MkState count ok skipped not_ok) =
  do putStrLn ("# ok " ++ (show ok))
     putStrLn ("# not ok " ++ (show not_ok))

main : IO ()
main = do version <- getLine
          description <- getLine
          plan <- getLine
          let count = (parseNum . pack . (drop 3) . unpack) plan
          case count of
               Nothing => pure ()
               Just c => case c > -1 of
                 False => pure ()
                 True => do results <- run (MkState (cast c) 0 0 0)
                            putStrLn ""
                            report results
