module SliceShow.Model (Model, init, next, prev, hash, open, update, currentSlide, resize) where

import SliceShow.SlideData exposing (SlideData, showNextElement, updateCustomElement, hasHiddenElements)
import Result
import String
import Effects exposing (Effects)


type alias Model a =
  { currentSlide : Maybe Int
  , slides : List (SlideData a)
  , dimensions : (Int, Int)
  }


offset : Int -> Model a -> Model a
offset offset model =
  case model.currentSlide of
    Nothing ->
      { model | currentSlide = Just 0 }
    Just index ->
      { model
      | currentSlide =
          Just (index + offset |> max 0 |> min (List.length model.slides - 1))
      }


next : Model a -> Model a
next model =
  case currentSlide model of
    Just slide ->
      if hasHiddenElements slide then
        replaceCurrent (showNextElement slide) model
      else
        offset 1 model
    Nothing ->
      offset 1 model


prev : Model a -> Model a
prev = offset -1


hash : Model a -> String
hash model =
  case model.currentSlide of
    Nothing -> "#"
    Just index -> "#" ++ toString (index + 1)


currentSlide : Model a -> Maybe (SlideData a)
currentSlide {slides, currentSlide} =
  Maybe.map ((flip List.drop) slides) currentSlide `Maybe.andThen` List.head


replaceCurrent : SlideData a -> Model a -> Model a
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


update : (b -> a -> (a, Effects b)) -> b -> Model a -> (Model a, Effects b)
update updateCustom customAction model =
  case currentSlide model of
    Just slide ->
      let
        (newSlide, effects) = updateCustomElement updateCustom customAction slide
      in
        (replaceCurrent newSlide model, effects)
    Nothing ->
      (model, Effects.none)


open : String -> Model a -> Model a
open hash model =
  case String.toInt (String.dropLeft 1 hash) of
    Ok int ->
      if int > 0 && int <= List.length model.slides then
        {model | currentSlide = Just (int - 1)}
      else
        {model | currentSlide = Nothing}
    Err _ ->
      {model | currentSlide = Nothing}


resize : (Int, Int) -> Model a -> Model a
resize dimensions model =
  {model | dimensions = dimensions}


init : List (SlideData a) -> Model a
init slides =
  { currentSlide = Nothing
  , slides = slides
  , dimensions = (0, 0)
  }
