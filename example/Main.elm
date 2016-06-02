import Html exposing (Html)
import SliceShow exposing (..)
import Slides exposing (slides, update, view, subscriptions)


main : Program Never
main =
  {- Init the slides -}
  init slides
  {- Set inputs-update-view for the custom content -}
  |> setSubscriptions subscriptions
  |> setUpdate update
  |> setView view
  {- Show the slides -}
  |> show
