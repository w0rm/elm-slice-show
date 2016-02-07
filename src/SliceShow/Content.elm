module SliceShow.Content (Content, title, listing, text, hide) where
{-| This module helps you define Slide content
@docs Content, title, listing, text, hide
-}

import Html exposing (Html)
import SliceShow.State exposing (State(Inactive, Hidden))


{-| Content type -}
type Content
  = Title State Html
  | Listing State (List Content)
  | Text State Html


{-| Title -}
title : Html -> Content
title = Title Inactive


{-| Bullets list -}
listing : List Html -> Content
listing items =
  Listing Inactive (List.map (Text Inactive) items)


{-| Text item -}
text : Html -> Content
text = Text Inactive


{-| Hide content -}
hide : Content -> Content
hide content =
  case content of
    Title _ html -> Title Hidden html
    Listing _ elements -> Listing Hidden (List.map hide elements)
    Text _ html -> Text Hidden html
