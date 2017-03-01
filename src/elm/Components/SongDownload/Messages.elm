module Components.SongDownload.Messages exposing (..)

import Http

import Components.SongDownload.Models exposing (SongData)

type Msg
  = InfoFetched (Result Http.Error SongData)
  | DownloadComplete (Result Http.Error String)
