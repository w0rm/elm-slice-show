module SliceShow exposing
    ( Content, item, container, next, prev, custom, hide
    , Config, init, show, setView, setUpdate, setSubscriptions, setDimensions, Model, Message
    )

{-|


# Style and structure the content

@docs Content, item, container, next, prev, custom, hide


# Start your application

@docs Config, init, show, setView, setUpdate, setSubscriptions, setDimensions, Model, Message

-}

import Browser exposing (UrlRequest(..))
import Browser.Dom exposing (getViewport)
import Browser.Events exposing (onKeyDown, onResize)
import Browser.Navigation exposing (Key)
import Html exposing (Html, text)
import Html.Events exposing (keyCode)
import Json.Decode as Decode
import SliceShow.ContentData exposing (ContentData(..))
import SliceShow.Messages as Messages
import SliceShow.Model as Model
import SliceShow.Protected exposing (Protected(..))
import SliceShow.SlideData as SlideData exposing (SlideData)
import SliceShow.State exposing (State(..))
import SliceShow.Update as Update
import SliceShow.View as View
import Task
import Url


{-| Content type
-}
type alias Content a b =
    ContentData a b


{-| Single content item
-}
item : Html Never -> Content a b
item =
    Item Inactive


{-| A group of content items
-}
container : (List (Html (Message b)) -> Html (Message b)) -> List (Content a b) -> Content a b
container =
    Container Inactive


{-| Next button
-}
next : List (Html.Attribute Never) -> List (Html Never) -> Content a b
next =
    Next


{-| Prev button
-}
prev : List (Html.Attribute Never) -> List (Html Never) -> Content a b
prev =
    Prev


{-| Custom content item
-}
custom : a -> Content a b
custom =
    Custom Inactive


{-| Hide content, except for the prev and next buttons
-}
hide : Content a b -> Content a b
hide content =
    case content of
        Container _ render elements ->
            Container Hidden render elements

        Item _ html ->
            Item Hidden html

        Custom _ data ->
            Custom Hidden data

        Prev attrs html ->
            Prev attrs html

        Next attrs html ->
            Next attrs html


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
    { model : Key -> ( Int, Int ) -> Model a b
    , update : b -> a -> ( a, Cmd b )
    , view : a -> Html b
    , subscriptions : a -> Sub b
    , dimensions : ( Int, Int )
    }


{-| Init Model from the list of slides
-}
init : List (List (Content a b)) -> Config a b
init slides =
    Protected
        { model = Model.init (List.map SlideData.init slides)
        , view = \_ -> text ""
        , update = \_ a -> ( a, Cmd.none )
        , subscriptions = \_ -> Sub.none
        , dimensions = ( 1024, 640 )
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


{-| Set subscriptions for the custom content
-}
setSubscriptions : (a -> Sub b) -> Config a b -> Config a b
setSubscriptions subscriptions (Protected config) =
    Protected { config | subscriptions = subscriptions }


{-| Set custom dimensions for the slide's content.
The default dimensions are (1024, 640).
-}
setDimensions : ( Int, Int ) -> Config a b -> Config a b
setDimensions dimensions (Protected config) =
    Protected { config | dimensions = dimensions }


{-| Start the SliceShow with your `slides`:
app = show (init slides)
main = app.html
port tasks : Signal (Task.Task Never ())
port tasks = app.tasks
-}
show : Config a b -> Program () (Model.Model a b) (Messages.Message b)
show (Protected { model, update, view, subscriptions, dimensions }) =
    Browser.application
        { init =
            \_ { fragment } key ->
                ( Model.open fragment (model key dimensions)
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
