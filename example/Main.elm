module Main exposing (main)

import SliceShow exposing (..)
import Slides exposing (slides, subscriptions, update, view)


main : Program () (SliceShow.Model Slides.Model Slides.Message) (SliceShow.Message Slides.Message)
main =
    slides
        |> init
        |> setSubscriptions subscriptions
        |> setUpdate update
        |> setView view
        |> show
