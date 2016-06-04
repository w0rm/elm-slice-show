module SliceShow.State exposing (State(..), activate)


type State
  = Inactive
  | Hidden
  | Active
  | Visited


activate : State -> State
activate state =
  case state of
    Hidden -> Active
    Active -> Visited
    Inactive -> Inactive
    Visited -> Visited
