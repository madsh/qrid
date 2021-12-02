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
import Debug 
import Dict exposing (Dict)
import Url.Parser.Query as Query
import Domain.QRID as QRID
import UUID exposing (Error)
import Http
import Domain.Item exposing (Item, itemDecoder, itemEncoder)
import Gen.Route as Route exposing (Route)
import Browser.Navigation




page : Shared.Model -> Request -> Page.With Model Msg
page shared request =
    Page.protected.element <|
        \user ->
            { init = init request
            , update = update shared.storage
            , view = view user request
            , subscriptions = \_ -> Sub.none
            }



-- INIT


type alias Model =
    { item : Item
    , newIdError : String
    , nameError : String    
    , createError : Maybe String
    }


init :  Request -> (Model, Cmd Msg )
init req =
    case Dict.get "qrid" req.query of 

    Just val -> 
            ( { item = { qrid = val, name = "", description = ""}
              , newIdError = ""
              , nameError = ""      
              , createError = Nothing
              }
              , Cmd.none 
            )

    Nothing -> 
        ( { item = { qrid = "got nothing", name = "", description = ""}
              , newIdError = ""
              , nameError = ""      
              , createError = Nothing
              }
              , Cmd.none 
            )

        

      



-- UPDATE

type Msg
    = UpdatedUUID String
    | UpdatedName String    
    | PressedScan
    | PressedGenerate          
    | Submitted
    | ItemCreated (Result Http.Error Item)



update : Storage -> Msg -> Model -> ( Model, Cmd Msg )
update storage msg model  =
    case msg of
        UpdatedUUID idvalue ->
            let
                preItem = model.item
                updatedItem = 
                    { preItem | qrid = idvalue }                                    
            in            
            ({ model |  item = updatedItem}, Cmd.none )

        UpdatedName value ->
           let
                preItem = model.item
                updatedItem = 
                    { preItem | name = value }                                    
            in            
            ( { model |  item = updatedItem } , Cmd.none )
        
        PressedScan ->            
            ( model , Browser.Navigation.load "scanner.html?new"
            )

        PressedGenerate ->
            let
                preItem = model.item
                updatedItem = 
                    { preItem | qrid = UUID.toString QRID.generate }                    
            in            
            ( { model |  item = updatedItem } , Cmd.none )

        Submitted -> (model, Cmd.none)
        
        ItemCreated (Ok item) ->
            ( {model | item = item, createError = Nothing}
            , Browser.Navigation.load (Route.toHref Route.Items)
            )

        ItemCreated (Err error) ->
            ( {model | createError = Just (buildErrorMessage error)}, Cmd.none)

validate : Model -> Model
validate model  = 
    validateName model



 
validateName: Model -> Model
validateName model = 
    if (String.length model.item.name) < 5 then 
        { model | nameError = "Names must be longer than 5" }
    else 
        { model | nameError = ""}

validateUUID: Model -> Model
validateUUID model = 
     if (String.length model.item.qrid) < 8 then 
        { model | newIdError = "Ids must be longer than 8" }
    else 
        { model | newIdError = ""}


hasErrors: Model -> Bool
hasErrors model = 
    if (  ((String.length model.newIdError) > 1) 
       || ((String.length model.nameError) > 1)
       )
    then 
        True
    else 
        False


