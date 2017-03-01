module Components.SongDownload exposing
  ( fetch
  , new
  , Model
  , Msg
  , update
  , view
  )

import Html exposing (Html)

import Components.SongDownload.Commands as Commands
import Components.SongDownload.Messages as Messages
import Components.SongDownload.Models exposing (SongDownload, DownloadKind, DownloadStatus(..))
import Components.SongDownload.Update as Update
import Components.SongDownload.Utils exposing (getKind)
import Components.SongDownload.View as View

-- MODEL

type alias Model = SongDownload

new : Int -> String -> Result String Model
new id url =
  getKind url
    |> Result.map (newWithKind id url)

newWithKind : Int -> String -> DownloadKind -> Model
newWithKind id url kind =
  { id = id
  , url = url
  , kind = kind
  , status = FetchingInfo
  , data = Nothing
  }

-- UPDATE

type alias Msg = Messages.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update = Update.update

-- VIEW

view : Model -> Html Msg
view = View.view

-- COMMANDS

fetch : Model -> Cmd Msg
fetch = Commands.fetchInfo
