{-# LANGUAGE CPP #-}
module Main where

import Options.Applicative
import Data.Semigroup ((<>))

data Sample = Sample
  { hello  :: String
  , quiet  :: Bool }
  deriving Show

sample :: Parser Sample
sample = Sample
      <$> strOption
          ( long "hello"
         <> metavar "TARGET"
         <> help "Target for the greeting" )
      <*> switch
          ( long "quiet"
         <> short 'q'
         <> help "Whether to be quiet" )

main :: IO () 
main = greet =<< execParser opts

opts :: ParserInfo Sample
opts = info (sample <**> helper)
  ( fullDesc
  <> progDesc "Print a greeting for TARGET"
  <> header "hello - a test for optparse-applicative" )

greet :: Sample -> IO ()
greet (Sample h False) = putStrLn $ "Hello, " ++ h
greet _ = return ()