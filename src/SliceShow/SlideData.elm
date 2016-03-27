module SliceShow.SlideData (SlideData, hasHiddenElements, showNextElement, updateCustomElement) where

import SliceShow.State exposing (State(Inactive, Hidden))
import SliceShow.ContentData exposing (ContentData, hasHidden, showNext, update)
import Effects exposing (Effects)


type alias SlideData a =
  { state : State
  , elements : List (ContentData a)
  , dimensions : (Int, Int)
  }


updateCustomElement : (b -> a -> (a, Effects b)) -> b -> SlideData a -> (SlideData a, Effects b)
updateCustomElement updateCustom customAction slide =
  let
    (newElements, effects) = update updateCustom customAction slide.elements
  in
    ({slide | elements = newElements}, Effects.batch effects)


hasHiddenElements : SlideData a -> Bool
hasHiddenElements {elements} =
  hasHidden elements


showNextElement : SlideData a -> SlideData a
showNextElement slide =
  {slide | elements = showNext slide.elements}
