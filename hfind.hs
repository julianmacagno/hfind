{-# LANGUAGE CPP #-}
module Main where

import Options.Applicative
import Data.Semigroup ((<>))
import System.FilePath.Find
import System.Process
--import System.FilePath.Glob
--import System.FilePath.Manip
import qualified Data.List as DL

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
       <> short 'e'
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
        <> short 'e'
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
    putStrLn $ "Buscar por nombre de archivo " ++ filename ++ " en " ++ path
    files <- find always (fileType ==? RegularFile) path
    let filteredFiles = filter (DL.isInfixOf filename) files
    if command == ""
    then mapM_ print filteredFiles
    else mapM_ callCommand (map (command++) filteredFiles)
search (FileType filetype path command) = do
    putStrLn $ "Buscar por tipo de archivo " ++ filetype ++ " en " ++ path
    files <- find always (fileType ==? RegularFile &&? extension ==? filetype) path
    if command == ""
    then mapM_ print files
    else mapM_ callCommand (map (command++) files)
--search _ = return ()