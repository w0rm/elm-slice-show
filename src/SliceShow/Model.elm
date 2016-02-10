module SliceShow.Model (Model, init, next, prev, hash, open, currentSlide) where

import SliceShow.SlideData exposing (SlideData, showNextElement, hasHiddenElements)
import Result
import String


type alias Model =
  { currentSlide : Maybe Int
  , slides : List SlideData
  , dimensions : (Int, Int)
  }


offset : Int -> Model -> Model
offset offset model =
  case model.currentSlide of
    Nothing ->
      {model | currentSlide = Just 0}
    Just index ->
      {model | currentSlide = Just ((index + offset) % List.length model.slides)}


next : Model -> Model
next model =
  case currentSlide model of
    Just slide ->
      if hasHiddenElements slide then
        replaceCurrent (showNextElement slide) model
      else
        offset 1 model
    Nothing ->
      offset 1 model


prev : Model -> Model
prev = offset -1


hash : Model -> String
hash model =
  case model.currentSlide of
    Nothing -> "#"
    Just index -> "#" ++ toString (index + 1)


currentSlide : Model -> Maybe SlideData
currentSlide {slides, currentSlide} =
  Maybe.map ((flip List.drop) slides) currentSlide `Maybe.andThen` List.head


replaceCurrent : SlideData -> Model -> Model
replaceCurrent slide model =
  let
    replaceWith atIndex currentIndex currentSlide =
      if atIndex == currentIndex then
        slide
      else
        currentSlide
  in
    case model.currentSlide of
      Just index ->
        {model | slides = List.indexedMap (replaceWith index) model.slides}
      Nothing ->
        model


open : String -> Model -> Model
open hash model =
  case String.toInt (String.dropLeft 1 hash) of
    Ok int ->
      if int > 0 && int <= List.length model.slides then
        {model | currentSlide = Just (int - 1)}
      else
        {model | currentSlide = Nothing}
    Err _ ->
      {model | currentSlide = Nothing}


init : List SlideData -> Model
init slides =
  { currentSlide = Nothing
  , slides = slides
  , dimensions = (0, 0)
  }
