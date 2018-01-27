wip

What this looks like so far:

```hs
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
```

![](https://i.imgur.com/mFBejTd.png)

## TODO

* maybe better modeling on what fields are required?

## Notes

* each dataset entry seems to be able to set its own type
* if you don't set the main "type" using Chart, you get "cannot concat .sdf.skdfjaldkfjsadf", so best to only allow Chart.Bar, etc. explicitly, then the rest can be done however
* don't even really want to try to handle multiple charts yet

* options should be be paired with the chart type

* dataset builders should come with the type applied already, then should use whatever else
