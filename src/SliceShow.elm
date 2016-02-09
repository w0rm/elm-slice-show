module SliceShow (SliceShow, Model, init, show, setDimensions, setHash) where
{-| This module helps you start your SliceShow application.
# Start your Application
@docs SliceShow, Model, init, show, setDimensions, setHash
-}

import StartApp
import Html
import Task
import Effects
import SliceShow.Model as PrivateModel
import SliceShow.Update exposing (update)
import SliceShow.View exposing (view)
import SliceShow.Slide exposing (Slide)
import SliceShow.Actions as Actions
import SliceShow.Protected exposing (Protected, lock, unlock)
import Keyboard
import Signal
import History
import Window


{-| Slideshow Model type -}
type alias Model = Protected PrivateModel.Model


{-| SliceShow app, exposes html signal and tasks signal -}
type alias SliceShow =
  { html : Signal Html.Html
  , tasks : Signal (Task.Task Effects.Never ())
  }


{-| Init Model from list of slides -}
init : List Slide -> Model
init slides = lock (PrivateModel.init (List.map unlock slides))


{-| Set initial dimensions taken from port -}
setDimensions : (Int, Int) -> Model -> Model
setDimensions dimensions model =
  let
    unlocked = unlock model
  in
    lock {unlocked | dimensions = dimensions }


{-| Set initial hash taken from port -}
setHash : String -> Model -> Model
setHash hash model =
  lock (PrivateModel.open hash (unlock model))


{-| Start the SliceShow with your `slides`:
    app = show (init slides)
    main = app.html
    port tasks : Signal (Task.Task Never ())
    port tasks = app.tasks
-}
show : Model -> SliceShow
show model =
  let
    onKeyDown keyCode action =
      Signal.map
        (always action)
        (Signal.filter identity False (Keyboard.isDown keyCode))

    app = StartApp.start
      { init = (unlock model, Effects.none)
      , update = update
      , view = view
      , inputs =
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
