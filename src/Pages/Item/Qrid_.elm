module Pages.Item.Qrid_ exposing (Model, Msg, page)

import Auth
import Gen.Params.Item.Qrid_ exposing (Params)
import Page
import Request
import Shared
import View exposing (View)
import Storage exposing (Storage)

import Http
import Json.Decode as Decode
import Domain.Item exposing (Item, itemsDecoder)
import RemoteData exposing (RemoteData, WebData)


import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Html.Attributes as A exposing (id, type_)
import UI

page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared request =
    Page.protected.element <|
        \user ->
            { init = init request.params.qrid
            , update = update request.params.qrid shared.storage
            , view = view user request.params.qrid
            , subscriptions = \_ -> Sub.none
            }

-- INIT


-- MODEL
type alias Model =
    { items : WebData (List Item) }



init : String -> ( Model, Cmd Msg )
init id =
    ( { items = RemoteData.Loading}, httpGetItem id)




-- UPDATE
httpGetItem : String -> Cmd Msg
httpGetItem id = 
    Http.get 
        { url = "http://localhost:3000/items/?qrid=" ++ id 
        , expect = itemsDecoder
            |> Http.expectJson (RemoteData.fromResult >> DataRecieved )
        }



type Msg
    = FetchItems 
    | DataRecieved (WebData (List Item))


update : String -> Storage -> Msg -> Model -> ( Model, Cmd Msg )
update id storage msg model =
    case msg of
        FetchItems ->
            ( {model | items = RemoteData.Loading}, httpGetItem id)
        
        DataRecieved response ->
            ( { model | items = response}, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Auth.User -> String -> Model -> View Msg
view user param model =
    { title = "qrid - your items"
    , body =
        UI.layout user  
        [ Html.main_ [ A.class "container page-container", A.id "main-content"]  
          [viewItemOrError model param ]                  ]
    }

    
viewItemOrError : Model -> String -> Html Msg 
viewItemOrError model id = 
    case model.items of
        RemoteData.NotAsked -> Html.text "not asked"
        RemoteData.Loading -> Html.div [class "m-9"][Html.text ("Looking up id from url " ++ id)]
        RemoteData.Failure httpError -> viewError (buildErrorMessage httpError)
        RemoteData.Success items -> viewItem items

        
viewError : String -> Html Msg 
viewError errorMessage = 
    let 
        errorHeading = "Couldn't fetch data at this time"
    in
    Html.div[class "alert alert-error"]
    [
        Html.div [class "alert-body"] 
        [ Html.p [class "alert-heading"] [Html.text errorHeading ]
        , Html.p [class "alert-text"] [Html.text ("Error: " ++ errorMessage)]
        ]
    ]

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

viewItem : (List Item) -> Html Msg
viewItem list =
    case List.head list of 
        Nothing -> Html.div[class "alert alert-error"]
             [ Html.div [class "alert-body"] 
               [ Html.p [class "alert-heading"] [Html.text "Could not find item" ]
               , Html.p [class "alert-text"] [Html.text ("Error: " ++ "...")]
               ]
             ]

        Just item -> Html.div [] 
                     [ Html.div [ class "small-id mb-4"][Html.text item.qrid]
                     , Html.h1 [][Html.text item.name]
                     , Html.p [ class "font-lead"] [ Html.text item.description]                        
                     , Html.ul [ class "accordion accordion-bordered accordion-multiselectable"][viewBasics item]
                     ]



viewBasics : Item -> Html Msg
viewBasics item = 
    Html.li []
    [ Html.h3 []
      [ Html.button [class "accordion-button"]
        [ Html.b [][ Html.text "The basics. "]
        , Html.text "One (1!) mandatory field, and a few to add meaning."
        ]      
      ]
    , Html.div [ class "accordion-content"]
      [ Html.div [][Html.text "Her kommer der en form. Kan den måske genbruges?"]
      ]
    ]

            



{-       [] -> Html.div[class "alert alert-error"]
             [ Html.div [class "alert-body"] 
               [ Html.p [class "alert-heading"] [Html.text "Could not find item" ]
               , Html.p [class "alert-text"] [Html.text ("Error: " ++ "...")]
               ]
             ]

       [ elem ] -> Html.div [ class "table--responsive-scroll mt-7"][Html.text "got one"]
   
        items -> Html.div[class "alert alert-error"]
             [ Html.div [class "alert-body"] 
               [ Html.p [class "alert-heading"] [Html.text "Could not find item" ]
               , Html.p [class "alert-text"] [Html.text ("Error: " ++ "...")]
               ]
             ]



         [ Html.table [class "table table--compact table--borderless"]
      [ Html.tbody []
        [ Html.tr []
          [ Html.th [class "w-percent-md-30"][Html.text "Navn"]
          , Html.td [][Html.text "det der navn"]
          , Html.td [][Html.text "..."]
          ]
        , Html.tr []
          [ Html.th [class "w-percent-md-30"][Html.text "UUID"]
          , Html.td [][Html.text "000000--0-000-0-"]
          , Html.td [][Html.text "..."]
          ]
        , Html.tr []
          [ Html.th [class "w-percent-md-30"][Html.text "Description"]
          , Html.td [][Html.text "Den noget længere beskrivelse som ortæller den hjerhm <mhrejlh ena,rbaelær kjæ re"]
          , Html.td [][Html.text "..."]
          ]    
        ]

      ]
    ]

    -}