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


view : (Signal.Address b -> a -> Html) -> Signal.Address (Action b) -> Model a -> Html
view renderCustom address model =
  case currentSlide model of
    Nothing ->
      viewContainer renderCustom address model
    Just slide ->
      viewSlide renderCustom address model.dimensions slide


viewContainer : (Signal.Address b -> a -> Html) -> Signal.Address (Action b) -> Model a -> Html
viewContainer renderCustom address model =
  div
    [ style
        ["text-align" => "center"]
    ]
    (List.indexedMap (viewSlideItem renderCustom address) model.slides)


(=>) : a -> b -> (a, b)
(=>) = (,)


viewSlideItem : (Signal.Address b -> a -> Html) -> Signal.Address (Action b) -> Int -> SlideData a -> Html
viewSlideItem renderCustom address index slide =
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
    [ viewSlide renderCustom address (240, 150) slide ]


viewSlide : (Signal.Address b -> a -> Html) -> Signal.Address (Action b) -> (Int, Int) -> SlideData a -> Html
viewSlide renderCustom address dimensions slide =
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
    (viewElements renderCustom (Signal.forwardTo address Actions.Custom) slide.elements)


viewElements : (Signal.Address b -> a -> Html) -> Signal.Address b -> List (ContentData a) -> List Html
viewElements renderCustom customAddress elements =
  elements
  |> List.filter (\c -> state c /= Hidden)
  |> List.map (viewElement renderCustom customAddress)


viewElement : (Signal.Address b -> a -> Html) -> Signal.Address b -> ContentData a -> Html
viewElement renderCustom customAddress content =
  case content of
    Container _ render items ->
      render (viewElements renderCustom customAddress items)
    Item _ html ->
      html
    Custom _ data ->
      renderCustom customAddress data
