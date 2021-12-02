module Domain.QRID exposing (generate, parse)


import UUID exposing (UUID, Error)



generate : UUID
generate = UUID.forName "myap" UUID.dnsNamespace


parse : String -> Result String String
parse input = 
    if (String.length input < 24 ) 
        then Err "must be over 24"
    else 
        Ok input

