module Slides (slides) where

import Html exposing (Html, h1, text, ul, li, a, section)
import Html.Attributes exposing (href, target, style)
import SliceShow.Slide exposing (Slide, slide)
import SliceShow.Content exposing (Content, item, container, hide)


title : String -> Content
title str =
  item (h1 [] [text str])


bullets : List Content -> Content
bullets = container (ul [])


bullet : String -> Content
bullet str =
  item (li [] [text str])


bulletLink : String -> String -> Content
bulletLink str url =
  item (
    li
      []
      [ text (str ++ " — ")
      , a [href url, target "_blank"] [text url]
      ]
  )


paddedSlide : List Content -> Slide
paddedSlide content =
  slide
    [ container
        (section [style [("padding", "50px 100px")]])
        content
    ]


slides : List Slide
slides =
  List.map
    paddedSlide
    [ [ title "Why Elm Matters?" ]
    , [ title "Title 2"
      , bullets
          [ bullet "Bullet1" |> hide
          , bullet "Bullet2" |> hide
          ]
      ]
    , [ title "Links"
      , bullets
          [ bulletLink "Official website" "http://elm-lang.org/" |> hide
          , bulletLink "Elm tutorial" "http://www.elm-tutorial.org/" |> hide
          ]
      ]
    ]
