module SliceShow.Content (Content, container, item, hide) where
{-| This module helps you define Slide content
@docs Content, item, container, hide
-}

import Html exposing (Html)
import SliceShow.State exposing (State(Inactive, Hidden))
import SliceShow.ContentData exposing(ContentData(..))


{-| Content type -}
type alias Content = ContentData


{-| Single content item -}
item : Html -> Content
item = Item Inactive


{-| A group of content items -}
container : (List Html -> Html) -> List Content -> Content
container = Container Inactive


{-| Hide content -}
hide : Content -> Content
hide content =
  case content of
    Container _ render elements -> Container Hidden render elements
    Item _ html -> Item Hidden html
