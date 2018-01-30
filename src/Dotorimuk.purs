module Dotorimuk where

import Prelude

import Control.Monad.Eff (Eff)
import Data.Record.Builder (Builder)
import Data.Record.Builder as Builder
import Dotorimuk.RowListIntersection (class RowListIntersection)
import Graphics.Canvas (Context2D)
import Type.Prelude (class ListToRow, class RowLacks, class RowToList, SProxy(SProxy))
import Type.Row (Nil)

foreign import data ChartInstance :: Type

-- | Newtype used for building chart data configurations.
-- | appliesTo is a row type for fields of a chart type label and Unit, and is used to ensure that the composed builders contain the label for the given chart type.
newtype ChartBuilder
  (appliesTo :: # Type)
  (input :: # Type)
  (output :: # Type)
  = ChartBuilder (Builder (Record input) (Record output))

foreign import makeBarChart_ :: forall barChartSpec e
   . Context2D -> barChartSpec -> Eff e ChartInstance

makeBarChart :: forall appliesTo output e
   . Context2D
  -> { labels :: Array String
     , datasetBuilder ::
         ChartBuilder
          (barDataDataset :: Unit | appliesTo)
          ("type" :: String)
          output
     }
  -> Eff e ChartInstance
makeBarChart ctx {labels, datasetBuilder: ChartBuilder builder} =
  makeBarChart_ ctx
    { "data": {
        labels,
        datasets:
          [ Builder.build builder {"type": "bar"}
          ]
      }
    }

composeChartBuilder
  :: forall
       app1 app1L
       app2 app2L
       app3 app3L
       a b c
   . RowToList app1 app1L
  => RowToList app2 app2L
  => RowListIntersection Nil app1L app2L app3L
  => ListToRow app3L app3
  => ChartBuilder app1 a b
  -> ChartBuilder app2 b c
  -> ChartBuilder app3 a c
composeChartBuilder (ChartBuilder builder1) (ChartBuilder builder2) =
  ChartBuilder $ builder2 <<< builder1

infixr 9 composeChartBuilder as <<<<

label :: forall input
   . RowLacks "label" input
  => String
  -> ChartBuilder
       ( lineDataDataset :: Unit
       , barDataDataset :: Unit
       )
       input
       (label :: String | input)
label x = ChartBuilder (Builder.insert (SProxy :: SProxy "label") x)

data_ :: forall input
   . RowLacks "data" input
  => Array Number
  -> ChartBuilder
       ( lineDataDataset :: Unit
       , barDataDataset :: Unit
       )
       input
       ("data" :: Array Number | input)
data_ x = ChartBuilder (Builder.insert (SProxy :: SProxy "data") x)

backgroundColor :: forall input
   . RowLacks "backgroundColor" input
  => Array String
  -> ChartBuilder
       ( barDataDataset :: Unit
       , pieChartDataset :: Unit
       )
       input
       ("backgroundColor" :: Array String | input)
backgroundColor xs = ChartBuilder
  (Builder.insert (SProxy :: SProxy "backgroundColor") xs)

borderColor :: forall input
   . RowLacks "borderColor" input
  => Array String
  -> ChartBuilder
       (barDataDataset :: Unit)
       input
       ("borderColor" :: Array String | input)
borderColor xs = ChartBuilder
  (Builder.insert (SProxy :: SProxy "borderColor") xs)

borderWidth :: forall input
   . RowLacks "borderWidth" input
  => Int
  -> ChartBuilder
       (barDataDataset :: Unit)
       input
       ("borderWidth" :: Int | input)
borderWidth xs = ChartBuilder
  (Builder.insert (SProxy :: SProxy "borderWidth") xs)
