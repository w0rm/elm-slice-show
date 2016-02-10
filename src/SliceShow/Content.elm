module SliceShow.Content (Content, listing, item, hide) where
{-| This module helps you define Slide content
@docs Content, listing, item, hide
-}

import Html exposing (Html)
import SliceShow.State exposing (State(Inactive, Hidden))
import SliceShow.ContentData exposing(ContentData(..))


{-| Content type -}
type alias Content = ContentData


{-| List of content -}
listing : List Content -> Content
listing = Listing Inactive


{-| Text item -}
item : Html -> Content
item = Item Inactive


{-| Hide content -}
hide : Content -> Content
hide content =
  case content of
    Listing _ elements -> Listing Hidden (List.map hide elements)
    Item _ html -> Item Hidden html
