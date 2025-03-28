{-# LANGUAGE OverloadedStrings #-}

import Lib
import Graphics.UI.Gtk
import qualified SDL
import qualified SDL.Mixer as Mixer
import Control.Monad(void, when)
import Data.Text(Text, pack)
import System.FilePath(takeFileName)

import Data.IORef (newIORef, readIORef, writeIORef, modifyIORef, IORef)

-- директива qualified
-- Переменная вида foobar доступна под названием SDL.foobar 


data PlayerState = PlayerState
 { currentTrack :: Maybe Mixer.Music,
   isPlaying :: Bool
 }



initSDL :: IO()
initSDL = do
    SDL.initialize [SDL.InitAudio]
    
    Mixer.openAudio Mixer.defaultAudio 256
    return ()


loadTrack :: FilePath->IO(Maybe Mixer.Music)
loadTrack path = do
    music <- Mixer.load path
    return(Just music)


togglePlay :: PlayerState -> IO PlayerState
togglePlay state = case currentTrack state of
    Just music ->
        if isPlaying state
        then do
            Mixer.haltMusic
            return state {isPlaying = False}
        else do
            Mixer.playMusic Mixer.Forever music
            return state {isPlaying = True}
    Nothing -> return state







buildUI :: IO()
buildUI = do
    _ <- initGUI
    window <- windowNew
    set window [          windowTitle := ("audio player" :: String),            -- !
                 containerBorderWidth := 6,
                   windowDefaultWidth := 800,
                  windowDefaultHeight := 600            ]

    vbox <- vBoxNew False 10
    containerAdd window vbox


    trackLabel <- labelNew(Just ("Track: Not selected :(" :: String))           -- !
    boxPackStart vbox trackLabel PackNatural 5

    artistLabel <- labelNew(Just (("Artist: Unknown" :: String)))                 -- !
    boxPackStart vbox artistLabel PackNatural 5               



    progressBar <- progressBarNew
    boxPackStart vbox progressBar PackGrow 5

    --buttons
    playButton <- buttonNewWithLabel ("Play" :: String)                        -- !
    stopButton <- buttonNewWithLabel ("Stop" :: String)                         -- !
    hbox <- hBoxNew True 10
    boxPackStart hbox playButton PackGrow 5
    boxPackStart hbox stopButton PackGrow 5
    boxPackStart vbox hbox PackNatural 5

    stateRef <- newIORef(PlayerState Nothing False)             

    on playButton buttonActivated $ do
        state <- readIORef stateRef                             
        newState <- togglePlay state
        writeIORef stateRef newState                            
    
    on stopButton buttonActivated $ do
        Mixer.haltMusic
        modifyIORef stateRef(\s -> s{ isPlaying = False })      

    on window objectDestroy mainQuit

    widgetShowAll window
    mainGUI


-- ### 4. Улучшения
-- - Добавить выбор файла через fileChooserDialogNew
-- - Добавить ползунок прогресса с таймером обновления
-- - Добавить изображение (1.gif) через imageNewFromFile





main :: IO()
main = do
    initSDL
    buildUI 
    Mixer.quit                             
    SDL.quit
        
