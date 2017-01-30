import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import SongDownload.Commands
import SongDownload.Messages
import SongDownload.Models as SongDownload
import SongDownload.Update
import SongDownload.Utils
import SongDownload.View

main : Program Never Model Msg
main =
  Html.program
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }

-- MODEL

type alias Model =
  { url : String
  , songs : List SongDownload.SongDownload
  , error : Maybe String
  }

init : (Model, Cmd Msg)
init =
  let
    model =
      { url = ""
      , songs = []
      , error = Nothing
      }
  in
    (model, Cmd.none)

-- UPDATE

type Msg
  = NewDownload
  | UpdateUrl String
  | SongDownloadMsg SongDownload.SongDownload SongDownload.Messages.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UpdateUrl newUrl ->
      ({ model | url = newUrl }, Cmd.none)

    NewDownload ->
      let
        resultKind =
          SongDownload.Utils.getKind model.url

        (newModel, subCmd) =
          case resultKind of
            Ok kind ->
              let
                song =
                  SongDownload.new (List.length model.songs) model.url kind

                newModel =
                  { url = ""
                  , songs = song :: model.songs
                  , error = Nothing
                  }
              in
                ( newModel
                , Cmd.map (SongDownloadMsg song) (SongDownload.Commands.download song)
                )

            Err error ->
              ({ model | error = Just error }, Cmd.none)
      in
        (newModel, subCmd)

    SongDownloadMsg songModel songMsg ->
      let
        (newSong, songCmd) =
          SongDownload.Update.update songMsg songModel
        newSongs =
          List.map
            (\song ->
              if song.id == newSong.id then
                newSong
              else
                song
            ) <| model.songs
      in
        ( { model | songs = newSongs }
        , Cmd.map (SongDownloadMsg newSong) songCmd
        )

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ Html.form [ onSubmit NewDownload ]
        [ input [ type_ "text", value model.url, onInput UpdateUrl ] []
        , button [ type_ "submit" ] [ text "Download" ]
        ]
    , songList model.songs
    , p [] [ text (toString model) ]
    ]

songList : List SongDownload.SongDownload -> Html Msg
songList songs =
  songs
    |> List.map
        (\song ->
          Html.map (SongDownloadMsg song) (SongDownload.View.view song)
        )
    |> ul []

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
