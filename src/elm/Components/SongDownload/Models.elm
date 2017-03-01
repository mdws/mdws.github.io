module Components.SongDownload.Models exposing (..)

import Http

type alias SongDownload =
  { id : Int
  , url : String
  , kind : DownloadKind
  , status : DownloadStatus
  , data : Maybe SongData
  }

type alias SongData =
  { title : String
  , user : String
  , artwork : Maybe String
  , duration : Int
  , payload : String
  }

type DownloadKind
  = SoundCloud
  | Bandcamp
  | YouTube

type DownloadStatus
  = FetchingInfo
  | Downloading
  | Completed
  | Errored Http.Error
