{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_audio (
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

bindir     = "/home/gigapups/.cabal/bin"
libdir     = "/home/gigapups/.cabal/lib/x86_64-linux-ghc-8.8.4/audio-0.1.0.0-inplace"
dynlibdir  = "/home/gigapups/.cabal/lib/x86_64-linux-ghc-8.8.4"
datadir    = "/home/gigapups/.cabal/share/x86_64-linux-ghc-8.8.4/audio-0.1.0.0"
libexecdir = "/home/gigapups/.cabal/libexec/x86_64-linux-ghc-8.8.4/audio-0.1.0.0"
sysconfdir = "/home/gigapups/.cabal/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "audio_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "audio_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "audio_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "audio_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "audio_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "audio_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
