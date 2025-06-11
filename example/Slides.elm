module Slides exposing (Message, Model, slides, subscriptions, update, view)

import Browser.Events exposing (onAnimationFrameDelta)
import Html exposing (Html, a, div, h1, img, li, p, small, text, ul)
import Html.Attributes exposing (href, src, style)
import Markdown
import SliceShow exposing (..)

{-| Model type of the custom content
-}
type alias Model =
    Float


{-| Message type for the custom content
-}
type alias Message =
    Float


{-| Type for custom content
-}
type alias CustomContent =
    Content Model Message


{-| Type for custom slide
-}
type alias CustomSlide =
    List (Content Model Message)


{-| Update function for the custom content
-}
update : Message -> Model -> ( Model, Cmd Message )
update dt time =
    ( time + dt, Cmd.none )


{-| View function for the custom content that shows elapsed time for the slide
-}
view : Model -> Html Message
view time =
    p
        []
        [ text ("Elapsed: " ++ (round time // 1000 |> String.fromInt) ++ " seconds")
        ]


{-| Inputs for the custom content
-}
subscriptions : Model -> Sub Message
subscriptions _ =
    onAnimationFrameDelta identity


{-| The list of slides
-}
slides : List CustomSlide
slides =
    [ [ item (h1 [] [ text "Slice Show" ])
      , item (p [] [ text "A simple presentation engine in Elm" ])
      , item (img [ src "assets/elm-slice-show.png" ] [])
      ]
    , [ item (h1 [] [ text "Features" ])
      , bullets
            [ bullet "Custom style and markup" |> hide
            , bullet "Custom content with its own inputs-update-view" |> hide
            , bullet "Keyboard navigation" |> hide
            , bullet "Responsive" |> hide
            ]
      ]
    , [ item (h1 [] [ text "Running the engine" ])
      , code "elm" """main : Program Never
main =
  SliceShow.init slides
  |> SliceShow.show"""
      ]
    , [ item (h1 [] [ text "Structuring the content" ])
      , code "elm" """bullet : String -> Content {} {}
bullet str = item (li [] [text str])

bullets : List (Content {} {}) -> Content {} {}
bullets = container (ul [])

bulletsSlide : List (Content {} {})
bulletsSlide =
    [bullets [bullet "first", bullet "second"]]"""
      ]
    , [ item (h1 [] [ text "Syntax highlight" ])
      , code "elm" """code : String -> String -> Content {} {}
code lang str =
  Markdown.toHtml
    []
    ("```" ++ lang ++ "\\n" ++ str ++ "\\n```")
  |> item

codeSlide : List (Content {} {})
codeSlide =
  [ code "elm" \"\"\"bullet : String -> Content {} {}
  bullet str = item (li [] [text str])\"\"\"
  ]"""
      ]
    , [ item (h1 [] [text "Prev and Next buttons"])
      , code "elm" """nextButton : Content {} {}
nextButton = next [] [text "Click to go to the next slide"]
    """
      , next [] [text "Click to go to the next slide"]
      ]
    , [ item (h1 [] [ text "Custom content" ])
      , code "elm" """elapsed : Content Time Time
elapsed = custom 0

slide : List (Content {} {})
slide = [item (text "Elapsed: "), elapsed]

main : Program Never
main = init [slide]
  |> setSubscriptions (\\_ -> onAnimationFrameDelta identity)
  |> setUpdate (\\dt time -> (time + dt, Cmd.none))
  |> setView (\\time -> text ("Elapsed: " ++ (round time // 1000 |> String.fromInt) ++ " seconds"))
  |> show"""
      , custom 0
      ]
    , [ item (h1 [] [ text "Questions?" ])
      , item (p [] [ text "elm package install w0rm/elm-slice-show" ])
      ]
    ]
        |> List.map paddedSlide


bullets : List CustomContent -> CustomContent
bullets =
    container (ul [])


bullet : String -> CustomContent
bullet str =
    item (li [] [ text str ])


bulletLink : String -> String -> CustomContent
bulletLink str url =
    item (li [] [ a [ href url ] [ text str ] ])


{-| Syntax higlighted code block, needs highlight.js in index.html
-}
code : String -> String -> CustomContent
code lang str =
    item (Markdown.toHtml [] ("```" ++ lang ++ "\n" ++ str ++ "\n```"))


{-| Custom slide that sets the padding
-}
paddedSlide : List CustomContent -> CustomSlide
paddedSlide content =
    [ container
        (div [ style "padding" "50px 100px" ])
        content
    ]
