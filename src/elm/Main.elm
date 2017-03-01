import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Components.SongDownload as SongDownload

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
  , songs : List SongDownload.Model
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
  = AddDownload
  | UpdateUrl String
  | SongDownloadMsg SongDownload.Model SongDownload.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UpdateUrl url ->
      ({ model | url = url }, Cmd.none)

    AddDownload ->
      model.url
        |> SongDownload.new (List.length model.songs)
        |> handleSongResult model

    SongDownloadMsg songModel songMsg ->
      let
        (newSong, songCmd) =
          SongDownload.update songMsg songModel

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

handleSongResult : Model -> Result String SongDownload.Model -> (Model, Cmd Msg)
handleSongResult model songResult =
  case songResult of
    Ok song ->
      let
        newModel =
          { url = ""
          , songs = song :: model.songs
          , error = Nothing
          }

        subCmd =
          song
            |> SongDownload.fetch
            |> Cmd.map (SongDownloadMsg song)
      in
        (newModel, subCmd)

    Err error ->
      ({ model | error = Just error }, Cmd.none)

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ Html.form [ onSubmit AddDownload ]
      [ input [ type_ "text", value model.url, onInput UpdateUrl ] []
      , button [ type_ "submit" ] [ text "Download" ]
      ]
    , songList model.songs
    , p [] [ text (toString model) ]
    ]

songList : List SongDownload.Model -> Html Msg
songList songs =
  songs
    |> List.map
        (\song ->
          Html.map
            (SongDownloadMsg song)
            (SongDownload.view song)
        )
    |> ul []

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
