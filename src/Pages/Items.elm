module Pages.Items exposing (Model, Msg, page, view)

import Auth
import Html exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required, optional)




import Html.Attributes exposing (class)
import Html.Attributes as A exposing (id, type_)
import Page
import Request exposing (Request)
import Shared
import Storage exposing (Storage)
import UI
import View exposing (View)



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
type alias Item = 
    { name : String
    , description : String
    , qrid : String  }


type alias Model =
    { items : List Item
    , errorMessage : Maybe String
     }



init : ( Model, Cmd Msg )
init =
    ( { items = [], errorMessage = Nothing}, Cmd.none )



-- UPDATE


type Msg
    = SendHttpRequest 
    | DataRecieved (Result Http.Error (List Item))


getItems : Cmd Msg
getItems = 
    Http.get 
        { url = "http://localhost:5019/items"
        , expect = Http.expectJson DataRecieved itemListDecoder
        }


itemListDecoder : Decoder (List Item)
itemListDecoder = Decode.list itemDecoder          

itemDecoder : Decoder Item 
itemDecoder = 
    Decode.succeed Item 
        |> required "qrid" string
        |> required "name" string
        |> optional "description" string " - no description - "


update : Storage -> Msg -> Model -> ( Model, Cmd Msg )
update storage msg model =
    case msg of
        SendHttpRequest ->
            ( model, getItems )
        
        DataRecieved (Ok itemList) ->            
            ( { model | items = itemList } , Cmd.none)

        DataRecieved (Err httpError) -> 
            ( {model | errorMessage = Just (buildErrorMessage httpError)}, Cmd.none)

buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "Unable to reach server."

        Http.BadStatus statusCode ->
            "Request failed with status code: " ++ String.fromInt statusCode

        Http.BadBody message ->
            message

{- VIEW -}

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
            , viewItemsOrError model            
            ]
         ]
        
    }


viewForm : Auth.User -> Model -> Html Msg
viewForm user model = 
    Html.div [class "form-group search mb-6"][
        Html.input [class "form-input", A.id "searchTable", A.type_ "search"][], 
        Html.button [class "button button-search", onClick SendHttpRequest] [Html.text "Search"]
    ]


viewItemsOrError : Model -> Html Msg 
viewItemsOrError model = 
    case model.errorMessage of 
        Just message ->
            viewError message
        Nothing ->
            viewItems model.items

viewError : String -> Html Msg 
viewError errorMessage = 
    let 
        errorHeading = "Couldn't fetch data at this time"
    in
    Html.div[class "alert alert-error"]
    [
        Html.div [class "alert-body"] 
        [ Html.p [class "alert-heading"] [Html.text errorHeading ]
        , Html.p [class "alert-text"] [Html.text ("Error: " ++ errorMessage)]
        ]
    ]


viewItems : List Item -> Html Msg
viewItems items = 
    Html.div[class "table--reponsive-scroll"]
    [ Html.table [class "table table--compact"] 
      [ Html.thead []
        [ Html.tr[]
          [ Html.th [][Html.text "Name"]
          , Html.th [][Html.text "Description"]
          , Html.th [][Html.text "QRID"]
          ]
        ]
      , Html.tbody [](List.map viewTableRow items)
      ]
    ]



viewTableRow: Item -> Html Msg 
viewTableRow item = 
    Html.tr []
    [ Html.td [][Html.text item.name]
    , Html.td [][Html.text item.description]
    , Html.td [][Html.text item.qrid]
    ]