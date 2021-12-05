module Domain.Item exposing (Item, ItemId, decoder, encoder, itemsDecoder) 

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
itemsDecoder = list decoder          

decoder : Decoder Item 
decoder = 
    Decode.succeed Item        
        |> required "qrid" string
        |> required "name" string        
        |> optional "description" string " - no description - "



encoder : Item -> Encode.Value
encoder item =
    Encode.object
        [ ( "id", Encode.string item.qrid )
        , ( "qrid", Encode.string item.qrid )
        , ( "name", Encode.string item.name )
        , ( "description", Encode.string item.description )        
        ]

