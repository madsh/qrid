module Pages.Settings exposing (Model, Msg, page)

import Gen.Params.Settings exposing (Params)
import Page
import Request
import Shared
import View exposing (View)
import Request exposing (Request)
import Auth
import UI

import Html exposing (Html)
import Html.Events as Events
import Html.Attributes as A




page : Shared.Model -> Request -> Page.With Model Msg
page shared request =
    Page.protected.element <|
        \user -> { init = init 
        , update = update 
        , view = view user request
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


view : Auth.User -> Request -> Model -> View Msg
view user request model =
    { title = "qrid — settings"
    , body =
        UI.layout user [
            Html.main_ [ A.class "container page-container", A.id "main-content"] 
            [ Html.h1 [ A.class ""] [ Html.text "Register an item" ]
            , Html.p [ A.class "font-lead"] [ Html.text "Here you can add a new item to your collection"]
            , viewSwitch            
            ]
         ]
        
    }


viewSwitch : Html msg
viewSwitch = 
    Html.div [A.class "form-group m-4"]
        [ Html.input [A.id "form-storage-toggle", A.type_ "checkbox", A.class "form-toggle"][]
        , Html.label [A.for "form-storage-toggle", A.class "form-toggle-label"][Html.text "remote"]
    ]

