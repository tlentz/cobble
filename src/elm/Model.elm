module Model exposing (Cell, Grid, GridConfig, GridPos, Model)

import Time exposing (Posix)


type alias Model =
    { serverMessage : String
    , gridConfig : GridConfig
    , grid : Grid
    , width : Maybe Int
    , height : Maybe Int
    , posix : Posix
    , startPosix : Posix
    , paused : Bool
    }


type alias Grid =
    List Cell


type alias GridConfig =
    { w : Int -- min/max 1/50
    , h : Int -- min/max 1/50
    }


type alias Cell =
    { idx : Int
    , pos : GridPos
    , isAlive : Bool
    }


type alias GridPos =
    -- ( x , y )
    ( Int, Int )
