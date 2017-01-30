module SongDownload.Messages exposing (..)

import Http

type Msg
  = Complete (Result Http.Error String)
