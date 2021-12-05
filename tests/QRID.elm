module QRID exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)

import Domain.QRID as Qrid exposing (generate, parse, toString)




generatorTest = 
    describe "Generating id's for the qrid application, based on UUID " 
    [ test "length of QRIDs" <|
        \_ -> 
            let 
                id = Qrid.toString Qrid.generate
            in 
                Expect.equal (String.length id) 36
    ]




parseTest = 
    describe "Parsing id's for the qrid application, based on UUID"
    [ test "A number of bad strings are tested" <|
        \_ -> 
            Expect.err (Qrid.parse "bad000-xx-23--2323")
    , test "A number of good strings are tested" <|
        \_ -> 
            Expect.ok (Qrid.parse "88c973e3-f83f-4360-a320-d8844c365130")
    ]    










goodStrings = 
    [ "", "", ""]

badStrings = 
    [ "", ""]