module Main exposing (main)

import Browser
import Model exposing (Model)
import Msg exposing (Msg(..))
import Update exposing (init, update)
import View exposing (view)



-- ---------------------------
-- MAIN
-- ---------------------------


main : Program Int Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view =
            \m ->
                { title = "Elm 0.19 starter"
                , body = [ view m ]
                }
        , subscriptions = \_ -> Sub.none
        }
