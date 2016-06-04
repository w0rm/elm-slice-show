module SliceShow.Actions exposing (Action(..))

import Window


type Action b
  = Next
  | Prev
  | Goto Int
  | Open String
  | Resize Window.Size
  | Index
  | Noop
  | Custom b
