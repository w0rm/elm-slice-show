module SliceShow (Config, init, show, setView, setUpdate, setInputs) where
{-| This module helps you start your SliceShow application.
# Start your Application
@docs SliceShow, Config, init, show, setView, setUpdate, setInputs
-}

import StartApp
import Html
import Task
import Effects exposing (Effects)
import SliceShow.Model as Model exposing (Model)
import SliceShow.Update as Update
import SliceShow.View as View
import SliceShow.Slide exposing (Slide)
import SliceShow.Actions as Actions
import SliceShow.Protected exposing (Protected, lock, unlock)
import Keyboard
import History
import Window
import Html exposing (text)
import Html.App as Html

{-| Slideshow Config type -}
type alias Config a b = Protected (PrivateConfig a b)


type alias PrivateConfig a b =
  { model : Model a
  , update : b -> a -> (a, Cmd b)
  , view : a -> Html.Html b
  , subscriptions : a -> Sub B
  }


{-| Init Model from the list of slides -}
init : List (Slide a) -> Config a b
init slides = lock
  { model = Model.init (List.map unlock slides)
  , view = (\_ -> text "")
  , update = (\_ a -> (a, Effects.none))
  , subscriptions = (\_ -> Sub.none)
  }


{-| Set view for the custom content -}
setView : (a -> Html.Html b) -> Config a b -> Config a b
setView view config =
  let
    unlocked = unlock config
  in
    lock {unlocked | view = view }


{-| Set update for the custom content -}
setUpdate : (b -> a -> (a, Cmd b)) -> Config a b -> Config a b
setUpdate update config =
  let
    unlocked = unlock config
  in
    lock {unlocked | update = update }


{-| Set inputs for the custom content -}
setSubscriptions : (a -> Sub b) -> Config a b -> Config a b
setSubscriptions subscriptions config =
  let
    unlocked = unlock config
  in
    lock {unlocked | subscriptions = subscriptions }


{-| Start the SliceShow with your `slides`:
    app = show (init slides)
    main = app.html
    port tasks : Signal (Task.Task Never ())
    port tasks = app.tasks
-}
show : Config a b -> Program Never
show config =
  let
    {model, update, view, subscriptions} = unlock config
    subscriptions model =
      Sub.batch
        [ onKeyDown 37 Actions.Prev
        , onKeyDown 39 Actions.Next
        , onKeyDown 27 Actions.Index
        , Window.resizes Actions.Resize
        ]
    -- TODO: calculate subscriptions for nested things
  in
    Html.program
      { init = (model, Cmd.none)
      , update = Update.update update
      , view = View.view view
      , subscriptions = subscriptions
      }
