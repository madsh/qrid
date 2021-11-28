module Domain.Item exposing (Item, ItemId, itemDecoder, itemsDecoder, itemEncoder) 

import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required, optional)
import Json.Encode as Encode exposing (Value)

type alias Item = 
    { qrid : String
    , name : String
    , description : String  }

type ItemId
    =  ItemId Int

itemsDecoder : Decoder (List Item)
itemsDecoder = list itemDecoder          

itemDecoder : Decoder Item 
itemDecoder = 
    Decode.succeed Item        
        |> required "qrid" string
        |> required "name" string        
        |> optional "description" string " - no description - "



itemEncoder : Item -> Encode.Value
itemEncoder item =
    Encode.object
        [ ( "id", Encode.string item.qrid )
        , ( "qrid", Encode.string item.qrid )
        , ( "name", Encode.string item.name )
        , ( "description", Encode.string item.description )        
        ]

