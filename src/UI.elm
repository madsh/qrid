module UI exposing (h1, layout)

import Gen.Route as Route exposing (Route)
import Html exposing (Html)
import Html.Attributes as Attr
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
        , Html.main_ [ Attr.class "page-container pt-0", Attr.id "main-content"] children
    ]


h1 : String -> Html msg
h1 label =
    Html.div [ Attr.class "col-12 col-lg-7"]
    [ Html.h1 [] [ Html.text label ]    
    ]


header : Auth.User -> String -> Html msg
header user portalName  =
    Html.header [Attr.class "header"]             
        [ headerPortal user portalName
        , headerSolution 
        --, headerNavigation request  
        ]

headerPortal : Auth.User -> String -> Html msg
headerPortal user portalName =
    Html.div [ Attr.class "portal-header portal-header-compact"][
        Html.div [Attr.class "ikkeportal-header-inner container"]
        [ Html.div [Attr.id "topbox"]
          [ Html.div [Attr.class "topleft"][Html.a [Attr.class "mynav",Attr.href (Route.toHref Route.Home_)][Html.text portalName]]
          , Html.div [Attr.class "topcenter"][Html.text "*"]    
          , Html.div [Attr.class "topright"][Html.text user.name]    
          ]        
        ]
    ] 

headerSolution : Html msg
headerSolution =
    Html.div [ Attr.class "solution-header"][
        Html.div [Attr.class "solution-header-inner container"]
            [ Html.div [Attr.class "d-flex align-items-center"]
            [ Html.a [ Attr.class "mynav mr-4", Attr.href (Route.toHref Route.Items)][Html.text "Items"]            
            , Html.a [ Attr.class "mynav mr-4", Attr.href (Route.toHref Route.NewItem)][Html.text "Add"] 
            , Html.a [ Attr.class "mynav mr-4", Attr.href (Route.toHref Route.Settings)][Html.text "Settings"]                                                                                     
            ]
            ]      
        ] 
    
