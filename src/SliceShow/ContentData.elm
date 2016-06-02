module SliceShow.ContentData (ContentData(..), state, update, hasHidden, showNext) where

import Html exposing (Html, Attribute)
import SliceShow.State exposing (State(Inactive, Hidden, Active, Visited))


type ContentData a b
  = Container State (List (Html b) -> Html b) (List (ContentData a b))
  | Item State (Html b)
  | Custom State a


state : ContentData a b -> State
state element =
  case element of
    Container state _ _ -> state
    Item state _ -> state
    Custom state _ -> state


hasHidden : List (ContentData a b) -> Bool
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


showNext : List (ContentData a b) -> List (ContentData a b)
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


update : (b -> a -> (a, Cmd b)) -> b -> List (ContentData a b) -> (List (ContentData a b), List (Cmd b))
update updateCustom action elements =
  case elements of
    [] -> ([], [])
    Custom state data :: rest ->
      if state /= Hidden then
        let
          (updatedSelf, selfEffect) = updateCustom action data
          (updatedSiblings, siblingsCmd) = update updateCustom action rest
        in
          if selfEffect == Cmd.none then
            (Custom state updatedSelf :: updatedSiblings, siblingsCmd)
          else
            (Custom state updatedSelf :: updatedSiblings, selfEffect :: siblingsCmd)
      else
        let
          (updatedSiblings, siblingsCmd) = update updateCustom action rest
        in
          (Custom state data :: updatedSiblings, siblingsCmd)
    Container state render items :: rest ->
      let
        (updatedChildren, childrenCmd) = update updateCustom action items
        (updatedSiblings, siblingsCmd) = update updateCustom action rest
      in
        (Container state render updatedChildren :: updatedSiblings, childrenCmd ++ siblingsCmd)
    Item state html :: rest ->
      let
        (updatedSiblings, siblingsCmd) = update updateCustom action rest
      in
        (Item state html :: updatedSiblings, siblingsCmd)
