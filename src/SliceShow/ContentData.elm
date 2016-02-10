module SliceShow.ContentData (ContentData(..), state, hasHidden, showNext) where

import Html exposing (Html, Attribute)
import SliceShow.State exposing (State(Inactive, Hidden, Active, Visited))


type ContentData
  = Container State (List Html -> Html) (List ContentData)
  | Item State Html


state : ContentData -> State
state element =
  case element of
    Container state render _ -> state
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
        Container state render items ->
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
        Container state render items ->
          case state of
            Hidden ->
              Container Active render items :: rest
            _ ->
              if hasHidden items then
                Container (visited state) render (showNext items) :: rest
              else
                Container (visited state) render items :: showNext rest
    [] -> []
