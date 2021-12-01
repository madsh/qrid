module Pages.SignUp exposing (Model, Msg, page)


import Gen.Params.SignIn exposing (Params)
import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events as Events
import Page
import Request
import Shared
import Storage exposing (Storage)
import View exposing (View)
import Gen.Route as Route exposing (Route)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { username : String }


init : ( Model, Cmd Msg )
init =
    ( { username = ""
    }, Cmd.none )



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Cmd.none )



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
        , Html.main_ [ Attr.class "container page-container", Attr.id "main-content"]
            [ Html.h1 [][Html.text "Sign up"]
            , Html.p [ Attr.class "font-lead"][Html.text "This is a special sign up. You don't have to choose a username, pick a password, give us your email or phone number. All you need is ... an UUID. But don't share it and don't forget it!"]
            , viewForm model
        ]
    ]
        
    }

viewForm : Model -> Html Msg
viewForm model =
    Html.form [ Attr.class "form-group signup-form"]
    [ Html.label [ Attr.class "form-label", Attr.for "signup-form"][ Html.text "Sign up to register and manage your items"]
    , Html.span [Attr.class "form-hint", Attr.id "signin-hint"][]
    , Html.div [Attr.class "form-input-wrapper form-input-wrapper--prefix mt-3"]
      [ Html.div [Attr.class "form-input-prefix"][Html.text "UUID"]
      , Html.input [Attr.class "form-input input-width-l", Attr.id "username"][]     
      ]
    , Html.button [ Attr.class "button button-primary mt-6", Attr.disabled (String.isEmpty "")][ Html.text "Use this"]
    , Html.button [ Attr.class "button button-secondary", Attr.disabled (String.isEmpty "")][ Html.text "Show me a new one"]
    ]    


{-
    Html.form [ Attr.class "form-group signup-form"]
    [ Html.label [ Attr.class "form-label", Attr.for "signup-form"][ Html.text "Sign up to register and manage your items"]
    , Html.span [Attr.class "form-hint", Attr.id "signin-form"][]
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
    , Html.a [ Attr.href (Route.toHref Route.SignUp), Attr.class "ml-3"][ Html.text "or sign up"]            {- replace with route -}
    ]
    ]
-}