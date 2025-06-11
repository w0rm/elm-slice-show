module SliceShow.View exposing (view)

import Html exposing (Html, a, button, div, li, ul)
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
            viewSlide renderCustom model.width model.height model.dimensions slide


viewContainer : (a -> Html b) -> Model a b -> Html (Message b)
viewContainer renderCustom model =
    div [ style "text-align" "center" ]
        (List.indexedMap (viewSlideItem renderCustom model.dimensions) model.slides)


viewSlideItem : (a -> Html b) -> ( Int, Int ) -> Int -> SlideData a b -> Html (Message b)
viewSlideItem renderCustom dimensions index slide =
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
        [ viewSlide renderCustom 240 150 dimensions slide
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


viewSlide : (a -> Html b) -> Int -> Int -> ( Int, Int ) -> SlideData a b -> Html (Message b)
viewSlide renderCustom width height ( slideWidth, slideHeight ) slide =
    div
        [ style "transform" ("scale(" ++ String.fromFloat (fit width height slideWidth slideHeight) ++ ")")
        , style "width" (toPx slideWidth)
        , style "height" (toPx slideHeight)
        , style "position" "absolute"
        , style "left" "50%"
        , style "top" "50%"
        , style "margin-left" (toPx (slideWidth // -2))
        , style "margin-top" (toPx (slideHeight // -2))
        , style "background" "#fff"
        , style "box-sizing" "border-box"
        , style "text-align" "left"
        ]
        (viewElements renderCustom slide.elements)


viewElements : (a -> Html b) -> List (ContentData a b) -> List (Html (Message b))
viewElements renderCustom elements =
    elements
        |> List.filter (\c -> state c /= Hidden)
        |> List.map (viewElement renderCustom)


viewElement : (a -> Html b) -> ContentData a b -> Html (Message b)
viewElement renderCustom content =
    case content of
        Container _ render items ->
            render (viewElements renderCustom items)

        Item _ html ->
            html |> Html.map (\_ -> Messages.Noop)

        Custom _ data ->
            renderCustom data |> Html.map Messages.Custom

        Prev attrs html ->
            button
                (Html.Events.onClick Messages.Prev :: List.map (\a -> Html.Attributes.map (\_ -> Messages.Noop) a) attrs)
                (List.map (\a -> Html.map (\_ -> Messages.Noop) a) html)

        Next attrs html ->
            button
                (Html.Events.onClick Messages.Next :: List.map (\a -> Html.Attributes.map (\_ -> Messages.Noop) a) attrs)
                (List.map (\a -> Html.map (\_ -> Messages.Noop) a) html)
