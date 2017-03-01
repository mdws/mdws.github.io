module Components.SongDownload.View exposing (..)

import Html exposing (..)

import Components.SongDownload.Models exposing (SongDownload)
import Components.SongDownload.Messages exposing (Msg)

view : SongDownload -> Html Msg
view song =
  div []
    [ p [] [ text (toString song) ]
    ]
