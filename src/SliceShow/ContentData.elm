module SliceShow.ContentData exposing (ContentData(..), hasHidden, next, state, subscriptions, update)

import Html exposing (Attribute, Html)
import SliceShow.Messages as Messages exposing (Message)
import SliceShow.State exposing (State(..))


type ContentData a b
    = Container State (List (Html (Messages.Message b)) -> Html (Messages.Message b)) (List (ContentData a b))
    | Item State (Html Never)
    | Custom State a
    | Prev (List (Attribute Never)) (List (Html Never))
    | Next (List (Attribute Never)) (List (Html Never))


state : ContentData a b -> State
state element =
    case element of
        Container state_ _ _ ->
            state_

        Item state_ _ ->
            state_

        Custom state_ _ ->
            state_

        Prev _ _ ->
            Active

        Next _ _ ->
            Active


hasHidden : List (ContentData a b) -> Bool
hasHidden elements =
    case elements of
        [] ->
            False

        (Item state_ _) :: rest ->
            case state_ of
                Hidden ->
                    True

                _ ->
                    hasHidden rest

        (Custom state_ _) :: rest ->
            case state_ of
                Hidden ->
                    True

                _ ->
                    hasHidden rest

        (Container state_ render items) :: rest ->
            case state_ of
                Hidden ->
                    True

                _ ->
                    hasHidden items || hasHidden rest

        (Prev _ _) :: rest ->
            hasHidden rest

        (Next _ _) :: rest ->
            hasHidden rest


visited : State -> State
visited state_ =
    case state_ of
        Active ->
            Visited

        _ ->
            state_


next : List (ContentData a b) -> List (ContentData a b)
next elements =
    case elements of
        [] ->
            []

        (Item state_ html) :: rest ->
            case state_ of
                Hidden ->
                    Item Active html :: rest

                _ ->
                    Item (visited state_) html :: next rest

        (Custom state_ data) :: rest ->
            case state_ of
                Hidden ->
                    Custom Active data :: rest

                _ ->
                    Custom (visited state_) data :: next rest

        (Container state_ render items) :: rest ->
            case state_ of
                Hidden ->
                    Container Active render items :: rest

                _ ->
                    if hasHidden items then
                        Container (visited state_) render (next items) :: rest

                    else
                        Container (visited state_) render items :: next rest

        (Prev attributes html) :: rest ->
            Prev attributes html :: next rest

        (Next attributes html) :: rest ->
            Next attributes html :: next rest


subscriptions : (a -> Sub b) -> List (ContentData a b) -> List (Sub b)
subscriptions customSubscription elements =
    case elements of
        [] ->
            []

        (Custom state_ data) :: rest ->
            if state_ /= Hidden then
                customSubscription data :: subscriptions customSubscription rest

            else
                subscriptions customSubscription rest

        (Container state_ render items) :: rest ->
            if state_ /= Hidden then
                subscriptions customSubscription items ++ subscriptions customSubscription rest

            else
                subscriptions customSubscription rest

        _ :: rest ->
            subscriptions customSubscription rest


update : (b -> a -> ( a, Cmd b )) -> b -> List (ContentData a b) -> ( List (ContentData a b), List (Cmd b) )
update updateCustom action elements =
    case elements of
        [] ->
            ( [], [] )

        (Custom state_ data) :: rest ->
            if state_ /= Hidden then
                let
                    ( updatedSelf, selfEffect ) =
                        updateCustom action data

                    ( updatedSiblings, siblingsCmd ) =
                        update updateCustom action rest
                in
                if selfEffect == Cmd.none then
                    ( Custom state_ updatedSelf :: updatedSiblings, siblingsCmd )

                else
                    ( Custom state_ updatedSelf :: updatedSiblings, selfEffect :: siblingsCmd )

            else
                let
                    ( updatedSiblings, siblingsCmd ) =
                        update updateCustom action rest
                in
                ( Custom state_ data :: updatedSiblings, siblingsCmd )

        (Container state_ render items) :: rest ->
            let
                ( updatedChildren, childrenCmd ) =
                    update updateCustom action items

                ( updatedSiblings, siblingsCmd ) =
                    update updateCustom action rest
            in
            ( Container state_ render updatedChildren :: updatedSiblings, childrenCmd ++ siblingsCmd )

        (Item state_ html) :: rest ->
            let
                ( updatedSiblings, siblingsCmd ) =
                    update updateCustom action rest
            in
            ( Item state_ html :: updatedSiblings, siblingsCmd )

        (Prev attributes html) :: rest ->
            let
                ( updatedSiblings, siblingsCmd ) =
                    update updateCustom action rest
            in
            ( Prev attributes html :: updatedSiblings, siblingsCmd )

        (Next attributes html) :: rest ->
            let
                ( updatedSiblings, siblingsCmd ) =
                    update updateCustom action rest
            in
            ( Next attributes html :: updatedSiblings, siblingsCmd )
