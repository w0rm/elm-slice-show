module SliceShow (show, SliceShow) where
{-| This module helps you start your SliceShow application.
# Start your Application
@docs SliceShow, show
-}

import StartApp
import Html
import Task
import Effects
import SliceShow.Model exposing (Model, init)
import SliceShow.Update exposing (update)
import SliceShow.View exposing (view)
import SliceShow.Slide exposing (Slide)
import SliceShow.Actions as Actions
import Keyboard
import Signal
import History


{-| SliceShow app, exposes html signal and tasks signal -}
type alias SliceShow =
  { html : Signal Html.Html
  , tasks : Signal (Task.Task Effects.Never ())
  }


{-| Start the SliceShow with your `slides`:
    app = show slides
    main = app.html
    port tasks : Signal (Task.Task Never ())
    port tasks = app.tasks
-}
show : List Slide -> SliceShow
show slides =
  let
    onKeyDown keyCode action =
      Signal.map
        (always action)
        (Signal.filter identity False (Keyboard.isDown keyCode))

    app = StartApp.start
      { init = (init slides, Effects.none)
      , update = update
      , view = view
      , inputs =
          [ onKeyDown 37 Actions.Prev
          , onKeyDown 39 Actions.Next
          , onKeyDown 27 Actions.Index
          , Signal.map Actions.Goto History.hash
          ]
      }
  in
    { html = app.html
    , tasks = app.tasks
    }
