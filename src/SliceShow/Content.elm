module SliceShow.Content (Content, container, item, custom, hide) where
{-| This module helps you define Slide content
@docs Content, item, container, custom, hide
-}

import Html exposing (Html)
import SliceShow.State exposing (State(Inactive, Hidden))
import SliceShow.ContentData exposing (ContentData(..))


{-| Content type -}
type alias Content a = ContentData a


{-| Single content item -}
item : Html -> Content a
item = Item Inactive


{-| Custom content item -}
custom : a -> Content a
custom = Custom Inactive


{-| A group of content items -}
container : (List Html -> Html) -> List (Content a) -> (Content a)
container = Container Inactive


{-| Hide content -}
hide : (Content a) -> (Content a)
hide content =
  case content of
    Container _ render elements -> Container Hidden render elements
    Item _ html -> Item Hidden html
    Custom _ data -> Custom Hidden data
