module Pages.LocalItems exposing (Model, Msg, page)


import Effect exposing (Effect)
import Gen.Params.LocalItems exposing (Params)
import Page
import Auth
import Shared
import View exposing (View)
import Page
import Domain.Item as Item exposing (Item)
import Request exposing (Request)
import UI

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Html.Attributes as A exposing (id, type_)

page : Shared.Model -> Request -> Page.With Model Msg
page shared request =
    Page.protected.element <|
        \user ->
            { init = init shared
            , update = update 
            , view = view user request
            , subscriptions = \_ -> Sub.none
            }

-- INIT


type alias Model =
    { items : (List Item)}



init : Shared.Model -> ( Model, Cmd Msg )
init shared =
    ( { items = shared.storage.collection }, Cmd.none )



-- UPDATE


type Msg
    = ItemClicked Item
    | DeleteClicked Item


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ItemClicked item ->
            ( model, Cmd.none )
        DeleteClicked item ->
            ( model, Cmd.none )


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW





view : Auth.User -> Request -> Model -> View Msg
view user request model =
    { title = "qrid - your local items"
    , body =
        UI.layout user   [ 
            Html.main_ [ A.class "container page-container", A.id "main-content"] 
            [ Html.h1 [ class ""] [ Html.text "Your Local Items" ]
            , Html.p [ class "font-lead"] [ Html.text "Here is what you have registered so far on this device"]                        
            , viewItems model.items
            ]
         ]
        
    }




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
    [ Html.td [Html.Events.onClick (ItemClicked item)][Html.text item.name]
    , Html.td [][ Html.text item.description]    
    , Html.td [][ Html.span [A.class "mr-3", Html.Events.onClick (DeleteClicked item)][Html.text "delete"]                
                ]
    ]