module SliceShow.Actions (Action(..)) where


type Action b
  = Next
  | Prev
  | Goto Int
  | Open String
  | Resize (Int, Int)
  | Index
  | Noop
  | Custom b
