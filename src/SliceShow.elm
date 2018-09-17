module SliceShow exposing (Config, Message, Model, init, setSubscriptions, setUpdate, setView, show)

{-| This module helps you start your SliceShow application.


# Start your Application

@docs Config, init, show, setView, setUpdate, setSubscriptions, Model, Message

-}

import Browser exposing (UrlRequest(..))
import Browser.Dom exposing (getViewport)
import Browser.Events exposing (onKeyDown, onResize)
import Browser.Navigation exposing (Key)
import Html exposing (Html, text)
import Html.Events exposing (keyCode)
import Json.Decode as Decode
import SliceShow.Messages as Messages
import SliceShow.Model as Model
import SliceShow.Protected exposing (Protected(..))
import SliceShow.Slide exposing (Slide)
import SliceShow.Update as Update
import SliceShow.View as View
import Task
import Url


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
    { model : Key -> Model a b
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
        , view = \_ -> text ""
        , update = \_ a -> ( a, Cmd.none )
        , subscriptions = \_ -> Sub.none
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
show : Config a b -> Program () (Model a b) (Messages.Message b)
show (Protected { model, update, view, subscriptions }) =
    Browser.application
        { init =
            \_ { fragment } key ->
                ( Model.open fragment (model key)
                , Task.perform
                    (\{ viewport } ->
                        Messages.Resize
                            (round viewport.width)
                            (round viewport.height)
                    )
                    getViewport
                )
        , update = Update.update update
        , onUrlChange = .fragment >> Messages.Open
        , onUrlRequest =
            \request ->
                case request of
                    Internal url ->
                        Messages.NavigateToUrl (Url.toString url)

                    External url ->
                        Messages.NavigateToUrl url
        , view =
            \model_ ->
                { title =
                    case model_.currentSlide of
                        Just n ->
                            "Slide " ++ String.fromInt (n + 1)

                        Nothing ->
                            "Slides"
                , body = [ View.view view model_ ]
                }
        , subscriptions =
            \model_ ->
                Sub.batch
                    [ onKeyDown <|
                        Decode.map
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
                            keyCode
                    , onResize Messages.Resize
                    , Sub.map Messages.Custom (Model.subscriptions subscriptions model_)
                    ]
        }
