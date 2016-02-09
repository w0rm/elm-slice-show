module SliceShow.Actions (Action(..)) where


type Action
  = Next
  | Prev
  | Goto Int
  | Open String
  | Resize (Int, Int)
  | Index
  | Noop
