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
import Json.Decode exposing (int)



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
    , ready : Bool
    , newIdError : Maybe String
    , newIdSource : IdSource
    , nameError : Maybe String    
    , descError : Maybe String
    , createError : Maybe String
    , createSucces : Maybe String
    , showErrors : Bool    
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
              , ready = False 
              , newIdError = Nothing
              , newIdSource = FromUrl
              , nameError = Nothing      
              , createError = Nothing   
              , createSucces = Nothing      
              , descError = Nothing
              , showErrors = False     
              , pageTitle = "new from tag"
              }
              , Cmd.none 
            )

    Nothing -> 
        ( { item = { qrid = "tap here to type in, or click generate below", name = "", description = ""}
              , ready = False 
              , newIdError = Nothing
              , newIdSource = Undecided
              , nameError = Nothing      
              , createError = Nothing
              , createSucces = Nothing
              , descError = Nothing
              , showErrors = False
              , pageTitle = "new no tag yet"
              }
              , Cmd.none 
            )



-- UPDATE


type Msg
    = UpdatedUUID String
    | FocusedUUID
    | UpdatedName String
    | PressedGenerate
    | PressedRegister
    | ItemCreated (Result Http.Error Item)
    


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

                _ = Debug.log "Focusing and updating source to Manual :" model.item.qrid
                
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

        UpdatedName value ->
           let
                preItem = model.item
                updatedItem = 
                    { preItem | name = value }                                    

                _ = Debug.log "Updating Name to : " value

                -- a change to validate if we all ready have an error
            in            
            ( { model |  item = updatedItem } , Cmd.none )     

        PressedRegister -> 
            ( (validate {model | showErrors = True})
            , if (model.ready) then (storeItemRemote model) else Cmd.none                            
            )



        ItemCreated (Ok item) ->
            ( {model | item = item, createError = Nothing, createSucces = Just ("Saved item " ++ item.qrid)}
              , Cmd.none
        --    , Browser.Navigation.load (Route.toHref Route.Items)
            )

        ItemCreated (Err error) ->
            ( {model | createError = Just (buildHttpErrorMessage error), createSucces = Nothing}, Cmd.none)    




validate : Model -> Model 
validate model = 
    let 
        nameEr = if ((String.length model.item.name) < 5) 
                 then Just (("Name was " ++ (String.fromInt(String.length model.item.name))) ++ " long : " ++ "Names must be longer than 5")
                 else Nothing



        ready = if (nameEr == Nothing) then True else False                 

        _ = Debug.log ("Validated (is ready) " ++ model.item.qrid) ready
    in 
    { model |
        nameError = nameEr
        ,ready = ready
    }





storeItemRemote: Model -> Cmd Msg 
storeItemRemote model = 
    let
        _ = Debug.log "Storing  "  model.item.qrid
    in
    Http.post 
      { url = "http://localhost:3000/items"
      , body = Http.jsonBody (itemEncoder model.item)
      , expect = Http.expectJson ItemCreated itemDecoder      
    }    



buildHttpErrorMessage : Http.Error -> String
buildHttpErrorMessage httpError =
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
            , if (model.showErrors) then (Html.text "Showing Errors") else (Html.text "Not showing Errors")
            , viewPageSucces model.createSucces
            , viewPageError model.createError
            , viewForm user model request           
            --, viewFormRegister user model
            ]
         ]
        
    }


viewForm : Auth.User -> Model -> Request -> Html Msg 
viewForm user model request =
    Html.div [ A.class "form-div"]
    [ viewFormUUID user model request  
    , viewFormName user model
    --, viewFormDesc user model
    , Html.button [ Events.onClick PressedRegister, A.class "button button-primary mt-9"][ Html.text "Register"]
    ]    

viewFormUUID : Auth.User -> Model -> Request -> Html Msg
viewFormUUID user model request =
    let
        qrid = ""
    in
    Html.div [ A.class "form-group", A.id "form-uuid-group"] [
    Html.label [A.class "form-label", A.for "form-uuid-input"][ Html.text "UUID"]
      , Html.span [A.class "form-hint", A.id "hint1"][ Html.text "What is the UUID you want to register this item under?"]
      --, Html.span [A.class "form-hint", A.id "hint2"][ Html.text "A UUID has the form of 88c973e3-f83f-4360-a320-d8844c365130"]
      --, viewFormUUIDError model
      , Html.div [A.class "form-input-wrapper form-input-wrapper-prefeix"]
        [ Html.div [A.class "form-input-prefix"][ Html.text (if (True) then "✔" else "UUID")]
        , Html.input [ A.id "form-uuid-input"
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


viewFormName : Auth.User -> Model -> Html Msg
viewFormName user model =
    Html.div [ A.class "form-group", A.id ("form-name-group")]
    [ Html.label [A.class "form-label", A.for ("form-name-input")][ Html.text "Name"]
    , Html.span [A.class "form-hint", A.id ("form-name-hint")][ Html.text "A friendly name for your item"]
    , (viewFieldError model.nameError)
    , Html.input [Events.onInput UpdatedName, A.value model.item.name , A.class "form-input  input-width-xl", A.id "form.name", A.type_ "text"][] {- aria and control id-}
    ]


viewFieldError : Maybe String -> Html Msg
viewFieldError maybeError = 
    case maybeError of 
        Nothing -> Html.text ""

        Just error -> 
            Html.span [ A.class "form-error-message", A.id "form-name-error"]
            [ Html.span [A.class "sr-only"][ Html.text "Error:"]
            , Html.text error
            ]      


viewPageError : Maybe String -> Html Msg  
viewPageError maybeError = 
    case maybeError of 
        Nothing -> Html.text ""

        Just error -> 
            Html.div[A.class "alert alert-error"]
            [ Html.div [A.class "alert-body"] 
              [ Html.p [A.class "alert-heading"] [Html.text "Could not save your item on our servers" ]
              , Html.p [A.class "alert-text"] [Html.text ("Error: " ++ error)]
              ]
           ]


viewPageSucces : Maybe String -> Html Msg  
viewPageSucces maybeSucces = 
    case maybeSucces of 
        Nothing -> Html.text ""

        Just error -> 
            Html.div[A.class "alert alert-success"]
            [ Html.div [A.class "alert-body"] 
              [ Html.p [A.class "alert-heading"] [Html.text "Your item was saved on our server" ]
              , Html.p [A.class "alert-text"] [Html.text ("Success: " ++ error)]
              ]
           ]


