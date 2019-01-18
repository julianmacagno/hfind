{-# LANGUAGE CPP #-}
module Main where

import Options.Applicative
import Data.Semigroup ((<>))

data Hablar = Saludo { hello :: String, quiet :: Bool } | Insulto { fuck :: String }

saludar :: Parser Hablar
saludar = Saludo
      <$> strOption
          ( long "hello"
         <> metavar "TARGET"
         <> help "Target for the greeting" )
      <*> switch
          ( long "quiet"
         <> short 'q'
         <> help "Whether to be quiet" )

insultar :: Parser Hablar
insultar = Insulto
      <$> strOption
          ( long "fuck"
         <> metavar "TARGET"
         <> help "Targer for the insult" )

hablar :: Parser Hablar
hablar = insultar <|> saludar

main :: IO ()
main = greet =<< execParser opts

opts :: ParserInfo Hablar
opts = info (hablar <**> helper)
  ( fullDesc
  <> progDesc "Print a greeting for TARGET"
  <> header "hello - a test for optparse-applicative" )

greet :: Hablar -> IO ()
greet (Saludo h False) = putStrLn $ "Hello, " ++ h
greet (Insulto h) = putStrLn $ "Chupame el pito, " ++ h
greet _ = return ()