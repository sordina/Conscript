module Conscript (main) where

import System.Environment
import System.IO
import System.Conscript

main :: IO ()
main = getArgs >>= options

options :: [String] -> IO ()
options []           = help
options ("-h"    :_) = help
options ("--help":_) = help
options args         = run args

run :: [String] -> IO ()
run args = do
  hSetBuffering stdin  LineBuffering
  hSetBuffering stdout LineBuffering
  prog <- conscript args
  getContents >>= prog . lines

help :: IO ()
help = putStrLn "Usage: conscript command [args*]"
