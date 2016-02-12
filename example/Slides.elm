module Slides (slides) where

import Html exposing (Html, h1, img, text, ul, li, a, section, div, br)
import Html.Attributes exposing (href, target, style, src)
import SliceShow.Slide exposing (Slide, slide)
import SliceShow.Content exposing (Content, item, container, hide)
import Markdown exposing (toHtml)


(=>) : a -> b -> (a, b)
(=>) = (,)


title : String -> Content
title str = item (h1 [] [text str])


bullets : List Content -> Content
bullets = container (ul [])


bullet : String -> Content
bullet str = item (li [] [text str])


code : String -> String -> Content
code lang str = item (toHtml ("```" ++ lang ++ "\n" ++ str ++ "\n```"))


spacer : Content
spacer = item (br [] [])


richtext : String -> Content
richtext str = item (toHtml str)


bulletLink : String -> String -> Content
bulletLink str url = item (li [] [a [href url, target "_blank"] [text str]])


paddedSlide : List Content -> Slide
paddedSlide content = slide [container (section [style [("padding", "50px 100px")]]) content]


slides : List Slide
slides =
  List.map
    paddedSlide
    [ [ title "Introduction to Elm"
      , richtext """Elm — functional reactive programming language that is statically typed and compiles to JavaScript"""
      , spacer
      , richtext """### Andrey Kuzmin @unsoundscapes""" |> hide
      , container
          ( div
              [ style
                  [ "background" => "url(assets/unsoundscapes.jpg) bottom right no-repeat"
                  , "height" => "294px"
                  ]
              ]
          )
          [ [ bulletLink "elm—unsoundscapes" "https://github.com/w0rm/elm-unsoundscapes"
            , bulletLink "elm—flatris" "https://github.com/w0rm/elm-flatris" |> hide
            , bulletLink "elm—street—404" "https://github.com/zalando/elm-street-404" |> hide
            , bullet "elm—..." |> hide
            ]
            |> bullets
          ]
        |> hide
      ]
    , [ title "From React to Elm"
      , [ bullet "React describes UI as a function of state"
        , bullet "Flux utilizes a unidirectional data flow"
        , bullet "Redux streamlines Flux and turns stores into reducers"
        ]
        |> List.map hide
        |> bullets
      , spacer
      , richtext (
          "[**Redux inspired by Elm:**](https://github.com/rackt/redux/blob/master/docs/introduction/PriorArt.md#elm)\n\n" ++
          "> Even if you don’t plan to use Elm, you should read about the Elm architecture, and play with it.\n\n" ++
          "> We should look there for inspiration on Redux! One way that we can get closer to the static typing of Elm is by using a gradual typing solution like Flow."
        )
        |> hide
      ]
    , [ title "JavaScript Tooling vs Elm"
      , item (img [src "assets/javascript-vs-elm.png"] [])
      , item
          ( div
              [style ["font-size" => "small", "text-align" => "right"]]
              [text "The idea of the slide belongs to @rtfeldman"]
          )
      ]
    , [ title "Functions"
      , code
          "elm"
          ( "plus : Int -> Int -> Int\n" ++
            "plus x y =\n" ++
            "  x + y"
          )
      , code
          "elm"
          ( "plusOne : Int -> Int\n" ++
            "plusOne y = plus 1 y"
          )
        |> hide
      , code "elm" "plusOne = (+) 1" |> hide
      , code
          "elm"
          ( "plusOneToEach : List Int -> List Int\n" ++
            "plusOneToEach list =\n" ++
            "  List.map ((+) 1) list"
          )
        |> hide
      , code "elm" "plusOneToEach = List.map ((+) 1)" |> hide
      ]
    , [ title "Types"
      , code
          "elm"
          ( "type alias Circle =\n" ++
            "  { coordinates : (Int, Int)\n" ++
            "  , radius : Int\n" ++
            "  }"
          )
      , code
          "elm"
          ( "circle : Int -> Int -> Int -> Circle\n" ++
            "circle x y r = \n" ++
            "  {coordinates = (x, y), radius = r}"
          )
        |> hide
      , code
          "elm"
          ( "move : Int -> Int -> Circle -> Circle\n" ++
            "move x y c = \n" ++
            "  {c | coordinates = (x, y)}"
          )
        |> hide
      ]
    , [ title "Types"
      , code "elm" "type Response = Data String | Error"
      , code
          "elm"
          ( "toString : Response -> String\n" ++
            "toString response =\n" ++
            "  case response of\n" ++
            "    Data string -> \n" ++
            "      string\n" ++
            "    Error -> \n" ++
            "      \"Sorry, there was an error\""
          )
        |> hide
      ]
    , [ title "Pattern Matching"
      , code
          "elm"
          ( "reverse : List a -> List a\n" ++
            "reverse list =\n" ++
            "  case list of\n" ++
            "    [] ->\n" ++
            "      []\n" ++
            "    el :: rest ->\n" ++
            "      reverse rest ++ [el]"
          )
      ]
    , [ title "Elm Compiler"
      , code
          "elm"
          ( "circle : Int -> Int -> Int -> Circle\n" ++
            "circle x y r =\n" ++
            "  {coordinates = (x, y)}"
          )
      , spacer
      , code
          ""
          ( "The type annotation for `circle` does not match its definition.\n" ++
            "1│ circle : Int -> Int -> Int -> Circle\n" ++
            "            ^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\n" ++
            "The type annotation is saying:\n" ++
            "    Int -> Int -> Int -> { ..., radius : ... }\n\n" ++
            "But I am inferring that the definition has this type:\n" ++
            "    Int -> Int -> Int -> { ... }\n"
          )
        |> hide
      ]
    , [ title "Signals"
      , code
          "elm"
          ( "import Html exposing (Html, text)\n" ++
            "import Keyboard\n\n" ++
            "main : Signal Html\n" ++
            "main =\n" ++
            "  Signal.map\n" ++
            "    (\\code -> text (toString code))\n" ++
            "    Keyboard.presses\n"
          )
      ]
    , [ title "Html"
      , code
          "elm"
          ( "import Html exposing (Html, label, text)\n" ++
            "import Html.Attributes exposing (style, for)\n\n" ++
            "renderLabel : String -> String -> Html\n" ++
            "renderLabel inputId txt =\n" ++
            "  label\n" ++
            "    [ style\n" ++
            "        [ (\"color\", \"#bdc3c7\")\n" ++
            "        , (\"font-weight\", \"300\")\n" ++
            "        ]\n" ++
            "    , for inputId\n" ++
            "    ]\n" ++
            "    [ text txt ]\n"
          )
      ]
    , [ title "Elm Architecture"
      , code "elm" "import StartApp"
      , code "elm" "update : Action -> Model -> (Model, Effects Action)" |> hide
      , code "elm" "view : Signal.Address Action -> Model -> Html" |> hide
      , code
          "elm"
          ( "app = StartApp.start\n" ++
            "  { init = (initialModel, Effects.none)\n" ++
            "  , update = update\n" ++
            "  , view = view\n" ++
            "  , inputs = []\n" ++
            "  }"
          )
         |> hide
      , code "elm" "main = app.html" |> hide
      , code "elm" "port tasks = app.tasks" |> hide
      ]
    , [ title "Elm Features"
      , bullets
          [ bullet "Descriptive compiler errors"
          , bullet "No runtime exceptions"
          , bullet "Enforced semantic versioning"
          , bullet "Fast HTML rendering"
          ]
      ]
    , [ title "Links"
      , bullets
          [ bulletLink "Official Documentation" "http://elm-lang.org/docs"
          , bulletLink "Elm for JS" "https://github.com/elm-guides/elm-for-js"
          , bulletLink "Elm tutorial" "http://www.elm-tutorial.org"
          , bulletLink "Elm Slice Show" "https://github.com/w0rm/elm-slice-show"
          ]
      ]
    , [ img [src "assets/zalando.png"] [] |> item
      , spacer
      , bullets
          [ bulletLink "@ZalandoTech" "https://twitter.com/zalandotech"
          , bulletLink "Zalando Tech Blog" "https://tech.zalando.com/"
          ]
      ]
    ]
