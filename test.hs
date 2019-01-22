import System.Process

funcion :: String -> [String] -> IO ()
funcion command files = do
    if   command == ""
    then callCommand "ls -al"
    else do 
            mapM_ callCommand (map (command++) files)
            callCommand "ls -al"
            