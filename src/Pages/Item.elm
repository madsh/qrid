module Pages.Item exposing (Model, Msg, page, view)

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
import QRID
import UUID exposing (Error)


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
    { newId : String    
    , newIdError : String
    , name : String
    , nameError : String
    , submitted : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( { newId = ""      
      , newIdError = ""
      , name = ""
      , nameError = ""
      , submitted = False
      }
    , Cmd.none 
    )



-- UPDATE

type Msg
    = UpdatedUUID String
    | UpdatedName String
    | BlurName
    | RegisterPressed
    | TakePhotoPressed
    | TypeInPressed
    | GeneratePressed



update : Storage -> Msg -> Model -> ( Model, Cmd Msg )
update storage msg model =
    case msg of
        UpdatedUUID idvalue ->
            ( validateUUID { model | newId = idvalue}
            , Cmd.none
            )

        UpdatedName value ->
            ( { model | name = value}
            , Cmd.none
            )

        BlurName ->
            ( validateName  model
            , Cmd.none
            )
        TakePhotoPressed ->
            ( validateUUID { model | newId = "scanned"}
            , Cmd.none
            )

        TypeInPressed ->
            ( validateUUID { model | newId = "00000000-0000-0000-0000-000000000000"}
            , Cmd.none
            )

        GeneratePressed ->
            ( validateUUID { model | newId = UUID.toString QRID.generate}
            , Cmd.none
            )

        RegisterPressed ->
            ( (validate { model | submitted = True } )
            , Cmd.none
            )


validate : Model -> Model
validate model  = 
    validateName model




validateName: Model -> Model
validateName model = 
    if (String.length model.name) < 5 then 
        { model | nameError = "Names must be longer than 5" }
    else 
        { model | nameError = ""}

validateUUID: Model -> Model
validateUUID model = 
     if (String.length model.newId) < 8 then 
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
-- VIEW

view : Auth.User -> Request -> Model -> View Msg
view user request model =
    { title = "qrid - your items"
    , body =
        UI.layout user request  [
            Html.main_ [ A.class "container page-container", A.id "main-content"] 
            [ Html.h1 [ A.class ""] [ Html.text "Register an item" ]
            , Html.p [ A.class "font-lead"] [ Html.text "Here you can add a new item to your collection"]
            , Html.div [A.class "my-3", A.id "startButtons"] 
              [ Html.button [ Events.onClick TakePhotoPressed, A.class "button button-primary"] [ Html.text "Take a photo"]
              , Html.button [ Events.onClick TypeInPressed,  A.class "button button-primary"] [ Html.text "Type it in"]
              , Html.button [ Events.onClick GeneratePressed, A.class "button button-secondary"] [ Html.text "Generate"]
              ]
            , viewForm user model            
            , viewFormRegister user model
            ]
         ]
        
    }


viewForm : Auth.User -> Model -> Html Msg
viewForm user model =
    Html.form [ A.class "form-div"]
    [ viewFormUUID user model  
    , viewFormName user model
    , viewFormDesc user model
    ]

viewFormUUID : Auth.User -> Model -> Html Msg
viewFormUUID user model =
    Html.div [ A.class "form-group", A.id "form-group-uuid"] [
    Html.label [A.class "form-label", A.for "form-uuid-field"][ Html.text "UUID"]
      , Html.span [A.class "form-hint", A.id "hint1"][ Html.text "What is the universally unique id you want to register this item under?"]
      , Html.span [A.class "form-hint", A.id "hint2"][ Html.text "A UUID has the form of 88c973e3-f83f-4360-a320-d8844c365130"]
      , viewFormUUIDError user model
      , Html.div [A.class "form-input-wrapper form-input-wrapper-prefeix"]
        [ Html.div [A.class "form-input-prefix"][ Html.text (if (((String.length model.newId) > 7) && (String.length model.newIdError < 1)) then "✔" else "UUID")]
        , Html.input [ A.id "form-uuid-field"
                     , A.name "uuid-field"                     
                     , A.class "form-input input-width-xl"
                     , A.value model.newId
                     , Events.onInput UpdatedUUID 
                     ] []
        , Html.span [A.class "ml-9"][ ] 
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
        (Html.input [A.value model.name, Events.onInput UpdatedName, Events.onBlur BlurName,  A.class "Form-input  input-char-27", A.id "form.name", A.type_ "text"][] {- aria and control id-})
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
                , Events.onClick RegisterPressed               
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
