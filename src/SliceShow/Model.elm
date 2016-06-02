module SliceShow.Model (Model, init, next, prev, hash, open, update, currentSlide, resize) where

import SliceShow.SlideData exposing (SlideData, showNextElement, updateCustomElement, hasHiddenElements)
import Result
import String


type alias Model a b =
  { currentSlide : Maybe Int
  , slides : List (SlideData a b)
  , dimensions : (Int, Int)
  }


offset : Int -> Model a b -> Model a b
offset offset model =
  case model.currentSlide of
    Nothing ->
      { model | currentSlide = Just 0 }
    Just index ->
      { model
      | currentSlide =
          Just (index + offset |> max 0 |> min (List.length model.slides - 1))
      }


next : Model a b -> Model a b
next model =
  case currentSlide model of
    Just slide ->
      if hasHiddenElements slide then
        replaceCurrent (showNextElement slide) model
      else
        offset 1 model
    Nothing ->
      offset 1 model


prev : Model a b -> Model a b
prev = offset -1


hash : Model a b -> String
hash model =
  case model.currentSlide of
    Nothing -> "#"
    Just index -> "#" ++ toString (index + 1)


currentSlide : Model a b -> Maybe (SlideData a b)
currentSlide {slides, currentSlide} =
  Maybe.map ((flip List.drop) slides) currentSlide `Maybe.andThen` List.head


replaceCurrent : SlideData a b -> Model a b -> Model a b
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


update : (b -> a -> (a, Cmd b)) -> b -> Model a b -> (Model a b, Cmd b)
update updateCustom customAction model =
  case currentSlide model of
    Just slide ->
      let
        (newSlide, effects) = updateCustomElement updateCustom customAction slide
      in
        (replaceCurrent newSlide model, effects)
    Nothing ->
      (model, Cmd.none)


open : String -> Model a b -> Model a b
open hash model =
  case String.toInt (String.dropLeft 1 hash) of
    Ok int ->
      if int > 0 && int <= List.length model.slides then
        {model | currentSlide = Just (int - 1)}
      else
        {model | currentSlide = Nothing}
    Err _ ->
      {model | currentSlide = Nothing}


resize : (Int, Int) -> Model a b -> Model a b
resize dimensions model =
  {model | dimensions = dimensions}


init : List (SlideData a b) -> Model a b
init slides =
  { currentSlide = Nothing
  , slides = slides
  , dimensions = (0, 0)
  }
