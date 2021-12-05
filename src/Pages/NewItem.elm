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
    , newIdSource : IdSource
    , nameError : Maybe String    
    , descError : Maybe String
    , createError : Maybe String
    , pageTitle : String
    }

type IdSource 
    = Manual
    | Generated
    | FromUrl
    | Undecided

nillTemplate = "00000000-0000-0000-0000-000000000000"



init :  Request -> (Model, Cmd Msg )
init req =
    case Dict.get "qrid" req.query of 

    Just val -> 
            ( { item = { qrid = val, name = "", description = ""}
              , newIdError = Nothing
              , newIdSource = FromUrl
              , nameError = Nothing      
              , createError = Nothing         
              , descError = Nothing     
              , pageTitle = "new from tag"
              }
              , Cmd.none 
            )

    Nothing -> 
        ( { item = { qrid = "tap here to type in, or click generate below", name = "", description = ""}
              , newIdError = Nothing
              , newIdSource = Undecided
              , nameError = Nothing      
              , createError = Nothing
              , descError = Nothing
              , pageTitle = "new no tag yet"
              }
              , Cmd.none 
            )



-- UPDATE


type Msg
    = UpdatedUUID String
    | FocusedUUID
    | PressedGenerate

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model  =
    case msg of
        UpdatedUUID idvalue ->
           let
                preItem = model.item

                source = 
                    if (model.newIdSource == FromUrl)
                    then (Manual)
                    else (model.newIdSource)

                _ = Debug.log "updating UUID to " idvalue
                updatedItem = 
                    { preItem | qrid = idvalue }                                    
            in            
            ({ model |  item = updatedItem}, Cmd.none )

        FocusedUUID ->
           let
                preItem = model.item

                newValue = 
                    if (model.newIdSource == Undecided) 
                    then nillTemplate
                    else preItem.qrid


                updatedItem = 
                    { preItem | qrid = newValue }   

                _ = Debug.log "Focusing and updating source to Manual "
                
            in            
            ({ model |  item = updatedItem, newIdSource = Manual}, Cmd.none )


        PressedGenerate ->
            let                
                preItem = model.item
                updatedItem = 
                    { preItem | qrid = UUID.toString QRID.generate }                    

                _ = Debug.log "Generated  "
            in            
            ( { model |  item = updatedItem, newIdSource = Generated } , Cmd.none )



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
            , viewForm user model request           
            --, viewFormRegister user model
            ]
         ]
        
    }


viewForm : Auth.User -> Model -> Request -> Html Msg 
viewForm user model request =
    Html.div [ A.class "form-div"]
    [ viewFormUUID user model request  
    --, viewFormName user model
    --, viewFormDesc user model
    ]    

viewFormUUID : Auth.User -> Model -> Request -> Html Msg
viewFormUUID user model request =
    let
        qrid = ""
    in
    Html.div [ A.class "form-group", A.id "form-group-uuid"] [
    Html.label [A.class "form-label", A.for "form-uuid-field"][ Html.text "UUID"]
      , Html.span [A.class "form-hint", A.id "hint1"][ Html.text "What is the UUID you want to register this item under?"]
      --, Html.span [A.class "form-hint", A.id "hint2"][ Html.text "A UUID has the form of 88c973e3-f83f-4360-a320-d8844c365130"]
      --, viewFormUUIDError model
      , Html.div [A.class "form-input-wrapper form-input-wrapper-prefeix"]
        [ Html.div [A.class "form-input-prefix"][ Html.text (if (True) then "✔" else "UUID")]
        , Html.input [ A.id "form-uuid-field"
                     , A.name "uuid-field"                     
                     , A.class "form-input input-width-xl"
                     , A.value model.item.qrid
                     , Events.onInput UpdatedUUID 
                     , Events.onFocus FocusedUUID
                     ] []
        , Html.span [A.class "ml-9"][ ]         
        ]             
       , Html.div [A.class "my-3", A.id "startButtons"] 
              [ -- Html.button [ Events.onClick PressedScan, A.class "button button-secondary"] [ Html.text "Scan"]              
              Html.button [ Events.onClick PressedGenerate, A.class "button button-secondary"] [ Html.text "Generate"]
              ]
      ]    