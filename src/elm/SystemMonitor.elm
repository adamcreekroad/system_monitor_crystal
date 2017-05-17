import Html exposing (..)
import Html.Attributes exposing (..)

main =
  Html.program
    { model = model
    , view = view
    , update = update
    }


-- MODEL

type alias CPU =
  { id : Integer
  , usage : Float
  }

type alias Mem =
  { total : Float
  , free : Float
  , available : Float
  , buffers : Float
  , cached : Float
  }

model : Model
model =
  0


-- UPDATE

type Msg
  = Increment
  | Decrement

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1


-- VIEW

view : Model -> Html msg
view model =
  table []
    [ thead []
        [ tr []
            [ th [] [ text "Processor ID" ]
            , th [] [ text "Usage" ]
            ]
        ]
    , tbody []
        [ tr [ id "cpu_0" ]
            [ td [ class "cpu-id" ] [ text "0" ]
            , td [ class "cpu-usage" ] [ text "12%" ]
            ]
        ]
    ]
