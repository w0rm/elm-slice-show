module Slides exposing (slides, update, view, subscriptions, Model, Message)

import Html exposing (Html, h1, img, text, ul, li, a, p, div, small)
import Html.Attributes exposing (href, style, src)
import SliceShow.Slide exposing (..)
import SliceShow.Content exposing (..)
import Markdown
import Time exposing (Time)
import AnimationFrame


{-| Model type of the custom content
-}
type alias Model =
    Time


{-| Message type for the custom content
-}
type alias Message =
    Time


{-| Type for custom content
-}
type alias CustomContent =
    Content Model Message


{-| Type for custom slide
-}
type alias CustomSlide =
    Slide Model Message


{-| Update function for the custom content
-}
update : Message -> Model -> ( Model, Cmd Message )
update elapsed time =
    ( time + elapsed, Cmd.none )


{-| View function for the custom content that shows elapsed time for the slide
-}
view : Model -> Html Message
view time =
    small
        [ style [ ( "position", "absolute" ), ( "bottom", "0" ), ( "right", "0" ) ] ]
        [ text
            ("the slide is visible for "
                ++ (Time.inSeconds time |> round |> toString)
                ++ " seconds"
            )
        ]


{-| Inputs for the custom content
-}
subscriptions : Model -> Sub Message
subscriptions _ =
    AnimationFrame.diffs identity


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

bulletsSlide : Slide {} {}
bulletsSlide =
  slide [bullets [bullet "first", bullet "second"]]"""
      ]
    , [ item (h1 [] [ text "Syntax highlight" ])
      , code "elm" """code : String -> String -> Content {} {}
code lang str =
  Markdown.toHtml
    []
    ("```" ++ lang ++ "\\n" ++ str ++ "\\n```")
  |> item

codeSlide : Slide {} {}
codeSlide =
  slide
    [ code "elm" \"\"\"bullet : String -> Content {} {}
  bullet str = item (li [] [text str])\"\"\"
    ]
      """
      ]
    , [ item (h1 [] [ text "Custom slides" ])
      , code "elm" """elapsed : Content Time Time
elapsed = custom 0

slide : Slide Time Time
slide = slide [item (text "Elapsed: "), elapsed]

main : Program Never
main = init [slide]
  |> setSubscriptions (\\_ -> AnimationFrame.diffs identity)
  |> setUpdate (\\dt time -> (time + dt, Cmd.none))
  |> setView (\\time -> text (toString time))
  |> show"""
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


{-| Custom slide that sets the padding and appends the custom content
-}
paddedSlide : List CustomContent -> CustomSlide
paddedSlide content =
    slide
        [ container
            (div [ style [ ( "padding", "50px 100px" ) ] ])
            (content ++ [ custom 0 ])
        ]
