module SliceShow.SlideActions (Action(..)) where


type Action customAction
  = Open
  | Close
  | Next
  | Custom customAction
