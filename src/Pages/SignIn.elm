module Pages.SignIn exposing (Model, Msg, page)

import Gen.Params.SignIn exposing (Params)
import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events as Events
import Page
import Request
import Shared
import Storage exposing (Storage)
import UI
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init
        , update = update shared.storage
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { name : String }


init : ( Model, Cmd Msg )
init =
    ( { name = "" }
    , Cmd.none
    )



-- UPDATE


type Msg
    = UpdatedName String
    | SubmittedSignInForm


update : Storage -> Msg -> Model -> ( Model, Cmd Msg )
update storage msg model =
    case msg of
        UpdatedName name ->
            ( { model | name = name }
            , Cmd.none
            )

        SubmittedSignInForm ->
            ( model
            , Storage.signIn { name = model.name } storage
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Sign in"
    , body = 
        [ Html.header [][]
        , Html.main_ [ Attr.class "container page-container", Attr.id "main-contente"]
            [ Html.h1 [][Html.text "UUID Login"]
            , Html.p [ Attr.class "font-lead"][Html.text "This is the ultra-simple, hard-to-remember, not-so-secure login."]
            , viewForm model
        ]
    ]
        
    }

viewForm : Model -> Html Msg
viewForm model =
    Html.form [ Attr.class "form-group signin-form", Events.onSubmit SubmittedSignInForm]
    [ Html.label [ Attr.class "form.label", Attr.for "signin-form"][ Html.text "Login to register og manage your items"]
    , Html.span [Attr.class "form-hint", Attr.id "signin-form"][ Html.text "Use your UUID :-)"]
    , Html.span [Attr.class "form-error-message", Attr.id "signin-form-error"]
        [ Html.span[Attr.class "sr-only"][Html.text "Error:"
        , Html.text "UUID is not registered as a user"
        ]
    , Html.input [ Attr.class "form-input"
                 , Attr.required True
                 , Attr.id "sign-in"
                 , Attr.value model.name
                 , Attr.name "user-name"
                 , Attr.type_ "text"
                 , Events.onInput UpdatedName
                 ][]
    , Html.button [ Attr.class "button button-primary mt-6", Attr.disabled (String.isEmpty model.name)][ Html.text "Login"]
    , Html.a [ Attr.href "signup.html"][ Html.text "or sign up"]            {- replace with route -}
    ]
    ]


{-
UI.layout
            [ Html.form [ Events.onSubmit SubmittedSignInForm ]
                [ Html.label []
                    [ Html.span [] [ Html.text "Name" ]
                    , Html.input
                        [ Attr.type_ "text"
                        , Attr.value model.name
                        , Events.onInput UpdatedName
                        ]
                        []
                    ]
                , Html.button [ Attr.disabled (String.isEmpty model.name) ]
                    [ Html.text "Sign in" ]
                ]
            ]
-}