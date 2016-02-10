module Slides (slides) where

import Html exposing (Html, h1, text, ul, li, a, section)
import Html.Attributes exposing (href, target, style)
import SliceShow.Slide exposing (Slide, slide)
import SliceShow.Content exposing (Content, item, container, hide)
import Markdown exposing (toHtml)


title : String -> Content
title str = item (h1 [] [text str])


bullets : List Content -> Content
bullets = container (ul [])


bullet : String -> Content
bullet str = item (li [] [text str])


code : String -> Content
code str = item (toHtml ("```elm\n" ++ str ++ "\n```"))


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
    , [ title "From React to Elm" ]
    , [ title "Compare JavaScript setup with Elm" ]
    , [ title "Functions"
      , code "paddedSlide : List Content -> Slide"
      ]
    , [ title "Types" ]
    , [ title "Pattern Matching" ]
    , [ title "Compiler Features" ]
    , [ title "Signals" ]
    , [ title "Html" ]
    , [ title "Elm Architecture" ]
    , [ title "JavaScript Interoperability" ]
    , [ title "More Features" ]
    , [ title "Links"
      , [ bulletLink "Official website" "http://elm-lang.org/"
        , bulletLink "Elm tutorial" "http://www.elm-tutorial.org/"
        , bulletLink "Elm for JS" "https://github.com/elm-guides/elm-for-js"
        , bulletLink "Elm Slice Show" "https://github.com/w0rm/elm-slice-show"
        ]
        |> List.map hide
        |> bullets
      ]
    ]
