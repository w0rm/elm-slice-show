module Slides (slides, update, view, inputs) where

import Html exposing (Html, h1, img, text, ul, li, a, p, div, small)
import Html.Attributes exposing (href, style, src)
import SliceShow.Slide exposing (..)
import SliceShow.Content exposing (..)
import Markdown
import Effects exposing (Effects)
import Time exposing (Time)


{- Model type of the custom content -}
type alias Model = Time


{- Action type for the custom content -}
type alias Action = Time


{- Update function for the custom content -}
update : Action -> Model -> (Model, Effects Action)
update elapsed time =
  (time + elapsed, Effects.none)


{- View function for the custom content that shows elapsed time for the slide -}
view : Signal.Address Action -> Model -> Html
view _ time =
  small
    [ style [("position", "absolute"), ("bottom", "0"), ("right", "0")] ]
    [ text
        ( "the slide is visible for " ++
          (Time.inSeconds time |> round |> toString) ++
          " seconds"
        )
    ]


{- Inputs for the custom content -}
inputs : List (Signal Action)
inputs = [Time.fps 1]


{- The list of slides -}
slides : List (Slide Action)
slides =
  [ [ item (h1 [] [text "Slice Show"])
    , item (p [] [text "A simple presentation engine in Elm"])
    , item (img [src "assets/elm-slice-show.png"] [])
    ]
  , [ item (h1 [] [text "Features"])
    , bullets
        [ bullet "Custom style and markup" |> hide
        , bullet "Custom content with its own inputs-update-view" |> hide
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
    , code "elm" """bullet : String -> Content {}
bullet str = item (li [] [text str])

bullets : List (Content {}) -> Content {}
bullets = container (ul [])

bulletsSlide : Slide {}
bulletsSlide =
  slide [bullets [bullet "first", bullet "second"]]"""
    ]
  , [ item (h1 [] [text "Syntax highlight"])
    , code "elm" """code : String -> String -> Content {}
code lang str =
  Markdown.toHtml
    ("```" ++ lang ++ "\\n" ++ str ++ "\\n```")
  |> item

codeSlide : Slide {}
codeSlide =
  slide
    [ code "elm" \"\"\"bullet : String -> Content {}
  bullet str = item (li [] [text str])\"\"\"
    ]
      """
    ]
  , [ item (h1 [] [text "Custom slides"])
    , code "elm" """elapsed : Content Time
elapsed = custom 0

slide : Slide Time
slide = slide [item (text "Elapsed: "), elapsed]

sliceShow : SliceShow
sliceShow = init [slide]
  |> setInputs [fps 1]
  |> setUpdate (\\dt time -> (time + dt, Effects.none))
  |> setView (\\_ time -> text (toString time))
  |> show"""
    ]
  , [ item (h1 [] [text "Questions?"])
    , item (p [] [text "elm package install w0rm/elm-slice-show"])
    ]
  ]
  |> List.map paddedSlide


bullets : List (Content Model) -> Content Model
bullets =
  container (ul [])


bullet : String -> Content Model
bullet str =
  item (li [] [text str])


bulletLink : String -> String -> Content Model
bulletLink str url =
  item (li [] [a [href url] [text str]])


{- Syntax higlighted code block, needs highlight.js in index.html -}
code : String -> String -> Content Model
code lang str =
  item (Markdown.toHtml ("```" ++ lang ++ "\n" ++ str ++ "\n```"))


{- Custom slide that sets the padding and appends the custom content -}
paddedSlide : List (Content Model) -> Slide Model
paddedSlide content =
  slide
    [ container
        (div [style [("padding", "50px 100px")]])
        (content ++ [custom 0])
    ]
