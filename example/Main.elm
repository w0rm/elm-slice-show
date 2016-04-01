import Html exposing (Html)
import Task exposing (Task)
import Effects exposing (Never)
import SliceShow exposing (..)
import Slides exposing (slides, update, view, inputs)


sliceShow : SliceShow
sliceShow =
  {- Init the slides -}
  init slides
  {- Set initial dimensions and locationHash from the corresponding ports -}
  |> setDimensions windowDimensions
  |> setHash locationHash
  {- Set inputs-update-view for the custom content -}
  |> setInputs inputs
  |> setUpdate update
  |> setView view
  {- Show the slides -}
  |> show


main : Signal Html
main = sliceShow.html


port tasks : Signal (Task Never ())
port tasks = sliceShow.tasks


port windowDimensions : (Int, Int)


port locationHash : String
