port module Update exposing (..)

import Basics.Extra exposing (flip)
import Http exposing (Error(..))
import Json.Decode as Decode
import List as L
import List.Extra as LE
import Model exposing (Cell, Grid, GridConfig, GridPos, Model)
import Msg exposing (Msg(..))
import Prelude exposing (iff)
import Time



-- ---------------------------
-- PORTS
-- ---------------------------


port toJs : String -> Cmd msg



-- ---------------------------
-- INIT
-- ---------------------------


initGridConfig : GridConfig
initGridConfig =
    { h = 20
    , w = 20
    }


initCell : Cell
initCell =
    { idx = 0, pos = ( 0, 0 ), isAlive = True }


initGrid : GridConfig -> Grid
initGrid ({ h, w } as gridConfig) =
    let
        numCells =
            h * w

        setPos idx cell =
            { cell
                | pos = getGridPos idx gridConfig
                , idx = idx
                , isAlive = isInitAlive idx
            }
    in
    L.repeat numCells initCell
        |> L.indexedMap setPos


isInitAlive idx =
    L.member idx [ 1, 2, 3, 33, 34, 35, 88, 89, 90 ]


getGridPos : Int -> GridConfig -> GridPos
getGridPos idx { h, w } =
    ( idx // w, remainderBy w idx )


init : () -> ( Model, Cmd Msg )
init flags =
    let
        initModel =
            { serverMessage = ""
            , gridConfig = initGridConfig
            , grid = initGrid initGridConfig
            , year = 0
            , posix = Time.millisToPosix 0
            , startPosix = Time.millisToPosix 0
            }
    in
    ( initModel, Cmd.none )



-- ---------------------------
-- UPDATE
-- ---------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Tick posix ->
            let
                isStart =
                    Time.posixToMillis model.startPosix == 0
            in
            { model
                | posix = posix
                , startPosix = iff isStart posix model.startPosix
            }
                |> tick

        SetGridConfig cfg ->
            ( { model | gridConfig = cfg }, Cmd.none )

        SetFillState idx state ->
            model.grid
                |> LE.updateIf (\cell -> cell.idx == idx) (setIsAlive state)
                |> setGrid model
                |> addNone


addNone : Model -> ( Model, Cmd Msg )
addNone model =
    ( model, Cmd.none )


setIsAlive : Bool -> Cell -> Cell
setIsAlive state cell =
    { cell | isAlive = state }


setGrid : Model -> Grid -> Model
setGrid model grid =
    { model | grid = grid }


tick : Model -> ( Model, Cmd Msg )
tick model =
    { model | grid = L.map (followTheRules model.grid) model.grid } |> addNone


followTheRules : List Cell -> Cell -> Cell
followTheRules cells ({ isAlive } as cell) =
    let
        neighbors =
            findNeighbors cell cells
    in
    { cell | isAlive = rule3 cell neighbors }


findNeighbors : Cell -> List Cell -> List Cell
findNeighbors cell cells =
    let
        neighborPositions =
            getNeighborPositions cell
    in
    L.filter (\c -> L.member c.pos neighborPositions) cells


getNeighborPositions : Cell -> List GridPos
getNeighborPositions cell =
    let
        ( x, y ) =
            cell.pos

        up =
            ( x, y - 1 )

        down =
            ( x, y + 1 )

        left =
            ( x - 1, y )

        right =
            ( x + 1, y )

        leftDown =
            ( x - 1, y - 1 )

        rightDown =
            ( x + 1, y - 1 )

        leftUp =
            ( x - 1, y + 1 )

        rightUp =
            ( x + 1, y + 1 )
    in
    [ up, down, left, right, leftDown, rightDown, leftUp, rightUp ]


{-| Any live cell with two or three live neighbours survives.
-}
rule1 : List Cell -> Bool
rule1 neighbors =
    neighbors
        |> L.filter .isAlive
        |> L.length
        |> (\n -> n == 2 || n == 3)


{-| Any dead cell with three live neighbours becomes a live cell.
-}
rule2 : Cell -> List Cell -> Bool
rule2 { isAlive } neighbors =
    neighbors
        |> L.filter .isAlive
        |> L.length
        |> (>=) 3
        |> (&&) (not isAlive)


{-| All other live cells die in the next generation. Similarly, all other dead cells stay dead.
-}
rule3 : Cell -> List Cell -> Bool
rule3 cell neighbors =
    rule1 neighbors && rule2 cell neighbors
