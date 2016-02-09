module SliceShow.SlideData (ProtectedSlide(..), SlideData, unlock, lock) where

import SliceShow.State exposing (State(Inactive, Hidden))
import SliceShow.Content exposing (Content)


type ProtectedSlide = Protected SlideData


type alias SlideData =
  { name : String
  , state : State
  , elements : List Content
  }


unlock : ProtectedSlide -> SlideData
unlock (Protected data) = data


lock : SlideData -> ProtectedSlide
lock = Protected
