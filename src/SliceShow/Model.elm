module SliceShow.Model (Model, init, next, prev, hash, goto) where

import SliceShow.Slide exposing (Slide)
import Result
import String


type alias Model =
  { currentSlide : Maybe Int
  , slides : List Slide
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


goto : String -> Model -> Model
goto hash model =
  case String.toInt (String.dropLeft 1 hash) of
    Ok int ->
      if int > 0 && int <= List.length model.slides then
        {model | currentSlide = Just (int - 1)}
      else
        model
    Err _ ->
      model


init : List Slide -> Model
init slides =
  { currentSlide = Nothing
  , slides = slides
  }
