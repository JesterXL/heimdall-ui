module Main exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Url
import Json.Decode as JD
import Browser.Navigation as Nav

type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , environment: Environment
    , jwtToken : String }

initialModel : Environment -> String -> Nav.Key -> Url.Url -> Model

initialModel environment jwtToken key url =
    { key = key 
    , url = url
    , environment = environment
    , jwtToken = jwtToken  }


type Environment
    = Local
    | Dev
    | Staging
    | Production
    | Unknown


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg)
update msg model =
    case msg of
        LinkClicked urlRequest ->
            ( model, Cmd.none )
        UrlChanged url ->
            ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Sup"
    , body = [ div []
        [ div [][text "Hey"]
        ]
    ] }


init : JD.Value -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init javascriptParametersFromJavaScript url key =
    ( initialModel Local "token" key url, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

main : Program JD.Value Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
