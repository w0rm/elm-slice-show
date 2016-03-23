module Slides (slides) where

import Html exposing (Html, h1, img, text, ul, li, a, p, div)
import Html.Attributes exposing (href, style, src)
import SliceShow.Slide exposing (Slide, slide)
import SliceShow.Content exposing (Content, item, container, hide)
import Markdown


slides : List Slide
slides =
  [ [ item (h1 [] [text "Slice Show"])
    , item (p [] [text "A simple presentation engine in Elm"])
    , item (img [src "assets/elm-slice-show.png"] [])
    ]
  , [ item (h1 [] [text "Features"])
    , bullets
        [ bullet "Custom style and markup" |> hide
        , bullet "Keyboard navigation" |> hide
        , bullet "Responsive" |> hide
        ]
    ]
  , [ item (h1 [] [text "Running the engine"])
    , code "elm" """sliceShow : SliceShow
sliceShow =
  SliceShow.init slides
  |> SliceShow.show

main : Signal Html
main = sliceShow.html

port tasks : Signal (Task Never ())
port tasks = sliceShow.tasks"""
    ]
  , [ item (h1 [] [text "Structuring the content"])
    , code "elm" """bullet : String -> Content
bullet str = item (li [] [text str])

bullets : List Content -> Content
bullets = container (ul [])

bulletsSlide : Slide
bulletsSlide =
  slide [bullets [bullet "first", bullet "second"]]"""
    ]
  , [ item (h1 [] [text "Syntax highlight"])
    , code "elm" """code : String -> String -> Content
code lang str =
  Markdown.toHtml
    ("```" ++ lang ++ "\\n" ++ str ++ "\\n```")
  |> item

codeSlide : Slide
codeSlide =
  slide
    [ code "elm" \"\"\"bullet : String -> Content
  bullet str = item (li [] [text str])\"\"\"
    ]
      """
    ]
  , [ item (h1 [] [text "Questions?"])
    , item (p [] [text "elm package install w0rm/elm-slice-show"])
    ]
  ]
  |> List.map paddedSlide


bullets : List Content -> Content
bullets =
  container (ul [])


bullet : String -> Content
bullet str =
  item (li [] [text str])


bulletLink : String -> String -> Content
bulletLink str url =
  item (li [] [a [href url] [text str]])


code : String -> String -> Content
code lang str =
  item (Markdown.toHtml ("```" ++ lang ++ "\n" ++ str ++ "\n```"))


paddedSlide : List Content -> Slide
paddedSlide content =
  slide [container (div [style [("padding", "50px 100px")]]) content]
