import SliceShow exposing (show)
import Html exposing (Html, text)
import Task exposing (Task)
import Effects exposing (Never)
import SliceShow.Slide exposing (Slide, slide)
import SliceShow.Content exposing (title, listing, hide)


app : {html : Signal Html, tasks : Signal (Task Never ())}
app =
  show
    [ slide
        "title1"
        [title (text "Title1")]
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
        [title (text "Title3")]
    ]


main : Signal Html
main = app.html


port tasks : Signal (Task Never ())
port tasks = app.tasks
