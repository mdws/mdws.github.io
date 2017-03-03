module Components.SongDownload.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Components.SongDownload.Models exposing (SongDownload, DownloadStatus(..))
import Components.SongDownload.Messages exposing (Msg)

view : SongDownload -> Html Msg
view song =
  div [ class "columns" ]
    [ div [ class "box column is-half is-offset-one-quarter" ]
      [ article [ class "media" ]
        [ songArtwork song
        , songContent song
        , songStatusView song
        ]
      ]
    ]

songArtwork : SongDownload -> Html Msg
songArtwork song =
  let
    artworkUrl =
      song.data
        |> Maybe.andThen .artwork
        |> Maybe.withDefault ""
  in
    figure [ class "media-left image is-64x64" ]
      [ img [ src artworkUrl ] []
      ]

songContent : SongDownload -> Html Msg
songContent song =
  case song.data of
    Just data ->
      div [ class "media-content" ]
        [ div [ class "content" ]
          [ p []
            [ strong [] [ a [ href song.url, target "_blank" ] [ text data.title ] ]
            , br [] []
            , small [] [ text data.user ]
            ]
          ]
        ]

    Nothing ->
      div [ class "media-content" ] []

songStatusView : SongDownload -> Html Msg
songStatusView song =
  let
    buttonStyle =
      [ ("width", "64px")
      , ("height", "64px")
      ]

    statusDiv =
      case song.status of
        Completed ->
          button [ class "button is-disabled is-inverted is-success", style buttonStyle ]
            [ span [ class "icon" ] [ i [ class "fa fa-check" ] [] ]
            ]

        Errored _ ->
          button [ class "button is-disabled is-inverted is-danger", style buttonStyle ]
            [ span [ class "icon" ] [ i [ class "fa fa-close" ] [] ]
            ]

        _ ->
          button [ class "button is-loading is-light", style buttonStyle ] []
  in
    div [ class "media-right" ] [ statusDiv ]
