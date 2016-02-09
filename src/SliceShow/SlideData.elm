module SliceShow.SlideData (SlideData) where

import SliceShow.State exposing (State(Inactive, Hidden))
import SliceShow.Content exposing (Content)


type alias SlideData =
  { name : String
  , state : State
  , elements : List Content
  , dimensions : (Int, Int)
  }
