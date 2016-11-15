module SliceShow.Messages exposing (Message(..))

import Window


type Message b
    = Next
    | Prev
    | Goto Int
    | Open String
    | Resize Window.Size
    | Index
    | Noop
    | Custom b
