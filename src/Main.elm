module Main exposing (main)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Navigation
import Element exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Url exposing (Url)

import Icons
import Pages.About
import Pages.Dissertation
import Pages.Home
import Pages.Projects
import Route exposing (Route(..), parseRoute)
import Theme exposing (Theme(..))
import View exposing (Colors)

type alias Model =
  { theme : Theme
  , key : Navigation.Key
  , route : Route
  }

type Msg
  = SwitchTheme
  | LinkClicked UrlRequest
  | UrlChanged Url

main : Program () Model Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = onUrlChange
    , onUrlRequest = onUrlRequest
    }

init : () -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
  ( { theme = Dark, key = key, route = parseRoute url }, Cmd.none )

myName : String
myName = "Niek Mulleners"

view : Model -> Document Msg
view model =
  let
    colors = View.colorScheme model.theme
    header = Element.el
      [ Element.centerX, Font.size 36, Font.bold, Element.moveRight 16]
      (Element.text myName)
    content =
      case model.route of
        Home -> Pages.Home.view colors
        About -> Pages.About.view colors
        Projects -> Pages.Projects.view colors
        Dissertation -> Pages.Dissertation.view colors
  in
    { title = myName
    , body =
        [ Element.layout
            [ Background.color colors.background
            , Font.color colors.text
            ]
            (Element.column
              [ Element.centerX
              , Element.paddingXY 0 20
              , Element.height Element.fill
              , Element.width Element.fill
              ]
              [ Element.row
                  [ Element.width Element.fill
                  , Element.paddingXY 40 0
                  ]
                  [ header
                  , switchButton model.theme
                  ]
              , View.navBar model.route
              , Element.el
                  [ Element.centerX
                  , Element.paddingXY 0 20
                  ]
                  content
              , Icons.icons model.theme
              ]
            )
        ]
    }

switchButton : Theme -> Element Msg
switchButton theme =
  let
    symbol =
      case theme of
        Light -> Element.text "🌗︎"
        Dark -> Element.text "🌓︎"
  in
    Input.button
      [ Font.size 36
      , Font.bold
      , Element.alignRight
      , Element.mouseOver [ Element.scale 1.2 ]
      ]
      { onPress = Just SwitchTheme
      , label = symbol
      }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    SwitchTheme ->
      case model.theme of
        Light -> ( { model | theme = Dark }, Cmd.none )
        Dark -> ( { model | theme = Light }, Cmd.none )

    LinkClicked urlRequest ->
      case urlRequest of
        Internal url ->
          if String.endsWith ".pdf" (Url.toString url) then
            ( model
            , Navigation.load (Url.toString url)
            )
          else
            ( model
            , Navigation.pushUrl model.key (Url.toString url)
            )
        External url ->
          ( model
          , Navigation.load url
          )

    UrlChanged url ->
      ( { model | route = parseRoute url }
      , Cmd.none
      )

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none

onUrlChange : Url -> Msg
onUrlChange = UrlChanged

onUrlRequest : Browser.UrlRequest -> Msg
onUrlRequest = LinkClicked
