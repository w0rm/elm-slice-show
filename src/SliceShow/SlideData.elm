module SliceShow.SlideData (SlideData, hasHiddenElements, showNextElement) where

import SliceShow.State exposing (State(Inactive, Hidden))
import SliceShow.ContentData exposing (ContentData, hasHidden, showNext)


type alias SlideData =
  { name : String
  , state : State
  , elements : List ContentData
  , dimensions : (Int, Int)
  }


hasHiddenElements : SlideData -> Bool
hasHiddenElements {elements} =
  hasHidden elements


showNextElement : SlideData -> SlideData
showNextElement slide =
  {slide | elements = showNext slide.elements}
