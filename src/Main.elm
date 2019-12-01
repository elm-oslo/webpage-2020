module Main exposing (Model, Msg(..), init, main, update, view)

import Accessibility as Html exposing (..)
import Browser
import Html exposing (Html)
import Html.Attributes exposing (class, href, id, placeholder, type_)
import Html.Events exposing (onClick, onInput)
import Validate



---- MODEL ----


type alias Model =
    { email : String
    , validationError : Maybe String
    }


init : ( Model, Cmd Msg )
init =
    ( { email = "", validationError = Nothing }, Cmd.none )



---- UPDATE ----


submitEmail : String -> Cmd msg
submitEmail email =
    Cmd.none


type Msg
    = EmailUpdated String
    | SubmitClicked


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EmailUpdated email ->
            ( { model | email = email, validationError = Nothing }
            , Cmd.none
            )

        SubmitClicked ->
            if Validate.isValidEmail model.email then
                ( model, submitEmail model.email )

            else
                ( { model | validationError = Just "This looks like an invalid email address" }
                , Cmd.none
                )



---- VIEW ----


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h1 [] [ text "Oslo Elm Days 2020" ]
        , p [ class "intro" ]
            [ text "May 15 and 16 in Oslo, Norway"
            ]
        , form [ class "form" ]
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
            , button [ class "submitButton", type_ "button", onClick SubmitClicked ]
                [ text "Submit" ]
            ]
        , p [ class "removeFromNewsletter" ]
            [ span []
                [ text "If you want to be removed from the newsletter, send an email to "
                ]
            , a [ href "mailto:hello@osloelmdays.no" ]
                [ text "hello@osloelmdays.no" ]
            ]

        --                    , Element.paragraph [ Font.size 16 ]
        --                        [ Element.text "If you want to be removed from the newsletter, send an email to "
        --                        , Element.link
        --                            [ Font.underline
        --                            , Element.mouseOver
        --                                [ Font.color <| color.yellow
        --                                ]
        --                            , Element.htmlAttribute <|
        --                                HtmlA.style "transition" "all 0.2s ease-in-out"
        --                            ]
        --                            { url = "mailto:hello@osloelmday.no"
        --                            , label = Element.text "hello@osloelmday.no"
        --                            }
        --                        ]
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
