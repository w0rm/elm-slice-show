module SliceShow exposing (Config, init, show, setView, setUpdate, setSubscriptions, Model, Message)

{-| This module helps you start your SliceShow application.


# Start your Application

@docs Config, init, show, setView, setUpdate, setSubscriptions, Model, Message

-}

import SliceShow.Model as Model
import SliceShow.Update as Update
import SliceShow.View as View
import SliceShow.Slide exposing (Slide)
import SliceShow.Messages as Messages
import SliceShow.Protected exposing (Protected(Protected))
import Keyboard
import Window
import Html exposing (Html, text)
import Navigation
import Task


{-| Slideshow Config type
-}
type alias Config a b =
    Protected (PrivateConfig a b)


{-| Model type
-}
type alias Model a b =
    Model.Model a b


{-| Message type
-}
type alias Message b =
    Messages.Message b


type alias PrivateConfig a b =
    { model : Model a b
    , update : b -> a -> ( a, Cmd b )
    , view : a -> Html b
    , subscriptions : a -> Sub b
    }


{-| Init Model from the list of slides
-}
init : List (Slide a b) -> Config a b
init slides =
    Protected
        { model = Model.init (List.map (\(Protected data) -> data) slides)
        , view = (\_ -> text "")
        , update = (\_ a -> ( a, Cmd.none ))
        , subscriptions = (\_ -> Sub.none)
        }


{-| Set view for the custom content
-}
setView : (a -> Html.Html b) -> Config a b -> Config a b
setView view (Protected config) =
    Protected { config | view = view }


{-| Set update for the custom content
-}
setUpdate : (b -> a -> ( a, Cmd b )) -> Config a b -> Config a b
setUpdate update (Protected config) =
    Protected { config | update = update }


{-| Set inputs for the custom content
-}
setSubscriptions : (a -> Sub b) -> Config a b -> Config a b
setSubscriptions subscriptions (Protected config) =
    Protected { config | subscriptions = subscriptions }


{-| Start the SliceShow with your `slides`:
app = show (init slides)
main = app.html
port tasks : Signal (Task.Task Never ())
port tasks = app.tasks
-}
show : Config a b -> Program Never (Model a b) (Messages.Message b)
show (Protected { model, update, view, subscriptions }) =
    Navigation.program
        (.hash >> Messages.Open)
        { init = \{ hash } -> ( Model.open hash model, Task.perform Messages.Resize Window.size )
        , update = Update.update update
        , view = View.view view
        , subscriptions =
            \model ->
                Sub.batch
                    [ Keyboard.downs
                        (\code ->
                            case code of
                                37 ->
                                    Messages.Prev

                                39 ->
                                    Messages.Next

                                27 ->
                                    Messages.Index

                                _ ->
                                    Messages.Noop
                        )
                    , Window.resizes Messages.Resize
                    , Sub.map Messages.Custom (Model.subscriptions subscriptions model)
                    ]
        }
