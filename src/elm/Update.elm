port module Update exposing (..)

import Http exposing (Error(..))
import Json.Decode as Decode
import List as L
import List.Extra as LE
import Model exposing (Cell, Grid, GridConfig, GridPos, Model)
import Msg exposing (Msg(..))



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
    { idx = 0, pos = ( 0, 0 ), isFilled = False }


initGrid : GridConfig -> Grid
initGrid ({ h, w } as gridConfig) =
    let
        numCells =
            h * w

        setPos idx cell =
            { cell | pos = getGridPos idx gridConfig, idx = idx }
    in
    L.repeat numCells initCell
        |> L.indexedMap setPos


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
            }
    in
    ( initModel, Cmd.none )



-- ---------------------------
-- UPDATE
-- ---------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        SetGridConfig cfg ->
            ( { model | gridConfig = cfg }, Cmd.none )

        SetFillState idx state ->
            model.grid
                |> LE.updateIf (\cell -> cell.idx == idx) (setFillState state)
                |> setGrid model
                |> addNone


addNone : Model -> ( Model, Cmd Msg )
addNone model =
    ( model, Cmd.none )


setFillState : Bool -> Cell -> Cell
setFillState state cell =
    { cell | isFilled = state }


setGrid : Model -> Grid -> Model
setGrid model grid =
    { model | grid = grid }
