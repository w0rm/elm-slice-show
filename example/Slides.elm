module Slides (slides) where

import Html exposing (Html, text)
import SliceShow.Slide exposing (Slide, slide)
import SliceShow.Content exposing (item, listing, hide)


slides : List Slide
slides =
  [ slide
      "title1"
      [ item (text "Title1")
      ]
  , slide
      "title2"
      [ item (text "Title2")
      , listing
          [ item (text "Bullet1") |> hide
          , item (text "Bullet2") |> hide
          ]
      ]
  , slide
      "title3"
      [ item (text "Title3")
      ]
  ]
