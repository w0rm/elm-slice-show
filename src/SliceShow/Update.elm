module SliceShow.Update (update) where

import SliceShow.Model as Model exposing (Model)
import SliceShow.Actions exposing (Action(..))
import Effects exposing (Effects)
import History
import Task


update : (b -> a -> (a, Effects b)) -> Action b -> Model a -> (Model a, Effects (Action b))
update updateCustom action model =
  case action of

    Next ->
      withHashChange (Model.next model)

    Prev ->
      withHashChange (Model.prev model)

    Index ->
      withHashChange ({model | currentSlide = Nothing})

    Goto index ->
      withHashChange ({model | currentSlide = Just index})

    Open locationHash ->
      (Model.open locationHash model, Effects.none)

    Resize dimensions ->
      ({model | dimensions = dimensions}, Effects.none)

    Noop ->
      (model, Effects.none)

    Custom action ->
      let
        (newModel, effects) = Model.update updateCustom action model
      in
        (newModel, Effects.map Custom effects)


withHashChange : Model a -> (Model a, Effects (Action b))
withHashChange model =
  ( model
  , History.setPath (Model.hash model)
      |> Task.map (always Noop)
      |> Effects.task
  )
