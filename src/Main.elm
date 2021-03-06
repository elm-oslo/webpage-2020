module Main exposing (Model, Msg(..), init, main, update, view)

import Accessibility exposing (..)
import Browser
import Html exposing (Html)
import Html.Attributes exposing (class, disabled, href, id, placeholder, type_)
import Html.Events exposing (onClick, onInput, onSubmit)
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Markdown
import RemoteData exposing (RemoteData(..), WebData)
import Validate



---- MODEL ----


type alias Model =
    { email : String
    , validationError : Maybe String
    , submitStatus : WebData ()
    }


init : ( Model, Cmd Msg )
init =
    ( { email = ""
      , validationError = Nothing
      , submitStatus = NotAsked
      }
    , Cmd.none
    )



---- UPDATE ----


submitEmail : String -> Cmd Msg
submitEmail email =
    let
        url =
            "/.netlify/functions/save-email"

        body =
            Http.jsonBody <|
                Encode.object
                    [ ( "email", Encode.string email ) ]
    in
    Http.post
        { url = url
        , body = body
        , expect =
            Http.expectJson
                (RemoteData.fromResult >> SubmitCompleted)
                (Decode.succeed ())
        }


type Msg
    = EmailUpdated String
    | SubmitClicked
    | SubmitCompleted (WebData ())


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EmailUpdated email ->
            ( { model | email = email, validationError = Nothing }
            , Cmd.none
            )

        SubmitClicked ->
            if Validate.isValidEmail model.email then
                ( { model
                    | submitStatus = Loading
                  }
                , submitEmail model.email
                )

            else
                ( { model | validationError = Just "This looks like an invalid email address" }
                , Cmd.none
                )

        SubmitCompleted data ->
            ( { model | submitStatus = data }
            , Cmd.none
            )



---- VIEW ----


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h1 [] [ text "Oslo Elm Days 2020" ]
        , p [ class "info" ] [ Markdown.toHtml [] """
### [April 1 2020]

We sadly have to cancel Oslo Elm Days 2020 due to the escalation of the  Coronavirus pandemic.

We hope for a comeback next year, and aim to deliver an awesome conference for you all then. Meanwhile, take care of yourself and your loved ones!

For future updates on when Oslo Elm Days 2021 will happen, please follow us on Twitter ([@osloelmdays](https://twitter.com/osloelmdays)) or subscribe to our newsletter!
        """ ]
        , case model.submitStatus of
            Success _ ->
                p [] [ text "Thanks for subscribing!" ]

            _ ->
                viewSignupForm model
        , p [ class "removeFromNewsletter" ]
            [ span []
                [ text "If you want to be removed from the newsletter, send an email to "
                ]
            , a [ href "mailto:hello@osloelmdays.no" ]
                [ text "hello@osloelmdays.no" ]
            ]
        ]


viewSignupForm : Model -> Html Msg
viewSignupForm model =
    Html.form [ class "form", onSubmit SubmitClicked ]
        [ p [ class "newsletterIntro" ]
            [ div [] [ text "Want to stay up to date with the latest news?" ]
            , div [] [ text "Sign up for our newsletter!" ]
            ]
        , div [ class "inputContainer" ]
            [ labelHidden "email-input"
                []
                (text "hello@osloelmdays.no")
                (inputText model.email
                    [ id "email-input"
                    , placeholder "hello@osloelmdays.no"
                    , class "email"
                    , onInput EmailUpdated
                    ]
                )
            ]
        , case model.validationError of
            Just err ->
                div [ class "validationError" ] [ text err ]

            Nothing ->
                text ""
        , case model.submitStatus of
            Failure _ ->
                div [ class "validationError" ]
                    [ text "Something went wrong while submitting" ]

            _ ->
                text ""
        , button
            [ class "submitButton"
            , type_ "button"
            , onClick SubmitClicked
            , disabled <| RemoteData.isLoading model.submitStatus
            ]
            [ text <|
                case model.submitStatus of
                    Loading ->
                        "Submitting..."

                    _ ->
                        "Submit"
            ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
