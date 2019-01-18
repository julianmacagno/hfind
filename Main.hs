module Main where
import System.Environment
import System.Exit
import System.Directory
import Control.Monad
--import Codec.Compression.GZip
import qualified Data.ByteString.Char8 as S
import qualified Data.ByteString.Lazy as L
import System.FilePath
import System.FilePath.Find
import System.FilePath.Glob
import System.FilePath.Manip
import qualified Data.List as DL
--import Text.Regex.Posix ((=~))

main :: IO ()
main = do
    args <- getArgs
    let fstParam = head args
    let sndParam = head (tail args)
    --find always (fileType ==? RegularFile &&? extension ==? ".hs") "myPath"
    files <- find always (fileType ==? RegularFile &&? extension ==? ".hs") fstParam
    print (filter (DL.isInfixOf sndParam) files)

browseDirectories :: String -> IO()
browseDirectories path = do 
    contents <- getDirectoryContents path
    print contents

-- printList :: [String] = String
-- printList (x:xs) = putStrLn x ++ printList xs
-- printList x = putStrLn x

doSomething :: String -> IO ()
doSomething "-h" = help >> exit
doSomething "-v" = version >> exit
doSomething "saludar" = putStrLn "Hola"
doSomething "putear" = putStrLn "Chupame el pito"


help :: IO ()
help = putStrLn "Usage: hfind [-arg] [file ..]"

version :: IO ()
version = putStrLn "hfind: v0.1"

exit :: IO a
exit = exitWith ExitSuccess