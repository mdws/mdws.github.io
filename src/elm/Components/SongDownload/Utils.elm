module Components.SongDownload.Utils exposing (..)

import Erl
import Components.SongDownload.Models exposing (DownloadKind(..))

getKind : String -> Result String DownloadKind
getKind url =
  let
    host =
      Erl.extractHost url
  in
    if isSoundCloud host then
      Ok SoundCloud
    else if isBandcamp host then
      Ok Bandcamp
    else if isYouTube host then
      Ok YouTube
    else
      Err "Unknown Service"

isSoundCloud : String -> Bool
isSoundCloud = String.endsWith "soundcloud.com"

isBandcamp : String -> Bool
isBandcamp = String.endsWith "bandcamp.com"

isYouTube : String -> Bool
isYouTube host =
  String.endsWith "youtube.com" host || String.endsWith "youtu.be" host
