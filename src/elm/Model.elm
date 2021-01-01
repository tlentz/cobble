module Model exposing (..)


type alias Model =
    { serverMessage : String
    , gridConfig : GridConfig
    , grid : Grid
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
    , isFilled : Bool
    }


type alias GridPos =
    -- ( x , y )
    ( Int, Int )
