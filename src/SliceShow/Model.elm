module SliceShow.Model (Model, init, next, prev, hash, open) where

import SliceShow.SlideData exposing (SlideData)
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
next = offset 1


prev : Model -> Model
prev = offset -1


hash : Model -> String
hash model =
  case model.currentSlide of
    Nothing -> "#"
    Just index -> "#" ++ toString (index + 1)


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
