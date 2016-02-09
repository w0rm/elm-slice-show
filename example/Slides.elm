module Slides (slides) where

import Html exposing (Html, text)
import SliceShow.Slide exposing (Slide, slide)
import SliceShow.Content exposing (title, listing, hide)

slides : List Slide
slides =
  [ slide
      "title1"
      [ title (text "Title1")
      ]
  , slide
      "title2"
      [ title (text "Title2")
      , listing
          [ text "Bullet1"
          , text "Bullet2"
          ] |> hide
      ]
  , slide
      "title3"
      [ title (text "Title3")
      ]
  ]
