port module Storage exposing
    ( Storage, load
    , signIn, signOut, addItem, deleteAllItems
    , fromJson
    )

{-|

@docs Storage, save, load
@docs signIn, signOut

-}

import Domain.User as User exposing (User)
import Domain.Item as Item exposing (Item) 
import Json.Decode as Decode
import Json.Encode as Encode
import Dict
import Random 


type alias Storage =
    { user : Maybe User
    , collection : List Item
    , seed : Int
    }

type Msg = ItemStored


fromJson : Decode.Value -> Storage
fromJson json = 
    json
        |> Decode.decodeValue decoder        
        |> Result.withDefault init


toJson : Storage -> Decode.Value
toJson storage = Encode.object 
    [ ("user"
      , storage.user 
            |> Maybe.map User.encode
            |> Maybe.withDefault Encode.null
      )
    , ( "collection"
      , storage.collection
            |> Encode.list Item.encoder
          )
    ]

init : Storage
init =
    { user = Nothing
    , collection = []
    , seed = 1234567890 -- should be four ints parsed in from javascript side
    }


decoder : Decode.Decoder Storage
decoder = Decode.map3 Storage 
            (Decode.field "user" (Decode.maybe User.decoder))
            (Decode.field "collection" (Decode.list Item.decoder))
            (Decode.field "seed" (Decode.int))



    





-- UPDATING STORAGE


signIn : User -> Storage -> Cmd msg
signIn user storage =
    saveToLocalStorage { storage | user = Just user }


signOut : Storage -> Cmd msg
signOut storage =
    saveToLocalStorage { storage | user = Nothing }

addItem : Item -> Storage -> Cmd msg
addItem item storage =
    saveToLocalStorage { storage | collection = item :: storage.collection}
 
deleteAllItems : Storage -> Cmd msg
deleteAllItems storage = 
    saveToLocalStorage { storage | collection = []}

getItemsAsDict : (Dict.Dict String Item)
getItemsAsDict = Dict.fromList 
    [ ("123456", (Item "123456" "My first dict item" "and its description") ) 
    ]

-- PORTS


saveToLocalStorage : Storage -> Cmd msg
saveToLocalStorage =
    toJson >> save_


port save_ : Decode.Value -> Cmd msg


load : (Storage -> msg) -> Sub msg
load fromStorage =
    load_ (fromJson >> fromStorage)


port load_ : (Decode.Value -> msg) -> Sub msg
