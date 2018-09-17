module SliceShow.Update exposing (update)

import Browser.Navigation as Navigation
import SliceShow.Messages exposing (Message(..))
import SliceShow.Model as Model exposing (Model)


update : (b -> a -> ( a, Cmd b )) -> Message b -> Model a b -> ( Model a b, Cmd (Message b) )
update updateCustom message model =
    case message of
        Next ->
            withHashChange (Model.next model)

        Prev ->
            withHashChange (Model.prev model)

        Index ->
            withHashChange { model | currentSlide = Nothing }

        Goto index ->
            withHashChange { model | currentSlide = Just index }

        Open locationHash ->
            ( Model.open locationHash model, Cmd.none )

        Resize width height ->
            ( { model | width = width, height = height }, Cmd.none )

        NavigateToUrl url ->
            ( model, Navigation.load url )

        Noop ->
            ( model, Cmd.none )

        Custom msg ->
            let
                ( newModel, effects ) =
                    Model.update updateCustom msg model
            in
            ( newModel, Cmd.map Custom effects )


withHashChange : Model a b -> ( Model a b, Cmd (Message b) )
withHashChange model =
    ( model
    , Navigation.pushUrl model.key (Model.hash model)
    )
