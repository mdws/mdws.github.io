module Components.SongDownload.Update exposing (..)

import Navigation

import Components.SongDownload.Commands exposing (getDownloadLocation)
import Components.SongDownload.Messages exposing (Msg(..))
import Components.SongDownload.Models exposing (SongDownload, DownloadStatus(..))

update : Msg -> SongDownload -> (SongDownload, Cmd Msg)
update msg song =
  case msg of
    InfoFetched result ->
      case result of
        Ok info ->
          let
            newSong =
              { song
                | data = Just info
                , status = Downloading
              }
          in
            ( newSong
            , getDownloadLocation newSong
            )

        Err error ->
          ( { song | status = Errored error }
          , Cmd.none
          )

    DownloadComplete result ->
      case result of
        Ok location ->
          ( { song | status = Completed }
          , Navigation.load location
          )

        Err error ->
          ( { song | status = Errored error }
          , Cmd.none
          )
