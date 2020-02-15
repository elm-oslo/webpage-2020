module Pages exposing (viewAbout, viewCodeOfConduct, viewSchedule, viewSpeakers, viewTalks)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown
import Model exposing (Msg, ScheduleEntry(..))
import Route
import Schedule
import Speakers exposing (Speaker)
import Talks exposing (Talk)


viewAbout : Html a
viewAbout =
    let
        aboutUsText =
            """
## The Elm Conference With A Nordic Twist

### What to expect?

A full day conference filled with interesting talks and discussions about Elm.
The conference will feature a total of 18 speakers, with talks about a variety of topics.
For parts of the day there will be two tracks with talks running in parallel.

There  will be a conference dinner and afterparty at the venue shortly after the finishing keynote.
On the day before the conference, there will be a pre-conf event with workshops and possibly some lightning talks.
This is an excellent opportunity to mingle with other Elm enthusiasts before the conference.

### Why Elm?

Elm is a fast-growing programming language for the web that significantly improves development speed, reliability, maintainability and developer experience.
With React and Redux’s popularity on the frontend, functional programming practices are going mainstream and many are looking to Elm as the natural next step.

### Intended audience

The intended audience for the conference ranges from the curious JavaScript developer to the experienced functional programmer.

### Where?

The conference will be hosted at the beautiful **Christiania Theater** in downtown Oslo.

### Pre-Conference Event

Details aren't finalized yet, but there will be something happening on Friday night before the conference.
If travelling to Oslo, you'll want to be in town for this!

### Tickets

[Available now!](https://www.checkin.no/osloelmday)

### Food

Coffee, tea and fruit will be provided throughout the day.
The ticket price includes lunch during the event and dinner at the afterparty.
Please contact us if you have any dietary restrictions.

### Afterparty

Will be hosted at the venue. We hope to see you there!

### Contact us

- [@OsloElmDays](https://twitter.com/osloelmday)
- [hello@osloelmdays.no](mailto:hello@osloelmdays.no)

### Who are we?

The conference is organized by enthusiastic members of the Norwegian Elm community.


* Erik Wendel – [@ewndl](https://twitter.com/ewndl)
* Ingar Almklov – [@ingara](https://twitter.com/ingara)
* Kjetil Valle – [@kjetilvalle](https://twitter.com/kjetilvalle)
* Erlend Hamberg – [@ehamberg](https://twitter.com/ehamberg)
* Ragnhild Aalvik – [@aaalvik](https://twitter.com/aaalvik)
* Aksel Wester – [@akselw](https://twitter.com/akselw)
* Jonas Berdal – [@jonasberdal](https://twitter.com/jonasberdal)
* Kenneth Tiller –
* Ovin Teige –
"""
    in
    p []
        [ Markdown.toHtml [] aboutUsText ]


viewCodeOfConduct : Html a
viewCodeOfConduct =
    div []
        [ h2 []
            [ text "Code of Conduct" ]
        , text "All delegates, speakers, sponsors and volunteers are required to agree with the following code of conduct. Organizers will enforce this code throughout the event."
        , h3 []
            [ text "The Quick Version" ]
        , p []
            [ text "Our conference is dedicated to providing a harassment-free conference experience for everyone, regardless of gender, gender identity and expression, age, sexual orientation, disability, physical appearance, body size, race, ethnicity, religion (or lack thereof), or technology choices. We do not tolerate harassment of conference participants in any form. Sexual language and imagery is not appropriate for any conference venue, including talks, workshops, parties, Twitter and other online media. Conference participants violating these rules may be sanctioned or expelled from the conference without a refund at the discretion of the conference organisers." ]
        , h3 []
            [ text "The Less Quick Version" ]
        , p []
            [ text "Harassment includes offensive verbal comments related to gender, gender identity and expression, age, sexual orientation, disability, physical appearance, body size, race, ethnicity, religion, technology choices, sexual images in public spaces, deliberate intimidation, stalking, following, harassing photography or recording, sustained disruption of talks or other events, inappropriate physical contact, and unwelcome sexual attention." ]
        , p []
            [ text "Participants asked to stop any harassing behavior are expected to comply immediately." ]
        , p []
            [ text "Sponsors are also subject to the anti-harassment policy. In particular, sponsors should not use sexualized images, activities, or other material. Booth staff (including volunteers) should not use sexualized clothing/uniforms/costumes, or otherwise create a sexualized environment." ]
        , p []
            [ text "If a participant engages in harassing behavior, the conference organizers may take any action they deem appropriate, including warning the offender or expulsion from the conference with no refund." ]
        , p []
            [ text "If you are being harassed, notice that someone else is being harassed, or have any other concerns, please contact a member of conference staff immediately. Conference staff can be identified by a clearly marked \"STAFF\" shirt." ]
        , p []
            [ text "Conference staff will be happy to help participants contact hotel/venue security or local law enforcement, provide escorts, or otherwise assist those experiencing harassment to feel safe for the duration of the conference. We value your attendance." ]
        , p []
            [ text "We expect participants to follow these rules at all conference venues and conference-related social events." ]
        ]


