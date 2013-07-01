import System.Environment
import System.Process
import System.Exit
import System.IO
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
  hSetBuffering stdin NoBuffering
  blocker <- newEmptyMVar
  running <- newEmptyMVar
  void $ forkIO $ forever $ starter args blocker running
  mapM_ (killer blocker running) . (filter (== '\n')) =<< getContents

killer :: MVar () -> MVar ProcessHandle -> Char -> IO ()
killer blocker running _char = void $ takeMVar running >>= terminateProcess >> takeMVar blocker

starter :: [String] -> MVar () -> MVar ProcessHandle -> IO ()
starter args blocker running = do
  putMVar blocker ()
  p <- startProcess args
  putMVar running p
  code <- waitForProcess p
  case code of ExitFailure 15 -> return () -- Killed!
               ExitFailure i  -> putStrLn $ "Process [" ++ unwords args ++ "] failed with exit-status [" ++ show i ++ "]"
               ExitSuccess    -> return ()

startProcess :: [String] -> IO ProcessHandle
startProcess (h:t) = (\(_,_,_,ph) -> ph) `fmap` createProcess (proc h t)
startProcess []    = help >> exitFailure

help :: IO ()
help = putStrLn "Usage: conscript command [args*]"
