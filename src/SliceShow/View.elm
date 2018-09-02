module SliceShow.View exposing (view)

import Html exposing (Html, a, div, li, ul)
import Html.Attributes exposing (href, style)
import Html.Events exposing (custom)
import Json.Decode as Json
import SliceShow.ContentData exposing (ContentData(..), state)
import SliceShow.Messages as Messages exposing (Message)
import SliceShow.Model exposing (Model, currentSlide)
import SliceShow.SlideData exposing (SlideData)
import SliceShow.State exposing (State(..))


fit : Int -> Int -> Int -> Int -> Float
fit w1 h1 w2 h2 =
    if w1 * h2 < w2 * h1 then
        toFloat w1 / toFloat w2

    else
        toFloat h1 / toFloat h2


toPx : Int -> String
toPx x =
    String.fromInt x ++ "px"


view : (a -> Html b) -> Model a b -> Html (Message b)
view renderCustom model =
    case currentSlide model of
        Nothing ->
            viewContainer renderCustom model

        Just slide ->
            viewSlide renderCustom model.width model.height slide


viewContainer : (a -> Html b) -> Model a b -> Html (Message b)
viewContainer renderCustom model =
    div [ style "text-align" "center" ]
        (List.indexedMap (viewSlideItem renderCustom) model.slides)


viewSlideItem : (a -> Html b) -> Int -> SlideData a b -> Html (Message b)
viewSlideItem renderCustom index slide =
    div
        [ style "position" "relative"
        , style "width" "240px"
        , style "height" "150px"
        , style "display" "inline-block"
        , style "margin" "20px 0 0 20px"
        , style "cursor" "pointer"
        , custom
            "click"
            (Json.succeed
                { preventDefault = True
                , stopPropagation = False
                , message = Messages.Goto index
                }
            )
        ]
        [ viewSlide renderCustom 240 150 slide
        , a
            [ style "position" "absolute"
            , style "left" "0"
            , style "top" "0"
            , style "width" "240px"
            , style "height" "150px"
            , href ("#" ++ String.fromInt (index + 1))
            ]
            []
        ]


viewSlide : (a -> Html b) -> Int -> Int -> SlideData a b -> Html (Message b)
viewSlide renderCustom width height slide =
    div
        [ style "transform" ("scale(" ++ String.fromFloat (fit width height slide.width slide.height) ++ ")")
        , style "width" (toPx slide.width)
        , style "height" (toPx slide.height)
        , style "position" "absolute"
        , style "left" "50%"
        , style "top" "50%"
        , style "margin-left" (toPx (slide.width // -2))
        , style "margin-top" (toPx (slide.height // -2))
        , style "background" "#fff"
        , style "box-sizing" "border-box"
        , style "text-align" "left"
        ]
        (viewElements renderCustom slide.elements)
        |> Html.map Messages.Custom


viewElements : (a -> Html b) -> List (ContentData a b) -> List (Html b)
viewElements renderCustom elements =
    elements
        |> List.filter (\c -> state c /= Hidden)
        |> List.map (viewElement renderCustom)


viewElement : (a -> Html b) -> ContentData a b -> Html b
viewElement renderCustom content =
    case content of
        Container _ render items ->
            render (viewElements renderCustom items)

        Item _ html ->
            html

        Custom _ data ->
            renderCustom data
