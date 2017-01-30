module SongDownload.Models exposing (..)

type alias SongDownload =
  { id : Int
  , url : String
  , kind : DownloadKind
  , completed : Bool
  , error : Maybe String
  }

type DownloadKind
  = SoundCloud
  | Bandcamp
  | YouTube

new : Int -> String -> DownloadKind -> SongDownload
new id url kind =
  { id = id
  , url = url
  , kind = kind
  , completed = False
  , error = Nothing
  }
