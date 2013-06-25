import System.Environment
import System.Process
import System.Exit
import Data.IORef

main :: IO ()
main = getArgs >>= options

options :: [String] -> IO ()
options []           = help
options ("-h"    :_) = help
options ("--help":_) = help
options args         = run args

run :: [String] -> IO ()
run args = do
  i <- newIORef =<< startProcess args
  mapM_ (restart args i) . lines =<< getContents

startProcess :: [String] -> IO ProcessHandle
startProcess (h:t) = (\(_,_,_,ph) -> ph) `fmap` createProcess (proc h t)
startProcess []    = help >> exitFailure

restart :: [String] -> (IORef ProcessHandle) -> String -> IO ()
restart args pio _unused = do
  p <- readIORef pio
  terminateProcess p
  startProcess args >>= writeIORef pio

help :: IO ()
help = putStrLn "Usage: conscript command [args*]"
