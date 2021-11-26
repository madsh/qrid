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
    { newId : String
    ,  newIdStatus : UuidStatus
    , submitted : Bool
    , isValid : Bool
    }

type UuidStatus 
    = EmptyUuid
    | ValidUuid
    | InvalidUuid  

init : ( Model, Cmd Msg )
init =
    ( { newId = ""
        , newIdStatus = EmptyUuid 
        , submitted = False
        , isValid = False
    }, Cmd.none )



-- UPDATE

type Msg
    = UpdatedUUID String
    | SubmittedForm


update : Storage -> Msg -> Model -> ( Model, Cmd Msg )
update storage msg model =
    case msg of
        UpdatedUUID uuid ->
            ( validate { model | newId = uuid }
            , Cmd.none
            )

        SubmittedForm ->
            ( { model | submitted = True}
            , Cmd.none
            )


validate model = 
    let
        newIdStatus = 
            if model.newId == "" then 
                EmptyUuid 
            else if model.newId == "1" then                
                InvalidUuid
            else 
                ValidUuid


        modelValid = 
            if newIdStatus == ValidUuid then 
                True 
            else    
                False
    in
    { model 
        | newIdStatus = newIdStatus
        , isValid = modelValid

    }

-- VIEW

view : Auth.User -> Model -> View Msg
view user model =
    { title = "qrid - your items"
    , body =
        UI.layout [
            Html.main_ [ A.class "container page-container", A.id "main-content"] 
            [ Html.h1 [ A.class ""] [ Html.text "Register an item" ]
            , Html.p [ A.class "font-lead"] [ Html.text "Here you can add a new item to your collection"]
            , Html.div [A.class "my-3", A.id "startButtons"] 
              [ Html.button [ A.class "button button-primary"] [ Html.text "Take a photo"]
              , Html.button [ A.class "button button-primary"] [ Html.text "Type it in"]
              ]
            , viewForm user model            
            ]
         ]
        
    }


viewForm : Auth.User -> Model -> Html Msg
viewForm user model =
    Html.form [ A.class "form-div"]
    [ viewFormUUID user model  
    , viewFormRegister user model
    ]

viewFormUUID : Auth.User -> Model -> Html Msg
viewFormUUID user model =
    Html.div [ A.class "form-group", A.id "form-group-uuid"] [
    Html.label [A.class "form-label", A.for "form-uuid-field"][ Html.text "UUDI"]
      , Html.span [A.class "form-hint", A.id "hint"][ Html.text "What is the univerally unique id you want to register this item under?"]
      , Html.span [A.class "form-error-message", A.id "form-group-uuid-error"]
        [ Html.span [A.class "sr-only"][Html.text "Error:"]
        , Html.text "You can't register an item without an UUID."
        , Html.div [A.class "form-input-wrapper form-input-wrapper-prefeix"]
          [ Html.div [A.class "form-input-prefix"][ Html.text "UUID"]
          , Html.input [ A.id "form-uuid-field"
                       , A.name "uuid-field"
                       , A.required True
                       , A.class "form-input input-width-xl"
                       , A.value model.newId
                       , Events.onInput UpdatedUUID
                       ] []
          , Html.span [A.class "ml-9"][ Html.text (if model.isValid then "valid" else "invalid")] 
          ]     
        ]
      ]
      

viewFormRegister : Auth.User -> Model -> Html Msg
viewFormRegister user model =
    Html.button [ A.disabled (not model.isValid)
                , A.class "button button-primary mt-9"                
                ]
                [ Html.text "Register"]