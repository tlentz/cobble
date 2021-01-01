port module Update exposing (..)

import Grid exposing (GridConfig)
import Http exposing (Error(..))
import Json.Decode as Decode
import Model exposing (Model)
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
    { h = 100, w = 100 }


init : () -> ( Model, Cmd Msg )
init flags =
    let
        initModel =
            { serverMessage = ""
            , gridConfig = initGridConfig
            , grid = Grid.init initGridConfig
            }
    in
    ( initModel, Cmd.none )



-- ---------------------------
-- UPDATE
-- ---------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    ( model, Cmd.none )
