module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Element
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Html exposing (Html)
import Html.Attributes as HtmlA
import Validate



---- MODEL ----


type alias Model =
    { email : String, validationError : Maybe String }


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



-- color : { darkBlue : Element.Color, lightBlue : Element.Color, yellow : Element.Color }


color =
    { darkBlue = Element.rgb255 13 0 100
    , lightBlue = Element.rgb255 197 230 255
    , yellow = Element.rgb255 255 202 106
    , yellowTransparent = Element.rgba255 255 202 106 0.9
    , yellowMoreTransparent = Element.rgba255 255 202 106 0.6
    , background = Element.rgba255 37 46 222 0.85
    , errorRed = Element.rgb255 255 92 92
    , white = Element.rgb255 255 255 255
    }



---- VIEW ----


view : Model -> Html Msg
view model =
    Element.layout
        [ Element.width Element.fill
        , Element.height Element.fill
        , Font.color <| color.lightBlue
        , Font.family
            [ Font.typeface "AvenirLTPro-Book"
            , Font.sansSerif
            ]
        ]
    <|
        Element.el
            [ Element.centerX
            , Element.centerY
            , Element.paddingXY 35 40
            , Border.rounded 10
            , Background.color <| color.background
            ]
        <|
            Element.column [ Element.spacing 60, Element.centerX ]
                [ Element.el [ Region.heading 1, Font.size 72 ] <|
                    Element.text "Oslo Elm Day 2020"
                , Element.el [ Element.centerX, Font.size 24 ] <|
                    Element.text "May 15 and 16 in Oslo, Norway"
                , Element.column
                    [ Element.spacing 20
                    , Element.centerX
                    ]
                    [ Element.textColumn [ Element.spacing 5 ]
                        [ Element.paragraph []
                            [ Element.text "Want to stay up to date with the latest news?" ]
                        , Element.text "Sign up for our newsletter!"
                        ]
                    , Input.email
                        [ Font.color <| color.darkBlue
                        ]
                        { onChange = EmailUpdated
                        , text = model.email
                        , placeholder =
                            Just <|
                                Input.placeholder []
                                    (Element.text "hello@osloelmday.no")
                        , label =
                            Input.labelHidden "Your email address"
                        }
                    , case model.validationError of
                        Just err ->
                            Element.el [ Font.color <| color.errorRed ] <|
                                Element.text err

                        Nothing ->
                            Element.none
                    , Input.button
                        [ Element.centerX
                        , Element.paddingXY 15 12
                        , Background.color <| color.yellow
                        , Font.color <| color.darkBlue
                        , Border.rounded 3
                        , Element.mouseDown
                            [ Background.color <| color.yellowMoreTransparent ]
                        , Element.mouseOver
                            [ Background.color <| color.yellowTransparent ]
                        , Element.htmlAttribute <|
                            HtmlA.style "transition" "all 0.2s ease-in-out"
                        , Element.width Element.fill
                        ]
                        { onPress = Just SubmitClicked
                        , label = Element.text "Submit"
                        }
                    , Element.paragraph [ Font.size 16 ]
                        [ Element.text "If you want to be removed from the newsletter, send an email to "
                        , Element.link
                            [ Font.underline
                            , Element.mouseOver
                                [ Font.color <| color.yellow
                                ]
                            , Element.htmlAttribute <|
                                HtmlA.style "transition" "all 0.2s ease-in-out"
                            ]
                            { url = "mailto:hello@osloelmday.no"
                            , label = Element.text "hello@osloelmday.no"
                            }
                        ]
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
