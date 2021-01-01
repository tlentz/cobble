module View exposing (..)

import Arithmetic exposing (isEven)
import Html exposing (Html, div)
import Html.Attributes exposing (class, classList, height, id, style, width)
import Html.Events exposing (onClick)
import Html.Keyed
import List as L
import Model exposing (Cell, Grid, GridConfig, Model)
import Msg exposing (Msg(..))



-- ---------------------------
-- VIEW
-- ---------------------------


view : Model -> Html Msg
view model =
    div [ class "container" ] [ gridView model.gridConfig model.grid ]


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


cellSize =
    25


borderSize =
    2


viewCell : Cell -> ( String, Html Msg )
viewCell { idx, isFilled, pos } =
    let
        cellId =
            "cell-" ++ String.fromInt idx
    in
    ( cellId
    , div
        [ classList
            [ ( "cell", True )
            , ( "is-filled", isFilled )
            ]
        , height 25
        , width 25
        , id cellId
        , onClick (SetFillState idx (not isFilled))
        ]
        []
    )
