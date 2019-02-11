module Main where

import Options.Applicative
import Data.Semigroup ((<>))
import System.FilePath.Find
import System.Process
import Data.List (isInfixOf)
import Data.Strings (strReplace)
import Control.Monad (liftM)

data Search = FileName { fname :: String, path :: String, exec :: String } 
            | FileType { ftype :: String, path :: String, exec :: String }

searchByFilename :: Parser Search
searchByFilename = FileName
      <$> strOption
        ( long "fname"
       <> short 'n'
       <> metavar "filename"
       <> help "filename to search for" )
      <*> option str
        ( long "path"
       <> short 'p'
       <> value "."
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
       <*> option str
         ( long "path"
        <> short 'p'
        <> value "."
        <> metavar "path"
        <> help "path where to search for" )
       <*> option str
         ( long "exec"
        <> value ""
        <> metavar "exec"
        <> help "command to be excecuted at search result")

main :: IO ()
main = search =<< execParser opts

searcher :: Parser Search
searcher = searchByFiletype <|> searchByFilename

opts :: ParserInfo Search
opts = info (searcher <**> helper)
  ( fullDesc
  <> progDesc "Search files on the given path and filter them by filename or filetype"
  <> header "hfind - a GNU-find based utility" )

search :: Search -> IO ()
search (FileName filename path command) = do 
    -- files <- find always (fileType ==? RegularFile) path
    -- let filteredFiles = filter (isInfixOf filename) files
    filteredFiles <- find always (fileType ==? RegularFile &&? isInfixOf filename `liftM` fileName) path
    if filteredFiles /= []
    then 
        if command == ""
        then do 
            putStrLn ("Search by filename " ++ filename ++ " in " ++ path)
            mapM_ print filteredFiles
        else do
            let checkedCommand = checkCommand command
            mapM_ ((callCommand . (checkedCommand ++)) . strReplace " " "\\ ") filteredFiles
    else putStrLn $ "Not files found with filename " ++ filename ++ " in " ++ path
search (FileType filetype path command) = do
    let checkedExtension = checkExtension filetype
    files <- find always (fileType ==? RegularFile &&? extension ==? checkedExtension) path
    if files /= []
    then
        if command == ""
        then do
            putStrLn ("Search by filetype " ++ filetype ++ " in " ++ path)
            mapM_ print files
        else do
            let checkedCommand = checkCommand command
            mapM_ ((callCommand . (checkedCommand ++)) . strReplace " " "\\ ") files
    else putStrLn $ "Not files found with filetype " ++ filetype ++ " in " ++ path

checkExtension :: String -> String
checkExtension filetype
    | head filetype /= '.' = "." ++ filetype
    | otherwise = filetype

checkCommand :: String -> String
checkCommand command 
    | last command /= ' ' = command ++ " "
    | otherwise = command