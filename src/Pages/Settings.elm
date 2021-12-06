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
import Storage exposing (Storage)




page : Shared.Model -> Request -> Page.With Model Msg
page shared request =
    Page.protected.element <|
        \user -> { init = init 
        , update = update shared
        , view = view user shared request
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
    = ClickedClear


update : Shared.Model -> Msg -> Model -> ( Model, Cmd Msg )
update shared msg model =
    case msg of
        ClickedClear ->
            ( model, (Storage.deleteAllItems shared.storage) )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Auth.User -> Shared.Model -> Request -> Model -> View Msg
view user shared request model =
    { title = "qrid — settings"
    , body =
        UI.layout user [
            Html.main_ [ A.class "container page-container", A.id "main-content"] 
            [ Html.h1 [ A.class ""] [ Html.text "Register an item" ]
            , Html.p [ A.class "font-lead"] [ Html.text "Here you can add a new item to your collection"]
            , viewSwitch       
            , viewStorageClear shared    
            ]
         ]
        
    }


viewSwitch : Html msg
viewSwitch = 
    Html.div [A.class "form-group m-4"]
        [ Html.input [A.id "form-storage-toggle", A.type_ "checkbox", A.class "form-toggle"][]
        , Html.label [A.for "form-storage-toggle", A.class "form-toggle-label"][Html.text "remote"]
    ]

viewStorageClear : Shared.Model -> Html Msg
viewStorageClear shared = 
    Html.div [] 
    [ Html.h2 [ A.class ""] [ Html.text "Local storage" ]
    , Html.div[ A.class "m-4"][Html.button [ A.class "button button-primary" , Events.onClick ClickedClear ] [ Html.text ("Delete " ++ (String.fromInt (List.length shared.storage.collection)) ++ " item(s)") ]]
    ]    
    

