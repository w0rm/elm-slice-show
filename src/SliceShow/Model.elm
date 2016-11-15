module SliceShow.Model
    exposing
        ( Model
        , init
        , next
        , prev
        , hash
        , open
        , update
        , currentSlide
        , resize
        , subscriptions
        )

import SliceShow.SlideData as Slide exposing (SlideData)
import Result
import String
import Window


type alias Model a b =
    { currentSlide : Maybe Int
    , slides : List (SlideData a b)
    , dimensions : Window.Size
    }


offset : Int -> Model a b -> Model a b
offset offset model =
    case model.currentSlide of
        Nothing ->
            { model | currentSlide = Just 0 }

        Just index ->
            { model
                | currentSlide =
                    index
                        + offset
                        |> clamp 0 (List.length model.slides - 1)
                        |> Just
            }


next : Model a b -> Model a b
next model =
    case currentSlide model of
        Just slide ->
            if Slide.hasHiddenElements slide then
                replaceCurrent (Slide.next slide) model
            else
                offset 1 model

        Nothing ->
            offset 1 model


prev : Model a b -> Model a b
prev =
    offset -1


hash : Model a b -> String
hash model =
    case model.currentSlide of
        Nothing ->
            "#"

        Just index ->
            "#" ++ toString (index + 1)


currentSlide : Model a b -> Maybe (SlideData a b)
currentSlide { slides, currentSlide } =
    Maybe.map ((flip List.drop) slides) currentSlide |> Maybe.andThen List.head


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
                { model | slides = List.indexedMap (replaceWith index) model.slides }

            Nothing ->
                model


update : (b -> a -> ( a, Cmd b )) -> b -> Model a b -> ( Model a b, Cmd b )
update updateCustom customAction model =
    case currentSlide model of
        Just slide ->
            let
                ( newSlide, cmd ) =
                    Slide.update updateCustom customAction slide
            in
                ( replaceCurrent newSlide model, cmd )

        Nothing ->
            ( model, Cmd.none )


subscriptions : (a -> Sub b) -> Model a b -> Sub b
subscriptions customSubscription model =
    case currentSlide model of
        Just slide ->
            Slide.subscriptions customSubscription slide

        Nothing ->
            Sub.none


open : String -> Model a b -> Model a b
open hash model =
    case String.toInt (String.dropLeft 1 hash) of
        Ok int ->
            if int > 0 && int <= List.length model.slides then
                { model | currentSlide = Just (int - 1) }
            else
                { model | currentSlide = Nothing }

        Err _ ->
            { model | currentSlide = Nothing }


resize : Window.Size -> Model a b -> Model a b
resize dimensions model =
    { model | dimensions = dimensions }


init : List (SlideData a b) -> Model a b
init slides =
    { currentSlide = Nothing
    , slides = slides
    , dimensions = Window.Size 0 0
    }
