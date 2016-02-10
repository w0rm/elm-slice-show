import Html exposing (Html)
import Task exposing (Task)
import Effects exposing (Never)
import SliceShow exposing (SliceShow)
import Slides exposing (slides)


sliceShow : SliceShow
sliceShow =
  SliceShow.init slides
  |> SliceShow.setDimensions windowDimensions
  |> SliceShow.setHash locationHash
  |> SliceShow.show


main : Signal Html
main = sliceShow.html


port tasks : Signal (Task Never ())
port tasks = sliceShow.tasks


port windowDimensions : (Int, Int)


port locationHash : String
