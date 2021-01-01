port module Update exposing (init, update)

import Http exposing (Error(..))
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
                , isAlive = False
            }
    in
    L.repeat numCells initCell
        |> L.indexedMap setPos


getGridPos : Int -> GridConfig -> GridPos
getGridPos idx { w } =
    ( idx // w, remainderBy w idx )


init : () -> ( Model, Cmd Msg )
init flags =
    let
        initModel =
            { serverMessage = ""
            , gridConfig = initGridConfig
            , grid = initGrid initGridConfig
            , width = Nothing
            , height = Nothing
            , posix = Time.millisToPosix 0
            , startPosix = Time.millisToPosix 0
            , paused = True
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

        SetWidth width ->
            ( { model | width = width }, Cmd.none )

        SetHeight height ->
            ( { model | height = height }, Cmd.none )

        Play ->
            ( { model | paused = False }, Cmd.none )

        Pause ->
            ( { model | paused = True }, Cmd.none )

        Restart ->
            let
                updatedGridCfg =
                    { w = Maybe.withDefault 20 model.width, h = Maybe.withDefault 20 model.height }

                updatedModel =
                    { model
                        | paused = True
                        , gridConfig = updatedGridCfg
                        , grid = initGrid updatedGridCfg
                        , posix = Time.millisToPosix 0
                        , startPosix = Time.millisToPosix 0
                    }
            in
            ( updatedModel, Cmd.none )

        SetGrid ->
            let
                updatedWidth =
                    max 20 (min 50 (Maybe.withDefault 20 model.width))

                updatedHeight =
                    max 20 (min 50 (Maybe.withDefault 20 model.height))

                updatedGridCfg =
                    { w = updatedWidth, h = updatedHeight }

                updatedModel =
                    { model
                        | gridConfig = updatedGridCfg
                        , grid = initGrid updatedGridCfg
                        , width = Just updatedWidth
                        , height = Just updatedHeight
                    }
            in
            ( updatedModel, Cmd.none )

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
followTheRules cells cell =
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
