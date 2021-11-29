module Pages.Home_ exposing (Model, Msg, page, view)

import Auth
import Html exposing (Html)
import Html.Events as Events
import Html.Attributes as Attr
import Page
import Request exposing (Request)
import Shared
import Storage exposing (Storage)
import UI
import Dict exposing (Dict)
import View exposing (View)


page : Shared.Model -> Request -> Page.With Model Msg
page shared request =
    Page.protected.element <|
        \user ->
            { init = init
            , update = update shared.storage
            , view = view user request
            , subscriptions = \_ -> Sub.none
            }



-- INIT


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



-- UPDATE


type Msg
    = ClickedSignOut


update : Storage -> Msg -> Model -> ( Model, Cmd Msg )
update storage msg model =
    case msg of
        ClickedSignOut ->
            ( model
            , Storage.signOut storage
            )


view : Auth.User -> Request -> Model -> View Msg
view user request _ =
    { title = "Homepage"
    , body =
        UI.layout user request [
            Html.main_ [ Attr.class "container page-container", Attr.id "main-content"] 
            [ Html.h1 [ Attr.class ""] [ Html.text ("Hello, " ++ user.name ++ "!") ]
            , fromScanner user request
            , Html.button [ Events.onClick ClickedSignOut ] [ Html.text "Sign out" ]
            
            ]
         ]
        
    }


fromScanner : Auth.User -> Request -> Html Msg
fromScanner _  req = 
    case Dict.get "qrid" req.query of 
    Nothing ->
        Html.div [][]
    Just val ->
        Html.div[ Attr.class "alert alert-success"]
        [ Html.div [Attr.class "alert-body"]
          [ Html.p [Attr.class "alert-heading"][ Html.text "You just scanned a qrid!"]
          , Html.p [Attr.class "alert-text"]
              [ Html.text "And i believe your item id is "
              , Html.a [ Attr.href ("/item?"++val)][Html.text val]
              ]
          ]

        ]