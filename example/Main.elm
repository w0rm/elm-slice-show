module Main exposing (..)

import SliceShow exposing (..)
import Slides exposing (slides, update, view, subscriptions)


main : Program Never (SliceShow.Model Slides.Model Slides.Message) (SliceShow.Message Slides.Message)
main =
    slides
        |> init
        |> setSubscriptions subscriptions
        |> setUpdate update
        |> setView view
        |> show
