import Html exposing (..)
import Html.App as App

main : Program Never
main =
  App.program
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }

-- MODEL

type alias Model =
  { a : String
  }

init : (Model, Cmd Msg)
init =
  ({ a = "Hello, world!" }, Cmd.none)

-- UPDATE

type Msg
  = None

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  (model, Cmd.none)

-- VIEW

view : Model -> Html Msg
view model =
  h1 []
    [ text model.a
    ]

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
