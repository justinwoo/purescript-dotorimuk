module Example where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Data.Maybe (Maybe(..))
import Data.Traversable (traverse)
import Dotorimuk (backgroundColor, borderWidth, data_, label, makeBarChart, (<<<<))
import Graphics.Canvas (CANVAS, getCanvasElementById, getContext2D)

main :: forall e. Eff ( canvas :: CANVAS , console :: CONSOLE | e ) Unit
main = do
  context <- traverse getContext2D =<< getCanvasElementById "myChart"
  case context of
    Nothing -> log "couldn't find chart context..."
    Just ctx ->  do
      chart <- makeBarChart ctx { labels, datasetBuilder }
      log "made bar chart"
  where
    labels =
      [ "Red"
      , "Blue"
      , "Yellow"
      , "Green"
      , "Purple"
      , "Orange"
      ]
    datasetBuilder
         = label "# of Votes"
      <<<< data_ [12.0, 19.0, 3.0, 5.0, 2.0, 3.0]
      <<<< backgroundColor ["rgba(255, 99, 132, 0.2)", "rgba(54, 162, 235, 0.2)", "rgba(255, 206, 86, 0.2)", "rgba(75, 192, 192, 0.2)", "rgba(153, 102, 255, 0.2)", "rgba(255, 159, 64, 0.2)"]
      <<<< borderWidth 1
