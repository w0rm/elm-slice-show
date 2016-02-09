module SliceShow.Update (update) where

import SliceShow.Model as Model exposing (Model)
import SliceShow.Actions exposing (Action(..))
import Effects exposing (Effects)
import History
import Task


update : Action -> Model -> (Model, Effects Action)
update action model =
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


withHashChange : Model -> (Model, Effects Action)
withHashChange model =
  ( model
  , History.setPath (Model.hash model)
      |> Task.map (always Noop)
      |> Effects.task
  )
