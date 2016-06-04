module SliceShow.SlideData exposing (SlideData, hasHiddenElements, next, update, subscriptions)

import SliceShow.State exposing (State(Inactive, Hidden))
import SliceShow.ContentData as Content exposing (ContentData)


type alias SlideData a b =
  { state : State
  , elements : List (ContentData a b)
  , dimensions : (Int, Int)
  }


update : (b -> a -> (a, Cmd b)) -> b -> SlideData a b -> (SlideData a b, Cmd b)
update updateCustom customAction slide =
  let
    (newElements, effects) = Content.update updateCustom customAction slide.elements
  in
    ({slide | elements = newElements}, Cmd.batch effects)


subscriptions : (a -> Sub b) -> SlideData a b -> Sub b
subscriptions customSubscription slide =
    Sub.batch (Content.subscriptions customSubscription slide.elements)


hasHiddenElements : SlideData a b -> Bool
hasHiddenElements {elements} =
  Content.hasHidden elements


next : SlideData a b -> SlideData a b
next slide =
  {slide | elements = Content.next slide.elements}
