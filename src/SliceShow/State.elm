module SliceShow.State (State(..), activate) where


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
