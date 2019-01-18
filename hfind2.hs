{-# LANGUAGE CPP #-}
module Main where
import Options.Applicative
import Data.Semigroup ((<>))

path :: Parser String
path = strOption ( long "path" <> short 'p' <> metavar "string" 
    <> help "filePath where to search for" )

filename :: Parser String
filename = strOption ( long "name" <> short 'n' <> metavar "string" 
        <> help "filename to search for" )

filetype :: Parser String
filetype = strOption ( long "type" <> short 't' <> metavar "string"
        <> help "filetype to search for" )

data ArgsWithFilename = ArgsWithFilename
    { pathFile1 :: String
    , name  :: String }
    deriving Show

data ArgsWithFiletype = ArgsWithFiletype
    { pathFile2 :: String
    , fileType :: String }
    deriving Show

argsWithFilename :: Parser ArgsWithFilename
argsWithFilename = ArgsWithFilename <$> pathFile1 <*> filename

argsWithFiletype :: Parser ArgsWithFiletype
argsWithFiletype = ArgsWithFiletype <$> pathFile2 <*> filetype

main :: IO ()
main = searchFiles =<< execParser opts

opts :: ParserInfo ArgsWithFilename
opts = info (ArgsWithFilename <**> helper)
  ( fullDesc
  <> progDesc "Print a greeting for TARGET"
  <> header "hello - a test for optparse-applicative" )

searchFiles :: ArgsWithFilename -> IO ()
searchFiles (ArgsWithFilename path filename) = putStrLn ("Path: " ++ path ++ " Filename: " ++ filename)
searchFiles _ = return ()