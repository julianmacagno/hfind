{-# LANGUAGE CPP #-}
module Main where

import Options.Applicative
import Data.Semigroup ((<>))
import System.FilePath.Find
--import System.FilePath.Glob
--import System.FilePath.Manip
import qualified Data.List as DL


data Search = FileName { fname :: String, path :: String } 
            | FileType { ftype :: String, path :: String }

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

hablar :: Parser Search
hablar = searchByFiletype <|> searchByFilename

main :: IO ()
main = search =<< execParser opts

opts :: ParserInfo Search
opts = info (hablar <**> helper)
  ( fullDesc
  <> progDesc "Search files on the given path and filter them by filename or filetype"
  <> header "fname - a test for optparse-applicative" )

search :: Search -> IO ()
search (FileName filename path) = do 
    putStrLn $ "Buscar por nombre de archivo" ++ filename ++ " en " ++ path
    files <- find always (fileType ==? RegularFile) path
    mapM_ print (filter (DL.isInfixOf filename) files)
search (FileType filetype path) = do
    putStrLn $ "Buscar por tipo de archivo " ++ filetype ++ " en " ++ path
    files <- find always (fileType ==? RegularFile &&? extension ==? filetype) path
    mapM_ print files
--search _ = return ()

-- files <- find always (fileType ==? RegularFile &&? extension ==? ".hs") fstParam
-- print (filter (DL.isInfixOf sndParam) files)