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
  div [ class "container" ]
    [ section [ class "hero is-medium" ]
      [ div [ class "hero-body" ]
        [ div [ class "container" ]
          [ h1 [ class "title has-text-centered" ] [ text "paste some track or playlist url" ]
          , formContainer model
          ]
        ]
      ]
    , hr [] []
    , section [ class "section" ]
      [ div [ class "container" ]
        [ div [ class "heading", style [("margin-bottom", "3rem")] ]
          [ h1 [ class "title is-4 has-text-centered" ] [ text "Downloads" ] ]
        , songList model.songs
        ]
      ]
    ]

formContainer : Model -> Html Msg
formContainer model =
  let
    (helperClass, helperText) =
      case model.error of
        Just error ->
          ("is-danger", error)

        Nothing ->
          ("", "Available services: YouTube, SoundCloud, Bandcamp")
  in
    div [ class "columns" ]
      [ div [ class "column is-half is-offset-one-quarter" ]
        [ Html.form [ class "control has-addons has-addons-centered", onSubmit AddDownload ]
          [ input
            [ class ("input " ++ helperClass)
            , style [("width", "70%")]
            , type_ "text"
            , value model.url
            , onInput UpdateUrl
            ] []
          , button [ class "button", type_ "submit" ]
            [ span [ class "icon" ] [ i [ class "fa fa-download" ] [] ]
            ]
          ]
          , span [ class ("help has-text-centered " ++ helperClass) ]
            [ text helperText
            ]
        ]
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
    |> div []

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
