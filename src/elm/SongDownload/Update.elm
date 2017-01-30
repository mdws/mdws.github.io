module SongDownload.Update exposing (..)

import Http exposing (Error(..))
import Ports exposing (downloadRedirect)

import SongDownload.Messages exposing (Msg(..))
import SongDownload.Models exposing (SongDownload)

update : Msg -> SongDownload -> (SongDownload, Cmd Msg)
update msg model =
  case msg of
    Complete result ->
      handleResult model result

handleResult : SongDownload -> Result Http.Error String -> (SongDownload, Cmd Msg)
handleResult model result =
  case result of
    Ok location ->
      ({ model | completed = True }, downloadRedirect location)

    Err error ->
      let
        newError =
          case error of
            _ ->
              -- TODO: Handle this correctly
              Just (toString error)

      in
        ({ model | error = newError, completed = True }, Cmd.none)
