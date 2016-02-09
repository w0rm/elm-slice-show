module SliceShow.Actions (Action(..)) where


type Action
  = Next
  | Prev
  | Goto String
  | Index
  | Noop
