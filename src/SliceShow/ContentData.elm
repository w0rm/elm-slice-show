module SliceShow.ContentData (ContentData(..), state, hasHidden, showNext) where

import Html exposing (Html)
import SliceShow.State exposing (State(Inactive, Hidden, Active, Visited))


type ContentData
  = Listing State (List ContentData)
  | Item State Html


state : ContentData -> State
state element =
  case element of
    Listing state _ -> state
    Item state _ -> state


hasHidden : List ContentData -> Bool
hasHidden elements =
  case elements of
    element :: rest ->
      case element of
        Item state _ ->
          case state of
            Hidden -> True
            _ -> hasHidden rest
        Listing state items ->
          case state of
            Hidden -> True
            _ -> hasHidden items || hasHidden rest
    [] ->
      False


visited : State -> State
visited state =
  case state of
    Active -> Visited
    _ -> state


showNext : List ContentData -> List ContentData
showNext elements =
  case elements of
    element :: rest ->
      case element of
        Item state html ->
          case state of
            Hidden -> Item Active html :: rest
            _ -> Item (visited state) html :: showNext rest
        Listing state items ->
          case state of
            Hidden ->
              Listing Active items :: rest
            _ ->
              if hasHidden items then
                Listing (visited state) (showNext items) :: rest
              else
                Listing (visited state) items :: showNext rest
    [] -> []
