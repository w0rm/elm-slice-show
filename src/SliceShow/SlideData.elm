module SliceShow.SlideData exposing (SlideData, hasHiddenElements, next, subscriptions, update)

import SliceShow.ContentData as Content exposing (ContentData)
import SliceShow.State exposing (State(..))


type alias SlideData a b =
    { state : State
    , elements : List (ContentData a b)
    , width : Int
    , height : Int
    }


update : (b -> a -> ( a, Cmd b )) -> b -> SlideData a b -> ( SlideData a b, Cmd b )
update updateCustom customAction slide =
    let
        ( newElements, effects ) =
            Content.update updateCustom customAction slide.elements
    in
    ( { slide | elements = newElements }, Cmd.batch effects )


subscriptions : (a -> Sub b) -> SlideData a b -> Sub b
subscriptions customSubscription slide =
    Sub.batch (Content.subscriptions customSubscription slide.elements)


hasHiddenElements : SlideData a b -> Bool
hasHiddenElements { elements } =
    Content.hasHidden elements


next : SlideData a b -> SlideData a b
next slide =
    { slide | elements = Content.next slide.elements }
