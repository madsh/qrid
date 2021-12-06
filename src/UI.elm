module UI exposing (h1, layout, layoutEmpty, functionLink)

import Gen.Route as Route exposing (Route)
import Html exposing (Html)
import Html.Attributes exposing (..)
import Html.Events as Events
import Shared exposing (..)
import Auth
import Shared
import Request exposing (Request)
import Url.Builder exposing (absolute)
import Html exposing (Attribute)





layout : Auth.User -> List (Html msg) -> List (Html msg)
layout user children =
    [   header user "qrid.info" 
        , Html.main_ [ class "page-container pt-0", id "main-content"] children
    ]


layoutEmpty : Auth.User -> List (Html msg) -> List (Html msg)
layoutEmpty user children =
    [  headerEmpty user "qrid scanner"
    , Html.main_ [ class "page-container pt-0", id "main-content"] children
    ]    


h1 : String -> Html msg
h1 label =
    Html.div [ class "col-12 col-lg-7"]
    [ Html.h1 [] [ Html.text label ]    
    ]


header : Auth.User -> String -> Html msg
header user portalName  =
    Html.header [class "header"]             
        [ headerPortal user portalName
        , headerSolution 
        --, headerNavigation request  
        ]


headerEmpty : Auth.User -> String -> Html msg
headerEmpty user portalName  =
    Html.header [class "header"][]

headerPortal : Auth.User -> String -> Html msg
headerPortal user portalName =
    Html.div [ class "portal-header portal-header-compact"][
        Html.div [class "ikkeportal-header-inner container"]
        [ Html.div [id "topbox"]
          [ Html.div [class "topleft"][Html.a [class "mynav",href (Route.toHref Route.Home_)][Html.text portalName]]
          , Html.div [class "topcenter"][Html.text "*"]    
          , Html.div [class "topright"][Html.text user.name]    
          ]        
        ]
    ] 

headerSolution : Html msg
headerSolution =
    Html.div [ class "solution-header"][
        Html.div [class "solution-header-inner container"]
            [ Html.div [class "d-flex align-items-center"]
            [ Html.a [ class "mynav mr-4", href (Route.toHref Route.Items)][Html.text "Items"]            
            , Html.a [ class "mynav mr-4", href (Route.toHref Route.NewItem)][Html.text "Add"] 
            , Html.a [ class "mynav mr-4", href (Route.toHref Route.Scanner)][Html.text "Scan"] 
            , Html.a [ class "mynav mr-4", href (Route.toHref Route.Settings)][Html.text "Settings"]                                                                                     
            ]
            ]      
        ] 
    


functionLink : String -> String -> Attribute msg -> Html msg
functionLink text icon event =
    Html.a [event, class "function-link"]
    [
        Html.text text
    ]