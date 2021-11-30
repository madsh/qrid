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





layout : Auth.User -> Request -> List (Html msg) -> List (Html msg)
layout user request children =
    [   header user request "qrid pro quo" ""
        , Html.main_ [ Attr.class "page-container pt-0", Attr.id "main-content"] children
    ]


h1 : String -> Html msg
h1 label =
    Html.div [ Attr.class "col-12 col-lg-7"]
    [ Html.h1 [] [ Html.text label ]    
    ]


header : Auth.User -> Request -> String -> String -> Html msg
header user request portalName solutionName =
    Html.header [Attr.class "header"]             
        [ headerPortal user portalName
        , headerSolution solutionName request
        --, headerNavigation request  
        ]

headerPortal : Auth.User -> String -> Html msg
headerPortal user portalName =
    Html.div [ Attr.class "portal-header portal-header-compact"][
        Html.div [Attr.class "portal-header-inner container"]
        [ Html.a [Attr.href "#", Attr.class "logo alert-leave"][Html.span [Attr.class ""][ Html.text portalName]]
        , Html.button [Attr.class "button button-secondary button-menu-open js-menu-open ml-auto d-print-none"][ Html.text "Menu"]
        , Html.div[Attr.class "portal-info"][
                Html.p [Attr.class "user"][
                    Html.span [Attr.class "username"][
                        Html.text user.name
                    ]
                ]
                -- , Html.button [Attr.class "button button-secondary alert-leave d-print-none"][Html.text "Log af"]
            ]
        ]
    ] 

headerSolution : String -> Request -> Html msg
headerSolution appName request =
    Html.div [ Attr.class "solution-header"][
        Html.div [Attr.class "solution-header-inner container"]
            [ Html.div [Attr.class "d-flex align-items-center"]
            [ Html.a [ Attr.href "/", Attr.title appName][ Html.text appName]
            --, Html.a [ Attr.class "mynav displayheading-2 mr-4", Attr.href "scanner.html"][ Html.text "Scan1"] 
            , Html.a [ Attr.class "mynav displayheading-2 mr-4", Attr.href (Route.toHref Route.Items)][Html.text "Items"]
            , Html.a [ Attr.class "mynav displayheading-2 mr-4", Attr.href (Route.toHref Route.Item)][Html.text "Add1"]                                                           
            , Html.a [ Attr.class "mynav displayheading-2 text-negative mr-4", Attr.href (Route.toHref Route.Settings)][Html.text "Settings"]                                                             
            ]
            ]      
        ] 
    

headerNavigation : Request -> Html msg
headerNavigation request  =
    Html.nav [ Attr.class "nav d-none d-lg-block"] [ {- missing aria-label -}
        Html.div [ Attr.class "navbar navbar-primary"] [ 
            Html.div [ Attr.class "navbar-inner container"][
                Html.ul [ Attr.class "nav-primary"]                    
                    [ headerNavigationItem "Items" Route.Items request.route
                    , headerNavigationItem "Add" Route.Item request.route  
                    , headerNavigationItem "Settings" Route.Settings request.route                    
                    ]
                ] {- mangler role attr -}
            ]
        ]
    


headerNavigationItem : String -> Route -> Route-> Html msg
headerNavigationItem label route current =
    Html.li [ Attr.class ( if (route == current) then ("current") else (""))][ {- Missing role -}
        Html.a [ Attr.href (Route.toHref route), Attr.class "nav-link" ][
            Html.span [][Html.text label]
        ] {- missing role -}
    ] 
