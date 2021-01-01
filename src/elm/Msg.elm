module Msg exposing (..)

import Model exposing (GridConfig, GridPos, Model)
import Time


type Msg
    = Tick Time.Posix
    | SetGridConfig GridConfig
    | SetFillState Int Bool -- idx, state
