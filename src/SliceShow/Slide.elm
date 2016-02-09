module SliceShow.Slide (Slide, slide) where
{-| This module helps you define Slide model
@docs Slide, slide
-}

import SliceShow.State exposing (State(Inactive, Hidden))
import SliceShow.Content exposing (Content)
import SliceShow.Protected exposing (Protected, lock)
import SliceShow.SlideData exposing (SlideData)


{-| Slide type -}
type alias Slide = Protected SlideData


{-| Create new slide with title and items -}
slide : String -> List Content -> Slide
slide name elements =
  lock
    { name = name
    , elements = elements
    , state = Hidden
    , dimensions = (1024, 640)
    }
