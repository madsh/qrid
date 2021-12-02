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
        \user ->
            { init = init request
            , update = update shared.storage
            , view = view user request
            , subscriptions = \_ -> Sub.none
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
            ( validateUUID { item = { qrid = val, name = "", description = ""}
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
    = UpdatedUUID String
    | UpdatedName String  
    | UpdatedDesc String  
    | PressedScan
    | PressedGenerate          
    | PressedRegister
    | ItemCreated (Result Http.Error Item)



update : Storage -> Msg -> Model -> ( Model, Cmd Msg )
update storage msg model  =
    case msg of
        UpdatedUUID idvalue ->
            let
                preItem = model.item

                _ = Debug.log "updating UUID to " idvalue

                updatedItem = 
                    { preItem | qrid = idvalue }                                    
            in            
            ({ model |  item = updatedItem}, Cmd.none )

        UpdatedName value ->
           let
                preItem = model.item
                updatedItem = 
                    { preItem | name = value }                                    
                -- a change to validate if we all ready have an error
            in            
            ( { model |  item = updatedItem } , Cmd.none )

        UpdatedDesc value ->
           let
                preItem = model.item
                updatedItem = 
                    { preItem | description = value }                                    
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
            ( validateUUID { model |  item = updatedItem, pageTitle = "new from generated" } , Cmd.none )

        PressedRegister -> 
            ( validate model , if (hasErrors model) then Cmd.none else Cmd.none)
        
        ItemCreated (Ok item) ->
            ( {model | item = item, createError = Nothing}
            , Browser.Navigation.load (Route.toHref Route.Items)
            )

        ItemCreated (Err error) ->
            ( {model | createError = Just (buildErrorMessage error)}, Cmd.none)

validate : Model -> Model
validate model  = 
    model 
        |> validateUUID 
        |> validateName
        --|> validateDesc



 
validateName: Model -> Model
validateName model = 
    if (String.length model.item.name) < 5 then 
        { model | nameError = Just "Names must be longer than 5" }
    else 
        { model | nameError = Nothing}


validateDesc: Model -> Model
validateDesc model = 
    if (String.length model.item.description) < 5 then 
        { model | descError = Just "Descriptions must be longer than 5" }
    else 
        { model | descError = Nothing}


validateUUID: Model -> Model
validateUUID model = 

    case QRID.parse model.item.qrid of
       Ok qrid ->     
            model
       Err e -> 
            let
               _ = Debug.log "validating : " model.item.qrid
               _ = Debug.log "          -> " e
            in
            { model | newIdError = Just ("bad uuid : " ++ e)}



hasErrors: Model -> Bool
hasErrors model = 
    if (  ( model.newIdError == Nothing )
       && ( model.nameError == Nothing )
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
    { title = "qrid — " ++ model.pageTitle
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
      , viewFormUUIDError model
      , Html.div [A.class "form-input-wrapper form-input-wrapper-prefeix"]
        [ Html.div [A.class "form-input-prefix"][ Html.text (if (True) then "✔" else "UUID")]
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

viewFormUUIDError : Model -> Html Msg      
viewFormUUIDError model =     
    case model.newIdError of
        Just error -> 
            Html.span [A.class "form-error-message", A.id "form-group-uuid-error"]
            [ Html.span [A.class "sr-only"][Html.text "Error:"]
            , Html.text error 
            ]

        Nothing -> Html.text ""
    

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
        model.descError
        (Html.textarea [Events.onInput UpdatedDesc, A.class "Form-input input-char-27", A.id "form.desc", A.rows 5][] {- aria and control id-})
        user 
        model




viewFormRegister : Auth.User -> Model -> Html Msg
viewFormRegister user model =
    Html.button [ Events.onClick PressedRegister               
                --, A.disabled (hasErrors model)
                , A.class "button button-primary mt-9"              
                ]
                [ Html.text "Register"]


formField : String -> String -> String -> Maybe String -> Html Msg -> Auth.User -> Model -> Html Msg 
formField id label hint error html user model   =

    Html.div [ A.class "form-group", A.id ("form-group" ++ id)]
    [ Html.label [A.class "form-label", A.for ("form-"++ id ++ "-field")][ Html.text label]
    , Html.span [A.class "form-hint", A.id ("form-"++id++"-hint")][ Html.text hint]
    , viewFormFieldError error
    , html
    ]


viewFormFieldError : Maybe String -> Html Msg      
viewFormFieldError error = 
    case error of 
        Nothing -> 
            Html.text ""

        Just msg -> 
            Html.span [A.class "form-error-message", A.id "form-group-name-error" ]
            [ Html.span [ A.class "sr-only"] [ Html.text "Error:"]
            , Html.text msg
            ]