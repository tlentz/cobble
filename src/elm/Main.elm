module Main exposing (main)

import Browser
import Constants exposing (timeInterval)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Time
import Update exposing (init, update)
import View exposing (view)



-- ---------------------------
-- MAIN
-- ---------------------------


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view =
            \m ->
                { title = "Elm 0.19 starter"
                , body = [ view m ]
                }
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.paused then
        Sub.none

    else
        Time.every timeInterval Tick
