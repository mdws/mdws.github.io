module Components.SongDownload.Commands exposing (..)

import Http
import Json.Decode exposing (Decoder, field, string, int, nullable)
import Json.Decode.Pipeline exposing (decode, required)

import Components.SongDownload.Models exposing (SongDownload, SongData)
import Components.SongDownload.Messages exposing (Msg(..))

apiUrl : String
apiUrl = "https://mdws.herokuapp.com/api/v1"

dataDecoder : Decoder SongData
dataDecoder =
  decode SongData
    |> required "title" string
    |> required "user" string
    |> required "artwork" (nullable string)
    |> required "duration" int
    |> required "data" string

fetchInfo : SongDownload -> Cmd Msg
fetchInfo song =
  let
    url =
      apiUrl
        ++ "/info/"
        ++ String.toLower (toString song.kind)
        ++ "?url=" ++ song.url
  in
    Http.get url dataDecoder
      |> Http.send InfoFetched

getDownloadLocation : SongDownload -> Cmd Msg
getDownloadLocation song =
  let
    url =
      apiUrl
        ++ "/download/"
        ++ String.toLower (toString song.kind)

    body =
      song.data
        |> Maybe.map .payload
        |> Maybe.withDefault ""
        |> Http.stringBody "application/json"
  in
    (field "location" string)
      |> Http.post url body
      |> Http.send DownloadComplete
