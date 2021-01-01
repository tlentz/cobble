module Msg exposing (Msg(..))

import Model exposing (GridConfig)
import Time


type Msg
    = Tick Time.Posix
    | SetWidth (Maybe Int)
    | SetHeight (Maybe Int)
    | Play
    | Pause
    | Restart
    | SetGrid
    | SetFillState Int Bool -- idx, state
