module Talks exposing (Slottime, Talk, all)

import Speakers exposing (Speaker)


type alias Slottime =
    ( String, String )


type alias Talk =
    { title : String
    , abstract : String
    , speaker : Speaker
    , time : Slottime
    }


all : List Talk
all =
    []