createItem: Item -> Cmd Msg         
createItem  item =
    Http.post 
      { url = "http://localhost:3000/items"
      , body = Http.jsonBody (itemEncoder item)
      , expect = Http.expectJson ItemCreated itemDecoder      
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

-- VIEW

view : Auth.User -> Request -> Model -> View Msg
view user request model =
    { title = "qrid - your items"
    , body =
        UI.layout user [
            Html.main_ [ A.class "container page-container", A.id "main-content"] 
            [ Html.h1 [ A.class ""] [ Html.text "Register an item" ]
            , Html.p [ A.class "font-lead"] [ Html.text "Here you can add a new item to your collection"]
            , viewError model.createError
            , viewForm user model request           
            , viewFormRegister user model
            ]
         ]
        
    }

viewError : Maybe String -> Html Msg 
viewError maybeError = 
    case maybeError of
        Just error -> 
            viewErrorString error

        Nothing -> Html.text ""


viewErrorString : String -> Html Msg 
viewErrorString errorMessage = 
    let 
        errorHeading = "Could not save your item"
    in
    Html.div[A.class "alert alert-error"]
    [
        Html.div [A.class "alert-body"] 
        [ Html.p [A.class "alert-heading"] [Html.text errorHeading ]
        , Html.p [A.class "alert-text"] [Html.text ("Error: " ++ errorMessage)]
        ]
    ]


viewForm : Auth.User -> Model -> Request -> Html Msg 
viewForm user model request =
    Html.div [ A.class "form-div"]
    [ viewFormUUID user model request  
    , viewFormName user model
    , viewFormDesc user model
    ]

viewFormUUID : Auth.User -> Model -> Request -> Html Msg
viewFormUUID user model request =
    let
        qrid = ""
    in
    Html.div [ A.class "form-group", A.id "form-group-uuid"] [
    Html.label [A.class "form-label", A.for "form-uuid-field"][ Html.text "UUID"]
      , Html.span [A.class "form-hint", A.id "hint1"][ Html.text "What is the UUID you want to register this item under?"]
      , Html.span [A.class "form-hint", A.id "hint2"][ Html.text "A UUID has the form of 88c973e3-f83f-4360-a320-d8844c365130"]
      , viewFormUUIDError user model
      , Html.div [A.class "form-input-wrapper form-input-wrapper-prefeix"]
        [ Html.div [A.class "form-input-prefix"][ Html.text (if (((String.length model.item.qrid) > 7) && (String.length model.newIdError < 1)) then "✔" else "UUID")]
        , Html.input [ A.id "form-uuid-field"
                     , A.name "uuid-field"                     
                     , A.class "form-input input-width-xl"
                     , A.value model.item.qrid
                     , Events.onInput UpdatedUUID 
                     ] []
        , Html.span [A.class "ml-9"][ ]         
        ]             
       , Html.div [A.class "my-3", A.id "startButtons"] 
              [ Html.button [ Events.onClick PressedScan, A.class "button button-secondary"] [ Html.text "Scan"]              
              , Html.button [ Events.onClick PressedGenerate, A.class "button button-secondary"] [ Html.text "Generate"]
              ]
      ]

viewFormUUIDError : Auth.User -> Model -> Html Msg      
viewFormUUIDError _ model = 
    if (True) 
    then
        Html.span [A.class "form-error-message", A.id "form-group-uuid-error"]
        [ Html.span [A.class "sr-only"][Html.text "Error:"]
        , Html.text model.newIdError 
        ]
    else 
        Html.div [][]

viewFormName : Auth.User -> Model -> Html Msg
viewFormName user model =
    formField 
        "name"
        "Name your item"
        "A friendly name for your item"
        model.nameError
        (Html.input [Events.onInput UpdatedName, A.value model.item.name , A.class "Form-input  input-char-27", A.id "form.name", A.type_ "text"][] {- aria and control id-})
        user 
        model 
    
viewFormDesc : Auth.User -> Model -> Html Msg    
viewFormDesc user model = 
    formField
        "desc"
        "Description"
        "A few more words to describe the item you are registering"
        ""
        (Html.textarea [A.class "Form-input input-char-27", A.id "form.desc", A.rows 5][] {- aria and control id-})
        user 
        model




viewFormRegister : Auth.User -> Model -> Html Msg
viewFormRegister user model =
    Html.button [ A.disabled (hasErrors model)
                , A.class "button button-primary mt-9" 
                , Events.onClick Submitted               
                ]
                [ Html.text "Register"]


formField : String -> String -> String -> String -> Html Msg -> Auth.User -> Model -> Html Msg 
formField id label hint error html user model   =
    Html.div [ A.class "form-group", A.id ("form-group" ++ id)]
    [ Html.label [A.class "form-label", A.for ("form-"++ id ++ "-field")][ Html.text label]
    , Html.span [A.class "form-hint", A.id ("form-"++id++"-hint")][ Html.text hint]
    , Html.span [A.class "form-error-message", A.id "form-group-name-error" ]
      [ Html.span [ A.class "sr-only"] [ Html.text "Error:"]
      , Html.text error
      ] 
    , html
    ]
