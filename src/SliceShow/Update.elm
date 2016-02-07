module SliceShow.Update (update) where

import SliceShow.Model exposing (Model)
import SliceShow.Actions exposing (Action(..))
import Effects exposing (Effects)


update : Action a -> Model -> (Model, Effects (Action a))
update action model =
  case action of

    GoTo locationHash ->
      (model, Effects.none)

    Slide int slideAction ->
      (model, Effects.none)

    _ ->
      (model, Effects.none)
