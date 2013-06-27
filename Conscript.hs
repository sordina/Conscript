import System.Environment
import System.Process
import System.Exit
import Control.Monad
import Control.Concurrent

main :: IO ()
main = getArgs >>= options

options :: [String] -> IO ()
options []           = help
options ("-h"    :_) = help
options ("--help":_) = help
options args         = run args

run :: [String] -> IO ()
run args = do
  c <- newChan
  startProcess args >>= writeChan c
  mapM_ (restart args c) . (filter (== '\n')) =<< getContents
  block

startProcess :: [String] -> IO ProcessHandle
startProcess (h:t) = (\(_,_,_,ph) -> ph) `fmap` createProcess (proc h t)
startProcess []    = help >> exitFailure

restart :: [String] -> (Chan ProcessHandle) -> Char -> IO ()
restart args pio _unused = do
  p <- readChan pio
  terminateProcess p
  void $ waitForProcess p
  void $ startProcess args >>= writeChan pio

help :: IO ()
help = putStrLn "Usage: conscript command [args*]"

block :: IO ()
block = void $ newEmptyMVar >>= readMVar
