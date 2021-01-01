module Model exposing (..)

import Grid exposing (Grid, GridConfig)



-- ---------------------------
-- MODEL
-- ---------------------------


type alias Model =
    { serverMessage : String
    , gridConfig : GridConfig
    , grid : Grid
    }
