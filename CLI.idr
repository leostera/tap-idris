module CLI

%default total

interface Parseable a where
  parse : String -> a

data Argument : Type where
  MkArg : Parseable argType =>
          (shortName: Char) ->
          (longName : String) ->
          (desc : String) ->
          Argument

data Result : Type where
  MkResult : a -> Result

record Config where
  constructor MkConfig
  arguments : List Argument
  version : String
  name : String
  description : String

helpArgs : List Argument -> IO ()
helpArgs [] = pure ()
helpArgs ((MkArg shortName longName description) :: xs) =
  do putStrLn ("  " ++ "--" ++ longName ++ ", -" ++ (singleton shortName) ++ "\t\t" ++ description)
     helpArgs xs

help : Config -> IO ()
help (MkConfig arguments version name description) =
  do putStrLn (name ++ " v" ++ version ++ " - " ++ description)
     putStrLn ""
     putStrLn "Options: "
     helpArgs arguments

typeOut : Argument -> Type
typeOut (MkArg _ _ _ { argType }) = argType

partial
parseArgs : String -> List Argument -> List Result
parseArgs s xs = map (parseArg s) xs where
  parseArg : String -> Argument -> Result
  parseArg s (MkArg sn ln d { argType }) = MkResult (the argType (parse s))


-- sample

data PkgName : Type where
  MkPkgName : String -> PkgName

data PkgAuthor : Type where
  MkPkgAuthor : String -> PkgAuthor

data PkgVersion : Type where
  MkPkgVersion : String -> PkgVersion

Parseable PkgName where
  parse = MkPkgName

Parseable PkgAuthor where
  parse = MkPkgAuthor

args : List Argument
args = [
  MkArg 'n' "name" "Package Name" { argType = PkgName },
  MkArg 'a' "author" "Package Author" { argType = PkgAuthor }
]

version : String
version = "0.0.1"

config : Config
config = MkConfig args version "draft" "A TAP Harness for Idris"
