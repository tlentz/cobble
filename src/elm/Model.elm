module Model exposing (..)

import Time exposing (Posix)


type alias Model =
    { serverMessage : String
    , gridConfig : GridConfig
    , grid : Grid
    , year : Int
    , posix : Posix
    , startPosix : Posix
    }


type alias Grid =
    List Cell


type alias GridConfig =
    { h : Int -- min/max 1/50
    , w : Int -- min/max 1/50
    }


type alias Cell =
    { idx : Int
    , pos : GridPos
    , isAlive : Bool
    }


type alias GridPos =
    -- ( x , y )
    ( Int, Int )
