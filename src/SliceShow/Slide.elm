module SliceShow.Slide (Slide, slide) where
{-| This module helps you define Slide model
@docs Slide, slide
-}

import SliceShow.State exposing (State(Inactive, Hidden))
import SliceShow.Content exposing (Content)
import SliceShow.SlideData exposing (ProtectedSlide, lock)

{-| Create new slide with title and items -}
slide : String -> List Content -> Slide
slide name elements =
  lock
    { name = name
    , elements = elements
    , state = Hidden
    }


{-| Slide type -}
type alias Slide = ProtectedSlide
