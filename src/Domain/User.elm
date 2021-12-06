module Domain.User exposing (User, decoder, encode)

import Json.Decode as Json
import Json.Encode as Encode


type alias User =
    { name : String
    , userRemote : Bool
    }


decoder : Json.Decoder User
decoder =
    Json.map2 User
        (Json.field "name" Json.string)
        (Json.field "remoteStorage" Json.bool)


encode : User -> Json.Value
encode user =
    Encode.object
        [ ( "name", Encode.string user.name )
        , ( "remoteStorage", Encode.bool user.userRemote )
        ]
