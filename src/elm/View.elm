module View exposing (..)

import Html exposing (Html, a, button, div, h1, header, img, p, span, text)
import Html.Attributes exposing (class, href, src)
import Html.Events exposing (onClick)
import Model exposing (Model)
import Msg exposing (Msg(..))



-- ---------------------------
-- VIEW
-- ---------------------------


view : Model -> Html Msg
view model =
    div [ class "container" ] []
