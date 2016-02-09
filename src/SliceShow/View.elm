module SliceShow.View (view) where

import Html exposing (Html, div, text)
import SliceShow.Actions exposing (Action)
import SliceShow.Model exposing (Model)
import SliceShow.Slide exposing (Slide)
import SliceShow.SlideData exposing (unlock)


view : Signal.Address Action -> Model -> Html
view address model =
  case model.currentSlide of
    Nothing -> viewListing address model
    Just index ->
      case List.head (List.drop index model.slides) of
        Nothing -> viewListing address model
        Just slide -> viewSlide address slide


viewListing : Signal.Address Action -> Model -> Html
viewListing address model =
  div [] (List.map (viewSlide address) model.slides)


viewSlide : Signal.Address Action -> Slide -> Html
viewSlide address slide =
  div [] [text (unlock slide).name]
