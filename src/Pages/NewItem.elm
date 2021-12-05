module Pages.NewItem exposing (Model, Msg, page)

import Auth
import Html exposing (Html)
import Html.Events as Events
import Html.Attributes as A
import Page
import Request exposing (Request)
import Shared
import Storage exposing (Storage)
import UI
import View exposing (View)
import UUID
import Dict exposing (Dict)
import Domain.QRID as QRID
import UUID exposing (Error)
import Http
import Domain.Item exposing (Item, itemDecoder, itemEncoder)
import Gen.Route as Route exposing (Route)
import Browser.Navigation
import List exposing (length)



page : Shared.Model -> Request -> Page.With Model Msg
page shared request =
    Page.protected.element <|
        \user -> { init = init request
        , update = update
        , view = view user request
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { item : Item
    , newIdError : Maybe String
    , nameError : Maybe String    
    , descError : Maybe String
    , createError : Maybe String
    , pageTitle : String
    }


init :  Request -> (Model, Cmd Msg )
init req =
    case Dict.get "qrid" req.query of 

    Just val -> 
            ( { item = { qrid = val, name = "", description = ""}
              , newIdError = Nothing
              , nameError = Nothing      
              , createError = Nothing         
              , descError = Nothing     
              , pageTitle = "new from tag"
              }
              , Cmd.none 
            )

    Nothing -> 
        ( { item = { qrid = "got nothing", name = "", description = ""}
              , newIdError = Nothing
              , nameError = Nothing      
              , createError = Nothing
              , descError = Nothing
              , pageTitle = "new no tag yet"
              }
              , Cmd.none 
            )



-- UPDATE


type Msg
    = PressedGenerate

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model  =
    case msg of
        PressedGenerate ->
            let                
                preItem = model.item
                updatedItem = 
                    { preItem | qrid = UUID.toString QRID.generate }                    
            in            
            ( { model |  item = updatedItem, pageTitle = "new from generated" } , Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW

view : Auth.User -> Request -> Model -> View Msg
view user request model =
    { title = "qrid — " ++ model.pageTitle
    , body =
        UI.layout user [
            Html.main_ [ A.class "container page-container", A.id "main-content"] 
            [ Html.h1 [ A.class ""] [ Html.text "Register an item" ]
            , Html.p [ A.class "font-lead"] [ Html.text "Here you can add a new item to your collection"]
            --, viewError model.createError
            --, viewForm user model request           
            --, viewFormRegister user model
            ]
         ]
        
    }