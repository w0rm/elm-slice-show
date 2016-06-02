module SliceShow.SlideData (SlideData, hasHiddenElements, showNextElement, updateCustomElement) where

import SliceShow.State exposing (State(Inactive, Hidden))
import SliceShow.ContentData exposing (ContentData, hasHidden, showNext, update)


type alias SlideData a b =
  { state : State
  , elements : List (ContentData a b)
  , dimensions : (Int, Int)
  }


updateCustomElement : (b -> a -> (a, Cmd b)) -> b -> SlideData a b -> (SlideData a b, Cmd b)
updateCustomElement updateCustom customAction slide =
  let
    (newElements, effects) = update updateCustom customAction slide.elements
  in
    ({slide | elements = newElements}, Cmd.batch effects)


hasHiddenElements : SlideData a b -> Bool
hasHiddenElements {elements} =
  hasHidden elements


showNextElement : SlideData a b -> SlideData a b
showNextElement slide =
  {slide | elements = showNext slide.elements}
