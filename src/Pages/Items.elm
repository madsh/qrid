module Pages.Items exposing (Model, Msg, page, view)

import Auth
import Html exposing (..)
import Http
import Html.Attributes exposing (class)
import Html.Attributes as A exposing (id, type_)

import Page
import Request exposing (Request)
import Shared
import Storage exposing (Storage)
import UI
import View exposing (View)
import Html.Events exposing (onClick)
import Json.Decode as D exposing (Decoder, at, field, int, map3, string)


page : Shared.Model -> Request -> Page.With Model Msg
page shared _ =
    Page.protected.element <|
        \user ->
            { init = init
            , update = update shared.storage
            , view = view user
            , subscriptions = \_ -> Sub.none
            }



-- INIT


type alias Model =
    { items : ItemList }


type alias Item = 
    { name : String
    , description : String
    , qrid : String  }

type alias ItemList = 
    List Item


init : ( Model, Cmd Msg )
init =
    ( { items = []}, Cmd.none )



-- UPDATE


type Msg
    = SendHttpRequest 
    | DataRecieved (Result Http.Error ItemList)


getItems : Cmd Msg
getItems = 
    Http.get 
        { url = "http://localhost:5019/items"
        , expect = Http.expectJson DataRecieved itemListDecoder
        }


itemListDecoder : Decoder (List Item)
itemListDecoder = D.list itemDecoder          

itemDecoder : Decoder Item 
itemDecoder = 
    map3 Item
        ( at ["name"] string)
        ( at ["description"] string)
        ( at ["qrid"] string)


update : Storage -> Msg -> Model -> ( Model, Cmd Msg )
update storage msg model =
    case msg of
        SendHttpRequest ->
            ( model, getItems )
        
        DataRecieved (Ok itemList) ->            
            ( { model | items = itemList } , Cmd.none)

        DataRecieved (Err _) -> 
            ( model, Cmd.none )


view : Auth.User -> Model -> View Msg
view user model =
    { title = "qrid - your items"
    , body =
        UI.layout user [ 
            Html.main_ [ A.class "container page-container", A.id "main-content"] 
            [ Html.h1 [ class ""] [ Html.text "Your Items" ]
            , Html.p [ class "font-lead"] [ Html.text "Here is what you have registered so far"]            
            , Html.div [][Html.text (" items indeholder " ++ (String.fromInt( List.length model.items)))]
            , viewForm user model
            , viewTable user model            
            ]
         ]
        
    }


viewForm : Auth.User -> Model -> Html Msg
viewForm user model = 
    Html.div [class "form-group search mb-6"][
        Html.input [class "form-input", A.id "searchTable", A.type_ "search"][], 
        Html.button [class "button button-search", onClick SendHttpRequest] [Html.text "Search"]
    ]


viewTable : Auth.User -> Model -> Html Msg
viewTable user model = 
    Html.div[class "table--reponsive-scroll"]
    [ Html.table [class "table"] 
      [ Html.thead [][ viewTableHeader user model]
      , Html.tbody [](List.map viewTableRow model.items)
      ]
    ]

viewTableHeader : Auth.User -> Model -> Html Msg
viewTableHeader user model = 
    Html.tr[]
    [ Html.th [][Html.text "Name"]
    , Html.th [][Html.text "Description"]
    , Html.th [][Html.text "QRID"]
    ]


viewTableRow: Item -> Html Msg 
viewTableRow item = 
    Html.tr []
    [ Html.td [][Html.text item.name]
    , Html.td [][Html.text item.description]
    , Html.td [][Html.text item.qrid]
    ]