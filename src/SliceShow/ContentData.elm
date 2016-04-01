module SliceShow.ContentData (ContentData(..), state, update, hasHidden, showNext) where

import Html exposing (Html, Attribute)
import SliceShow.State exposing (State(Inactive, Hidden, Active, Visited))
import Effects exposing (Effects)


type ContentData a
  = Container State (List Html -> Html) (List (ContentData a))
  | Item State Html
  | Custom State a


state : ContentData a -> State
state element =
  case element of
    Container state _ _ -> state
    Item state _ -> state
    Custom state _ -> state


hasHidden : List (ContentData a) -> Bool
hasHidden elements =
  case elements of
    [] ->
      False
    Item state _ :: rest ->
      case state of
        Hidden -> True
        _ -> hasHidden rest
    Custom state _ :: rest ->
      case state of
        Hidden -> True
        _ -> hasHidden rest
    Container state render items :: rest ->
      case state of
        Hidden -> True
        _ -> hasHidden items || hasHidden rest


visited : State -> State
visited state =
  case state of
    Active -> Visited
    _ -> state


showNext : List (ContentData a) -> List (ContentData a)
showNext elements =
  case elements of
    [] -> []
    Item state html :: rest ->
      case state of
        Hidden -> Item Active html :: rest
        _ -> Item (visited state) html :: showNext rest
    Custom state data :: rest ->
      case state of
        Hidden -> Custom Active data :: rest
        _ -> Custom (visited state) data :: showNext rest
    Container state render items :: rest ->
      case state of
        Hidden ->
          Container Active render items :: rest
        _ ->
          if hasHidden items then
            Container (visited state) render (showNext items) :: rest
          else
            Container (visited state) render items :: showNext rest


update : (b -> a -> (a, Effects b)) -> b -> List (ContentData a) -> (List (ContentData a), List (Effects b))
update updateCustom action elements =
  case elements of
    [] -> ([], [])
    Custom state data :: rest ->
      if state /= Hidden then
        let
          (updatedSelf, selfEffect) = updateCustom action data
          (updatedSiblings, siblingsEffects) = update updateCustom action rest
        in
          if selfEffect == Effects.none then
            (Custom state updatedSelf :: updatedSiblings, siblingsEffects)
          else
            (Custom state updatedSelf :: updatedSiblings, selfEffect :: siblingsEffects)
      else
        let
          (updatedSiblings, siblingsEffects) = update updateCustom action rest
        in
          (Custom state data :: updatedSiblings, siblingsEffects)
    Container state render items :: rest ->
      let
        (updatedChildren, childrenEffects) = update updateCustom action items
        (updatedSiblings, siblingsEffects) = update updateCustom action rest
      in
        (Container state render updatedChildren :: updatedSiblings, childrenEffects ++ siblingsEffects)
    Item state html :: rest ->
      let
        (updatedSiblings, siblingsEffects) = update updateCustom action rest
      in
        (Item state html :: updatedSiblings, siblingsEffects)
