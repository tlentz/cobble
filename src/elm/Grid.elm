module Grid exposing (..)

import Arithmetic exposing (isEven)
import Html exposing (Html, div)
import Html.Attributes exposing (class, classList, height, style, width)
import List as L


type alias Grid =
    List Cell


type alias GridConfig =
    { h : Int -- min/max 1/50
    , w : Int -- min/max 1/50
    }


type alias Cell =
    { pos : GridPos
    , isFilled : Bool
    }


type alias GridPos =
    -- ( x , y )
    ( Int, Int )


initCell : Cell
initCell =
    { pos = ( 0, 0 ), isFilled = False }


init : GridConfig -> Grid
init ({ h, w } as gridConfig) =
    let
        numCells =
            h * w

        setPos idx cell =
            { cell | pos = getGridPos idx gridConfig }
    in
    L.repeat numCells initCell
        |> L.indexedMap setPos


getGridPos : Int -> GridConfig -> GridPos
getGridPos idx { h, w } =
    ( idx // w, remainderBy w idx )


px n =
    String.fromInt n ++ "px"


view : GridConfig -> Grid -> Html msg
view { h, w } cells =
    cells
        |> L.map viewCell
        |> div
            [ class "grid-container"
            , style "height" (px (h * (cellSize + borderSize)))
            , style "width" (px (w * (cellSize + borderSize)))
            ]


cellSize =
    25


borderSize =
    2


viewCell : Cell -> Html msg
viewCell { isFilled, pos } =
    div
        [ classList
            [ ( "cell", True )
            , ( "is-filled", isEven <| Tuple.first pos )
            ]
        , height 25
        , width 25
        ]
        []
