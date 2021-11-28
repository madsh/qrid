module Pages.Home_ exposing (Model, Msg, page, view)

import Auth
import Html
import Html.Events as Events
import Html.Attributes as Attr
import Page
import Request exposing (Request)
import Shared
import Storage exposing (Storage)
import UI
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
            , Html.button [ Events.onClick ClickedSignOut ] [ Html.text "Sign out" ]
            ]
         ]
        
    }
