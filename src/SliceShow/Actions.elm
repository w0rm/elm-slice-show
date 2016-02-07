module SliceShow.Actions (Action(..)) where


type Action slideAction
  = Next
  | Prev
  | Slide Int slideAction
  | GoTo Int
  | NoOp
