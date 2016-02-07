module SliceShow.Model (Model, init) where

import SliceShow.Slide exposing (Slide)
import Maybe


type alias Model =
  { currentSlide : Maybe Int
  , slides : List Slide
  }


init : List Slide -> Model
init slides =
  { currentSlide = Nothing
  , slides = slides
  }
