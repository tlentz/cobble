module View exposing (view)

import Color exposing (Color)
import Constants exposing (timeInterval)
import Html exposing (Html, button, div, input, text)
import Html.Attributes as Attrs exposing (class, classList, height, id, max, min, placeholder, style, type_, width)
import Html.Events exposing (onClick, onInput)
import Html.Keyed
import List as L
import Material.Icons exposing (cached, pause, play_arrow)
import Material.Icons.Types exposing (Coloring(..))
import Model exposing (Cell, Grid, GridConfig, Model)
import Msg exposing (Msg(..))
import Time



-- ---------------------------
-- VIEW
-- ---------------------------


view : Model -> Html Msg
view model =
    div [ class "container", style "max-width" (String.fromInt (model.gridConfig.w * 27) ++ "px"), style "max-height" (String.fromInt (model.gridConfig.h * 27) ++ "px") ]
        [ div [ class "header" ]
            [ configInputs model
            , displayTime model
            , timeInputs
            ]
        , gridView model.gridConfig model.grid
        ]


configInputs : Model -> Html Msg
configInputs { width, height } =
    div [ class "config-container" ]
        [ input [ type_ "number", Attrs.min "20", Attrs.max "50", placeholder "20", onInput (SetWidth << String.toInt) ] []
        , input [ type_ "number", Attrs.min "20", Attrs.max "50", placeholder "20", onInput (SetHeight << String.toInt) ] []
        , button [ onClick SetGrid ] [ text "Set Grid" ]
        ]


timeInputs : Html Msg
timeInputs =
    div [ class "inputs-container" ]
        [ button [ onClick Play ] [ play_arrow 24 (Color Color.green) ]
        , button [ onClick Pause ] [ pause 24 (Color Color.red) ]
        , button [ onClick Restart ] [ cached 24 (Color Color.blue) ]
        ]


displayTime : Model -> Html Msg
displayTime { posix, startPosix } =
    let
        elapsedTime =
            (Time.posixToMillis posix - Time.posixToMillis startPosix) // round timeInterval
    in
    div [ class "time-container" ] [ text <| "Generations: " ++ String.fromInt elapsedTime ]


px : Int -> String
px n =
    String.fromInt n ++ "px"


gridView : GridConfig -> Grid -> Html Msg
gridView { h, w } cells =
    cells
        |> L.map viewCell
        |> Html.Keyed.node "div"
            [ class "grid-container"
            , style "height" (px (h * (cellSize + borderSize)))
            , style "width" (px (w * (cellSize + borderSize)))
            ]


cellSize : Int
cellSize =
    25


borderSize : Int
borderSize =
    2


viewCell : Cell -> ( String, Html Msg )
viewCell { idx, isAlive } =
    let
        cellId =
            "cell-" ++ String.fromInt idx
    in
    ( cellId
    , div
        [ classList
            [ ( "cell", True )
            , ( "is-filled", isAlive )
            ]
        , height 25
        , width 25
        , id cellId
        , onClick (SetFillState idx (not isAlive))
        ]
        []
    )
