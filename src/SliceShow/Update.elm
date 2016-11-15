module SliceShow.Update exposing (update)

import SliceShow.Model as Model exposing (Model)
import SliceShow.Messages exposing (Message(..))
import Navigation


update : (b -> a -> ( a, Cmd b )) -> Message b -> Model a b -> ( Model a b, Cmd (Message b) )
update updateCustom message model =
    case message of
        Next ->
            withHashChange (Model.next model)

        Prev ->
            withHashChange (Model.prev model)

        Index ->
            withHashChange ({ model | currentSlide = Nothing })

        Goto index ->
            withHashChange ({ model | currentSlide = Just index })

        Open locationHash ->
            ( Model.open locationHash model, Cmd.none )

        Resize dimensions ->
            ( { model | dimensions = dimensions }, Cmd.none )

        Noop ->
            ( model, Cmd.none )

        Custom message ->
            let
                ( newModel, effects ) =
                    Model.update updateCustom message model
            in
                ( newModel, Cmd.map Custom effects )


withHashChange : Model a b -> ( Model a b, Cmd (Message b) )
withHashChange model =
    ( model
    , Navigation.newUrl (Model.hash model)
    )
