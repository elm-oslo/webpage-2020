module Model exposing
    ( Model
    , Msg(..)
    , Page(..)
    , ScheduleEntry(..)
    , Sponsor
    , SponsorTier(..)
    , sponsors
    )

import Browser
import Browser.Navigation as Nav
import Dict exposing (Dict)
import Route exposing (Route)
import Speakers exposing (Speaker)
import Talks exposing (Slottime, Talk)
import Url


type Page
    = About
    | Speakers
    | Schedule
    | Talks
    | CodeOfConduct


type Msg
    = TicketButtonMouseEnter
    | TicketButtonMouseLeave
    | NavigateTo Route
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | ExpandableItemClicked String
    | NoOp


type alias Model =
    { navKey : Nav.Key
    , page : Maybe Page
    , expandableStuff : Dict String Bool
    }


type SponsorTier
    = Silver
    | Gold
    | Platinum


type alias Sponsor =
    { name : String
    , url : String
    , imageUrl : String
    , tier : SponsorTier
    }


type ScheduleEntry
    = TalkEntry Talk
    | NonTalk String Slottime
    | NonTalkWithDesc String String Slottime


sponsors : List Sponsor
sponsors =
    []
