module Domain.Item exposing (Item, ItemId, itemDecoder, itemsDecoder) 

import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required, optional)

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