viewSpeakers : Html a
viewSpeakers =
    let
        speakersText =
            """
## Speakers

The conference will have two tracks and we have a total of eighteen speakers booked!

There might also be a panel debate, in order to provide an arena for discussion or Q&A within the community.

Our current speaker lineup consist of world-renowned Elm experts, experienced with using Elm in production.
    """
    in
    div [] <|
        [ p [] [ Markdown.toHtml [] speakersText ] ]
            ++ List.map viewSpeaker Speakers.all


viewSpeaker : Speaker -> Html a
viewSpeaker speaker =
    article [ class "speaker" ]
        [ img [ class "speaker__image", src speaker.imageUrl ]
            []
        , div [ class "speaker__content" ]
            [ h3 [ class "speaker__name", id speaker.id ]
                [ text speaker.name ]
            , p []
                [ Markdown.toHtml [] speaker.bio ]
            ]
        ]


viewTalks : Html a
viewTalks =
    div []
        ([ h2 []
            [ text "Talks" ]
         , p []
            [ text "Oslo Elm Day will feature two tracks for parts of the day. The speaker lineup has a mix of Elm experts, international speakers and local Elm users with experience using Elm in production." ]
         , p []
            [ text "Talk descriptions and schedule will be announced soon." ]
         ]
            ++ List.map viewTalk Talks.all
        )


viewTalk : Talk -> Html a
viewTalk talk =
    article [ class "talk" ]
        [ div [ class "talk__content" ]
            [ h3 [ class "talk__name", id talk.speaker.id ]
                [ text talk.title ]
            , p []
                [ a
                    [ Route.href <| Route.Speaker talk.speaker.id
                    ]
                    [ text talk.speaker.name ]
                ]
            , p []
                [ Markdown.toHtml [] talk.abstract ]
            ]
        ]


viewSchedule : Dict String Bool -> Html Msg
viewSchedule expandableStuff =
    div []
        [ h2 []
            [ text "Schedule" ]
        , p []
            [ text "Oslo Elm Day is a single-track conference, with a speaker lineup consisting of both world-renowned Elm experts and local Elm users, experienced with using Elm in production." ]
        , Schedule.view expandableStuff
        ]


viewScheduleEntry : ScheduleEntry -> Html a
viewScheduleEntry scheduleEntry =
    case scheduleEntry of
        TalkEntry talk ->
            article [ class "speaker" ]
                [ div [ class "speaker__timeslot" ]
                    [ text <| Tuple.first talk.time ]
                , div [ class "speaker__content" ]
                    [ h3 [ class "speaker__name", id talk.speaker.id ]
                        [ a [ Route.href <| Route.Speaker talk.speaker.id ] [ text talk.speaker.name ], span [] [ text (" – " ++ talk.title) ] ]
                    , p [ style "font-style" "italic" ]
                        [ text talk.abstract ]
                    ]
                ]

        NonTalk title ( start, end ) ->
            article [ class "speaker" ]
                [ div [ class "speaker__timeslot" ]
                    [ text start ]
                , div [ class "speaker__content" ]
                    [ h3 [ class "speaker__name" ]
                        [ text title ]
                    ]
                ]

        NonTalkWithDesc title desc ( start, end ) ->
            article [ class "speaker" ]
                [ div [ class "speaker__timeslot" ]
                    [ text start ]
                , div [ class "speaker__content" ]
                    [ h3 [ class "speaker__name" ]
                        [ text title ]
                    , p [ style "font-style" "italic" ]
                        [ text desc ]
                    ]
                ]
