module SliceShow.Update (update) where

import SliceShow.Model as Model exposing (Model)
import SliceShow.Actions exposing (Action(..))
import History
import Task


update : (b -> a -> (a, Cmd b)) -> Action b -> Model a -> (Model a, Cmd (Action b))
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
      (Model.open locationHash model, Cmd.none)

    Resize dimensions ->
      ({model | dimensions = dimensions}, Cmd.none)

    Noop ->
      (model, Cmd.none)

    Custom action ->
      let
        (newModel, effects) = Model.update updateCustom action model
      in
        (newModel, Cmd.map Custom effects)


withHashChange : Model a -> (Model a, Cmd (Action b))
withHashChange model =
  ( model, Cmd.none )
