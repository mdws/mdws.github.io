module SongDownload.Commands exposing (..)

import Http
import Json.Decode exposing (field, string)
import SongDownload.Messages exposing (Msg(..))
import SongDownload.Models exposing (SongDownload)

download : SongDownload -> Cmd Msg
download song =
  let
    baseUrl =
      "https://mdws.herokuapp.com/api/v1/services/"

    url =
      baseUrl ++ String.toLower (toString song.kind) ++ "?url=" ++ song.url
  in
    Http.send Complete (Http.get url (field "location" string))
