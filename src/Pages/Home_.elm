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
import Browser.Navigation


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
    | ClickedScan
    | ClickedGenerate

update : Storage -> Msg -> Model -> ( Model, Cmd Msg )
update storage msg model =
    case msg of
        ClickedSignOut ->
            ( model
            , Storage.signOut storage
            )
        ClickedScan ->
            ( model
            , Browser.Navigation.load "scanner.html"
            )
        ClickedGenerate ->
            ( model
            , Browser.Navigation.load "generator-demo.html?qrid=0000-0000-0000"
            )

view : Auth.User -> Request -> Model -> View Msg
view user request _ =
    { title = "Homepage"
    , body =
        UI.layout user [
            Html.main_ [ Attr.class "container page-container", Attr.id "main-content"] 
            [ Html.h1 [ Attr.class ""] [ Html.text ("Hello, " ++ user.name ++ "!") ]
            , fromScanner user request
            , Html.div[ Attr.class "m-4"][Html.button [ Attr.class "button button-primary",Events.onClick ClickedSignOut ] [ Html.text "Sign out" ]]    
            , Html.div[ Attr.class "m-4"][Html.button [ Attr.class "button button-primary", Events.onClick ClickedScan ] [ Html.text "Click to try the scanner!" ]]
            , Html.div[ Attr.class "m-4"][Html.button [ Attr.class "button button-primary", Events.onClick ClickedGenerate ] [ Html.text "Click to try generator" ]]
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