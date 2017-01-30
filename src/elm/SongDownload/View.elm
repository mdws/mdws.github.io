module SongDownload.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import SongDownload.Messages exposing (Msg(..))
import SongDownload.Models exposing (SongDownload)

view : SongDownload -> Html Msg
view model =
  div [ class "song-download" ]
    [ p [] [ text (toString model) ]
    ]
