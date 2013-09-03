module System.Conscript (conscript) where

import System.Process
import System.Exit
import Control.Monad
import Control.Concurrent

conscript :: [String] -> IO ([String] -> IO ())
conscript args = do
  blocker <- newEmptyMVar
  running <- newEmptyMVar
  void   $ forkIO $ forever $ starter args blocker running
  return $ mapM_  $ killer blocker running

killer :: MVar () -> MVar ProcessHandle -> String -> IO ()
killer blocker running _input = void $ takeMVar running >>= terminateProcess >> takeMVar blocker

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
startProcess []    = error "startProcess must accept at least one argument"
