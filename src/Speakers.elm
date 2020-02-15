module Speakers exposing (Speaker, all, promoted)


all : List Speaker
all =
    []


promoted : List Speaker
promoted =
    []


type alias Speaker =
    { id : String
    , name : String
    , bio : String
    , imageUrl : String
    }
