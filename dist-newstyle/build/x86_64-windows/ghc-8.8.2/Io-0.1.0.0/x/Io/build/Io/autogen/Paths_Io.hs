{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_Io (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\rotfl\\AppData\\Roaming\\cabal\\bin"
libdir     = "C:\\Users\\rotfl\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-8.8.2\\Io-0.1.0.0-inplace-Io"
dynlibdir  = "C:\\Users\\rotfl\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-8.8.2"
datadir    = "C:\\Users\\rotfl\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-8.8.2\\Io-0.1.0.0"
libexecdir = "C:\\Users\\rotfl\\AppData\\Roaming\\cabal\\Io-0.1.0.0-inplace-Io\\x86_64-windows-ghc-8.8.2\\Io-0.1.0.0"
sysconfdir = "C:\\Users\\rotfl\\AppData\\Roaming\\cabal\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "Io_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "Io_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "Io_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "Io_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "Io_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "Io_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
