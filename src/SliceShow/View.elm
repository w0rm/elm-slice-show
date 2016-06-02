module SliceShow.View (view) where

import Html exposing (Html, div, ul, li, a)
import Html.Attributes exposing (style, href)
import SliceShow.Actions as Actions exposing (Action)
import SliceShow.Model exposing (Model, currentSlide)
import SliceShow.SlideData exposing (SlideData)
import SliceShow.ContentData exposing(ContentData(..), state)
import SliceShow.State exposing (State(Hidden))


fit : (Int, Int) -> (Int, Int) -> Float
fit (w1, h1) (w2, h2) =
  if w1 * h2 < w2 * h1 then
    toFloat w1 / toFloat w2
  else
    toFloat h1 / toFloat h2


toPx : Int -> String
toPx x = toString x ++ "px"


view : (a -> Html b) -> Model a -> Html b
view renderCustom model =
  case currentSlide model of
    Nothing ->
      viewContainer renderCustom model
    Just slide ->
      viewSlide renderCustom model.dimensions slide


viewContainer : (a -> Html b) -> Model a -> Html b
viewContainer renderCustom model =
  div
    [ style
        ["text-align" => "center"]
    ]
    (List.indexedMap (viewSlideItem renderCustom) model.slides)


(=>) : a -> b -> (a, b)
(=>) = (,)


viewSlideItem : (a -> Html b) -> Int -> SlideData a -> Html b
viewSlideItem renderCustom index slide =
  a
    [ style
        [ "position" => "relative"
        , "width" => "240px"
        , "height" => "150px"
        , "display" => "inline-block"
        , "margin" => "20px 0 0 20px"
        ]
    , href ("#" ++ toString (index + 1))
    ]
    [ viewSlide renderCustom (240, 150) slide ]


viewSlide : (a -> Html b) -> (Int, Int) -> SlideData a -> Html b
viewSlide renderCustom dimensions slide =
  div
    [ style
        [ "transform" => ("scale(" ++ toString (fit dimensions slide.dimensions) ++ ")")
        , "width" => toPx (fst slide.dimensions)
        , "height" => toPx (snd slide.dimensions)
        , "position" => "absolute"
        , "left" => "50%"
        , "top" => "50%"
        , "margin-left" => toPx (fst slide.dimensions // -2)
        , "margin-top" => toPx (snd slide.dimensions // -2)
        , "background" => "#fff"
        , "box-sizing" => "border-box"
        , "text-align" => "left"
        ]
    ]
    (viewElements renderCustom slide.elements |> Html.map Actions.Custom)


viewElements : (a -> Html b) -> List (ContentData a) -> List Html b
viewElements renderCustom elements =
  elements
  |> List.filter (\c -> state c /= Hidden)
  |> List.map (viewElement renderCustom customAddress)


viewElement : (a -> Html b) -> ContentData a -> Html b
viewElement renderCustom content =
  case content of
    Container _ render items ->
      render (viewElements renderCustom items)
    Item _ html ->
      html
    Custom _ data ->
      renderCustom data
