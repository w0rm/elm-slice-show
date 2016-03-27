module SliceShow (SliceShow, Config, init, show, setDimensions, setHash, setView, setUpdate, setInputs) where
{-| This module helps you start your SliceShow application.
# Start your Application
@docs SliceShow, Config, init, show, setDimensions, setHash, setView, setUpdate, setInputs
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


{-| SliceShow app, exposes html signal and tasks signal -}
type alias SliceShow =
  { html : Signal Html.Html
  , tasks : Signal (Task.Task Effects.Never ())
  }


{-| Slideshow Config type -}
type alias Config a b = Protected (PrivateConfig a b)


type alias PrivateConfig a b =
  { model : Model a
  , update : (b -> a -> (a, Effects b))
  , view : ((Signal.Address b) -> a -> Html.Html)
  , inputs : List (Signal b)
  }


{-| Init Model from the list of slides -}
init : List (Slide a) -> Config a b
init slides = lock
  { model = Model.init (List.map unlock slides)
  , view = (\_ _ -> text "")
  , update = (\_ a -> (a, Effects.none))
  , inputs = []
  }


{-| Set initial dimensions taken from port -}
setDimensions : (Int, Int) -> Config a b -> Config a b
setDimensions dimensions config =
  let
    unlocked = unlock config
  in
    lock {unlocked | model = Model.resize dimensions unlocked.model }


{-| Set initial hash taken from port -}
setHash : String -> Config a b -> Config a b
setHash hash config =
  let
    unlocked = unlock config
  in
    lock {unlocked | model = Model.open hash unlocked.model }


{-| Set view for the custom content -}
setView : ((Signal.Address b) -> a -> Html.Html) -> Config a b -> Config a b
setView view config =
  let
    unlocked = unlock config
  in
    lock {unlocked | view = view }


{-| Set update for the custom content -}
setUpdate : (b -> a -> (a, Effects b)) -> Config a b -> Config a b
setUpdate update config =
  let
    unlocked = unlock config
  in
    lock {unlocked | update = update }


{-| Set inputs for the custom content -}
setInputs : List (Signal b) -> Config a b -> Config a b
setInputs inputs config =
  let
    unlocked = unlock config
  in
    lock {unlocked | inputs = inputs }


{-| Start the SliceShow with your `slides`:
    app = show (init slides)
    main = app.html
    port tasks : Signal (Task.Task Never ())
    port tasks = app.tasks
-}
show : Config a b -> SliceShow
show config =
  let
    onKeyDown keyCode action =
      Signal.map
        (always action)
        (Signal.filter identity False (Keyboard.isDown keyCode))

    {model, update, view, inputs} = unlock config

    app = StartApp.start
      { init = (model, Effects.none)
      , update = Update.update update
      , view = View.view view
      , inputs =
          List.map (Signal.map Actions.Custom) inputs ++
          [ onKeyDown 37 Actions.Prev
          , onKeyDown 39 Actions.Next
          , onKeyDown 27 Actions.Index
          , Signal.map Actions.Open History.hash
          , Signal.map Actions.Resize Window.dimensions
          ]
      }
  in
    { html = app.html
    , tasks = app.tasks
    }
