module SliceShow exposing (Config, init, show, setView, setUpdate, setSubscriptions)
{-| This module helps you start your SliceShow application.
# Start your Application
@docs Config, init, show, setView, setUpdate, setSubscriptions
-}

import Html
import SliceShow.Model as Model exposing (Model)
import SliceShow.Update as Update
import SliceShow.View as View
import SliceShow.Slide exposing (Slide)
import SliceShow.Actions as Actions
import SliceShow.Protected exposing (Protected, lock, unlock)
import Keyboard
import Window
import Html exposing (Html, text)
import Navigation
import Task

{-| Slideshow Config type -}
type alias Config a b = Protected (PrivateConfig a b)


type alias PrivateConfig a b =
  { model : Model a b
  , update : b -> a -> (a, Cmd b)
  , view : a -> Html b
  , subscriptions : a -> Sub b
  }


{-| Init Model from the list of slides -}
init : List (Slide a b) -> Config a b
init slides = lock
  { model = Model.init (List.map unlock slides)
  , view = (\_ -> text "")
  , update = (\_ a -> (a, Cmd.none))
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
  in
    Navigation.program
      (Navigation.makeParser .hash)
      { init = \hash -> (Model.open hash model, Task.perform Actions.Resize Actions.Resize Window.size)
      , update = Update.update update
      , urlUpdate = \hash -> Update.update update (Actions.Open hash)
      , view = View.view view
      , subscriptions = \model ->
          Sub.batch
            [ Keyboard.downs (\code ->
                case code of
                  37 -> Actions.Prev
                  39 -> Actions.Next
                  27 -> Actions.Index
                  _ -> Actions.Noop
              )
            , Window.resizes Actions.Resize
            , Sub.map Actions.Custom (Model.subscriptions subscriptions model)
            ]
      }
