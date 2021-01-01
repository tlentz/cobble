module Msg exposing (..)

import Model exposing (GridConfig, GridPos, Model)


type Msg
    = SetGridConfig GridConfig
    | SetFillState Int Bool -- idx, state
