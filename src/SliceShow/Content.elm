module SliceShow.Content (Content, container, item, hide) where
{-| This module helps you define Slide content
@docs Content, container, item, hide
-}

import Html exposing (Html)
import SliceShow.State exposing (State(Inactive, Hidden))
import SliceShow.ContentData exposing(ContentData(..))


{-| Content type -}
type alias Content = ContentData


{-| List of content -}
container : (List Html -> Html) -> List Content -> Content
container = Container Inactive


{-| Text item -}
item : Html -> Content
item = Item Inactive


{-| Hide content -}
hide : Content -> Content
hide content =
  case content of
    Container _ render elements -> Container Hidden render elements
    Item _ html -> Item Hidden html
