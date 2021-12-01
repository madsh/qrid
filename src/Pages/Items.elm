module Pages.Items exposing (Model, Msg, page, view)

import Auth

import Html exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode
import Domain.Item exposing (Item, itemsDecoder)
import RemoteData exposing (RemoteData, WebData)



import Html.Attributes exposing (class)
import Html.Attributes as A exposing (id, type_)
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

-- MODEL
type alias Model =
    { items : WebData (List Item) }

-- INIT

init : ( Model, Cmd Msg )
init =
    ( { items = RemoteData.Loading}, httpGetItems )

-- UPDATE


type Msg
    = FetchItems 
    | DataRecieved (WebData (List Item))


update : Storage -> Msg -> Model -> ( Model, Cmd Msg )
update storage msg model =
    case msg of
        FetchItems ->
            ( {model | items = RemoteData.Loading}, httpGetItems)
        
        DataRecieved response ->
            ( { model | items = response}, Cmd.none)




httpGetItems : Cmd Msg
httpGetItems = 
    Http.get 
        { url = "http://localhost:3000/items"
        , expect = itemsDecoder
            |> Http.expectJson (RemoteData.fromResult >> DataRecieved )
        }

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


-- VIEWS


view : Auth.User -> Request -> Model -> View Msg
view user request model =
    { title = "qrid - your items"
    , body =
        UI.layout user   [ 
            Html.main_ [ A.class "container page-container", A.id "main-content"] 
            [ Html.h1 [ class ""] [ Html.text "Your Items" ]
            , Html.p [ class "font-lead"] [ Html.text "Here is what you have registered so far"]                        
            , viewForm user model
            , viewItemsOrError model            
            ]
         ]
        
    }


viewForm : Auth.User -> Model -> Html Msg
viewForm user model = 
    Html.div [class "form-group search mb-6"][
        Html.input [class "form-input", A.id "searchTable", A.type_ "search"][], 
        Html.button [class "button button-search", onClick FetchItems] [Html.text "Search"]
    ]


viewItemsOrError : Model -> Html Msg 
viewItemsOrError model = 
    case model.items of
        RemoteData.NotAsked -> Html.text "not asked"
        RemoteData.Loading -> Html.text "loading"
        RemoteData.Failure httpError -> viewError (buildErrorMessage httpError)
        RemoteData.Success items -> viewItems items


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
          , Html.th [][]          ]
        ]
      , Html.tbody [](List.map viewTableRow items)
      ]
    ]



viewTableRow: Item -> Html Msg 
viewTableRow item = 
    Html.tr [ ]
    [ Html.td [][Html.text item.name]
    , Html.td [][Html.text item.description]    
    , Html.td [][Html.a [A.href ("/item/" ++ item.qrid)][Html.text "edit"]]
    ]