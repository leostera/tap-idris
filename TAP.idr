module TAP

import Data.Vect

%access private

printResult : String -> Bool -> IO ()
printResult n True = putStrLn ("ok " ++ n)
printResult n False = putStrLn ("not ok " ++ n)

runTests : Nat -> Vect n (IO Bool) -> IO ()
runTests k [] = putStrLn ""
runTests k (x :: xs) = x >>= printResult (show k) >>= \_ => runTests (S k) xs

export
plan : (suite : String) -> Vect n (IO Bool) -> IO ()
plan suite tests {n} = do putStrLn "TAP version 13"
                          putStrLn ("1.." ++ show n)
                          runTests 1 tests
