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
     let [status, id] = split (== ' ') line
     case status of
          "ok" => run (record { ok $= (+1), count = n } state)
          "not ok" => run (record { not_ok $= (+1), count = n } state)

main : IO ()
main = do version <- getLine
          description <- getLine
          plan <- getLine
          let count = (parseNum . pack . (drop 3) . unpack) plan
          case count of
               Nothing => pure ()
               Just c => case c > -1 of
                 False => pure ()
                 True => run (MkState (cast c) 0 0 0) >>= \x => pure ()
