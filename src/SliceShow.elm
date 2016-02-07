module SliceShow (show) where
{-| This module helps you start your SliceShow application.
# Start your Application
@docs show
-}

import StartApp
import Html
import Task
import Effects
import SliceShow.Model exposing (Model, init)
import SliceShow.Update exposing (update)
import SliceShow.View exposing (view)
import SliceShow.Slide exposing (Slide)


{-| Start the SliceShow with your `slides`:
    app = show slides
    main = app.html
    port tasks : Signal (Task.Task Never ())
    port tasks = app.tasks
-}
show :
  List Slide ->
  { html : Signal Html.Html
  , tasks : Signal (Task.Task Effects.Never ())
  }
show slides =
  let
    app = StartApp.start
      { init = (init slides, Effects.none)
      , update = update
      , view = view
      , inputs = []
      }
  in
    { html = app.html
    , tasks = app.tasks
    }
