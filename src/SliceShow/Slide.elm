module SliceShow.Slide exposing (Slide, slide, setDimensions)

{-| This module helps you define a slide

@docs Slide, slide, setDimensions

-}

import SliceShow.Content exposing (Content)
import SliceShow.Protected exposing (Protected(..))
import SliceShow.SlideData exposing (SlideData)
import SliceShow.State exposing (State(..))


{-| Slide type
-}
type alias Slide a b =
    Protected (SlideData a b)


{-| Create new 1024x640 slide from a list of content items
-}
slide : List (Content a b) -> Slide a b
slide elements =
    Protected
        { elements = elements
        , state = Hidden
        , width = 1024
        , height = 640
        }


{-| Set custom dimensions
-}
setDimensions : ( Int, Int ) -> Slide a b -> Slide a b
setDimensions ( width, height ) (Protected data) =
    Protected { data | width = width, height = height }
