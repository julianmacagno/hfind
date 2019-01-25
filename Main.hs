{-# LANGUAGE CPP #-}
module Main where

import Options.Applicative
import Data.Semigroup ((<>))
import System.FilePath.Find
import System.Process
import Data.List (isInfixOf)
import Data.Strings (strReplace)

data Search = FileName { fname :: String, path :: String, exec :: String } 
            | FileType { ftype :: String, path :: String, exec :: String }

searchByFilename :: Parser Search
searchByFilename = FileName
      <$> strOption
        ( long "fname"
       <> short 'n'
       <> metavar "filename"
       <> help "filename to search for" )
      <*> strOption
        ( long "path"
       <> short 'p'
       <> metavar "path"
       <> help "path where to search for" )
      <*> option str
        ( long "exec"
       <> value ""
       <> metavar "exec"
       <> help "command to be excecuted at search result")

searchByFiletype :: Parser Search
searchByFiletype = FileType
       <$> strOption
         ( long "ftype"
        <> short 't'
        <> metavar "filetype"
        <> help "filetype to search for" )
       <*> strOption
         ( long "path"
        <> short 'p'
        <> metavar "path"
        <> help "path where to search for" )
       <*> option str
         ( long "exec"
        <> value ""
        <> metavar "exec"
        <> help "command to be excecuted at search result")

searcher :: Parser Search
searcher = searchByFiletype <|> searchByFilename

main :: IO ()
main = search =<< execParser opts

opts :: ParserInfo Search
opts = info (searcher <**> helper)
  ( fullDesc
  <> progDesc "Search files on the given path and filter them by filename or filetype"
  <> header "fname - a test for optparse-applicative" )

search :: Search -> IO ()
search (FileName filename path command) = do 
    files <- find always (fileType ==? RegularFile) path
    let filteredFiles = filter (isInfixOf filename) files
    if filteredFiles /= []
    then 
        if command == ""
        then do 
            putStrLn ("Search by filename " ++ filename ++ " in " ++ path)
            mapM_ print filteredFiles
        else mapM_ ((callCommand . (command ++)) . strReplace " " "\\ ") filteredFiles
    else putStrLn $ "Not files found with filename " ++ filename ++ " in " ++ path
search (FileType filetype path command) = do
    files <- find always (fileType ==? RegularFile &&? extension ==? filetype) path
    if files /= []
        then
        if command == ""
        then do
            putStrLn ("Search by filetype " ++ filetype ++ " in " ++ path)
            mapM_ print files
            else mapM_ ((callCommand . (command ++)) . strReplace " " "\\ ") files
        
    else putStrLn $ "Not files found with filetype " ++ filetype ++ " in " ++ path