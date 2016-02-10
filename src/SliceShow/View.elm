module SliceShow.View (view) where

import Html exposing (Html, div, ul, li, a)
import Html.Attributes exposing (style, href)
import SliceShow.Actions exposing (Action)
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


view : Signal.Address Action -> Model -> Html
view address model =
  case currentSlide model of
    Nothing ->
      viewContainer address model
    Just slide ->
      viewSlide address model.dimensions slide


viewContainer : Signal.Address Action -> Model -> Html
viewContainer address model =
  div
    [ style
        ["text-align" => "center"]
    ]
    (List.indexedMap (viewSlideItem address) model.slides)


(=>) : a -> b -> (a, b)
(=>) = (,)


viewSlideItem : Signal.Address Action -> Int -> SlideData -> Html
viewSlideItem address index slide =
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
    [ viewSlide address (240, 150) slide ]


viewSlide : Signal.Address Action -> (Int, Int) -> SlideData -> Html
viewSlide address dimensions slide =
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
    (viewElements slide.elements)


viewElements : List ContentData -> List Html
viewElements elements =
  elements
  |> List.filter (\c -> state c /= Hidden)
  |> List.map viewElement


viewElement : ContentData -> Html
viewElement content =
  case content of
    Container _ render items ->
      render (viewElements items)
    Item _ html ->
      html
