module Main where
import System.Environment
import Data.Maybe
import Text.Parsec
import Ganymede.Parser
main :: IO ()
main = do
    args <- getArgs
    contents <- readFile $ fromMaybe "STDIN" (listToMaybe args)
    parseTest program contents