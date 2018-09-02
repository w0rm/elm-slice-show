module SliceShow.Content exposing (Content, item, container, custom, hide)

{-| This module helps you define Slide content

@docs Content, item, container, custom, hide

-}

import Html exposing (Html)
import SliceShow.ContentData exposing (ContentData(..))
import SliceShow.State exposing (State(..))


{-| Content type
-}
type alias Content a b =
    ContentData a b


{-| Single content item
-}
item : Html b -> Content a b
item =
    Item Inactive


{-| Custom content item
-}
custom : a -> Content a b
custom =
    Custom Inactive


{-| A group of content items
-}
container : (List (Html b) -> Html b) -> List (Content a b) -> Content a b
container =
    Container Inactive


{-| Hide content
-}
hide : Content a b -> Content a b
hide content =
    case content of
        Container _ render elements ->
            Container Hidden render elements

        Item _ html ->
            Item Hidden html

        Custom _ data ->
            Custom Hidden data
