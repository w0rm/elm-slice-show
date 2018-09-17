module SliceShow.Messages exposing (Message(..))


type Message b
    = Next
    | Prev
    | Goto Int
    | Open (Maybe String)
    | Resize Int Int
    | Index
    | Noop
    | Custom b
    | NavigateToInternalUrl String
    | NavigateToExternalUrl String
