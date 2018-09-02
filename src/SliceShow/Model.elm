module SliceShow.Model exposing
    ( Model
    , currentSlide
    , hash
    , init
    , next
    , open
    , prev
    , resize
    , subscriptions
    , update
    )

import Browser.Navigation exposing (Key)
import Result
import SliceShow.SlideData as Slide exposing (SlideData)
import String


type alias Model a b =
    { currentSlide : Maybe Int
    , slides : List (SlideData a b)
    , width : Int
    , height : Int
    , key : Key
    }


offset : Int -> Model a b -> Model a b
offset offset_ model =
    case model.currentSlide of
        Nothing ->
            { model | currentSlide = Just 0 }

        Just index ->
            { model
                | currentSlide =
                    index
                        + offset_
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
            "#" ++ String.fromInt (index + 1)


currentSlide : Model a b -> Maybe (SlideData a b)
currentSlide m =
    m.currentSlide
        |> Maybe.map (\currentSlide_ -> List.drop currentSlide_ m.slides)
        |> Maybe.andThen List.head


replaceCurrent : SlideData a b -> Model a b -> Model a b
replaceCurrent slide model =
    let
        replaceWith atIndex currentIndex currentSlide_ =
            if atIndex == currentIndex then
                slide

            else
                currentSlide_
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


open : Maybe String -> Model a b -> Model a b
open maybeFragment model =
    case Maybe.andThen String.toInt maybeFragment of
        Just int ->
            if int > 0 && int <= List.length model.slides then
                { model | currentSlide = Just (int - 1) }

            else
                { model | currentSlide = Nothing }

        Nothing ->
            { model | currentSlide = Nothing }


resize : Int -> Int -> Model a b -> Model a b
resize width height model =
    { model | width = width, height = height }


init : List (SlideData a b) -> Key -> Model a b
init slides key =
    { currentSlide = Nothing
    , slides = slides
    , width = 0
    , height = 0
    , key = key
    }
