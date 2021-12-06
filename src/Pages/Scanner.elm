module Pages.Scanner exposing (Model, Msg, page)

import Gen.Params.Scanner exposing (Params)
import Page
import Request
import Shared
import UI
import Auth
import View exposing (View)
import Html exposing (Html)
import Html.Events as Events
import Html.Attributes exposing (..)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared request =
    Page.protected.element <|
        \user -> 
        { init = init 
        , update = update 
        , view = view user
        , subscriptions = subscriptions
        }


-- INIT


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Auth.User -> Model -> View Msg
view user model =
    { title = "qrid — scanner "
    , body = UI.layoutEmpty user [viewScanner]       
    }

viewScanner : Html Msg 
viewScanner = 
    Html.div [ id "scanner-container"]
    [ Html.div [ href "./"][Html.text "go back"]
    , Html.a [ id "btn-scan-qr"] [ Html.img [src "qricon.svg"][]]
    , Html.canvas [id "qr-canvas"][]
    , Html.div [class "qr-result"][Html.b [][Html.text "Data"], Html.span [id "outputData"][]]
    , Html.div [class "qr-link"][Html.b [][Html.text "Link"], Html.span [id "outputLink"][]]
    ]

