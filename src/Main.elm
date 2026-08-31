module Main exposing (..)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Navigation
import Maybe exposing (withDefault)
import Html exposing (Html)
import Element exposing (Element, Color, rgb255, px)
import Element.Events as Events
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Url exposing (Url)
import Url.Parser as Parser exposing (Parser, (</>), int, map, oneOf, s, string)

type Theme
  = Light
  | Dark

type Route
  = Publications
  | Dissertation

routeParser : Parser (Route -> a) a
routeParser = oneOf
  [ map Publications (s "publications")
  , map Dissertation (s "dissertation")
  ]

parseRoute : Url -> Route
parseRoute url = withDefault Publications (Parser.parse routeParser url)

type alias Model =
  { theme : Theme
  , key : Navigation.Key
  , route : Route
  }

type Msg
  = Switch
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

init : flags -> Url -> Navigation.Key -> (Model, Cmd msg)
init _ url key =
  ({ theme = Dark, key = key, route = parseRoute url }, Cmd.none)

view : Model -> Document Msg
view model =
  { title = myName
  , body = [body model]
  }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Switch -> case model.theme of
      Light -> ({ model | theme = Dark }, Cmd.none)
      Dark -> ({ model | theme = Light }, Cmd.none)
    LinkClicked urlRequest ->
      case urlRequest of
        Internal url ->
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

subscriptions : model -> Sub msg
subscriptions _ =
  Sub.none

onUrlChange : Url -> Msg
onUrlChange = UrlChanged

onUrlRequest : Browser.UrlRequest -> Msg
onUrlRequest = LinkClicked

myName : String
myName = "Niek Mulleners"

body : Model -> Html Msg
body model =
  let
    colors = colorScheme model.theme
    header = Element.el
      [ Font.size 36, Font.bold ]
      (Element.text myName)
  in
    Element.layout
      [ Background.color colors.background
      , Font.color colors.text
      ]
      ( Element.column
        [ Element.centerX
        , Element.centerY
        , Element.spacing 60
        ]
        [ Element.row
          [ Element.centerX
          , Element.spacing 220
          , Element.moveRight 128
          ]
          [ header, switch model.theme ]
        , case model.route of
          Publications -> research colors
          Dissertation -> Element.none
        , links model.theme
        ]
      )

switch : Theme -> Element Msg
switch theme =
  let
    symbol =
      case theme of
        Light -> Element.text "🌗︎"
        Dark -> Element.text "🌓︎"
  in
    Input.button
      [ Font.size 36
      , Font.bold
      , Element.centerX
      , Element.centerY
      , Element.mouseOver [ Element.scale 1.2 ]
      ]
      { onPress = Just Switch
      , label = symbol
      }

research : Colors -> Element msg
research colors =
  let
    header = Element.el
      [ Font.size 28, Font.bold, Element.moveRight 10 ]
      (Element.text "Research")
    articles = List.map (showArticle colors) myArticles
  in
    Element.column [ Element.spacing 16 ] (header :: articles)

-- * Colors

type alias Colors =
  { background : Color
  , button : Color
  , highlighted : Color
  , text : Color
  }

gray255 : Int -> Color
gray255 g = rgb255 g g g

light : Colors
light =
  { background = gray255 255
  , button = gray255 243
  , highlighted = gray255 224
  , text = gray255 31
  }

dark : Colors
dark =
  { background = gray255 31
  , button = gray255 43
  , highlighted = gray255 62
  , text = gray255 204
  }

colorScheme : Theme -> Colors
colorScheme theme =
  case theme of
    Light -> light
    Dark -> dark

-- * Links

links : Theme -> Element msg
links theme =
  Element.row
    [ Element.centerX
    , Element.spacing 16
    , Element.scale 0.5
    ]
    (List.map (makeLink theme) myLinks)

type alias Link =
  { url : String
  , description : String
  , src : String
  }

makeLink : Theme -> Link -> Element msg
makeLink theme link =
  let
    folder =
      case theme of
        Light -> "images/dark/"
        Dark -> "images/light/"
  in
  Element.link []
    { url = link.url
    , label = Element.image []
      { description = link.description
      , src = folder ++ link.src
      }
    }

gitHub : Link
gitHub =
  { url = "https://github.com/NiekM/"
  , description = "GitHub"
  , src = "github.svg"
  }

linkedIn : Link
linkedIn =
  { url = "https://www.linkedin.com/in/niek-mulleners/"
  , description = "LinkedIn"
  , src = "linkedin.svg"
  }

orcid : Link
orcid =
  { url = "https://orcid.org/0000-0002-7934-6834"
  , description = "ORCID"
  , src = "orcid.svg"
  }

-- Somehow not working?
-- scholar : Link
-- scholar =
--   { url = "https://scholar.google.nl/citations?user=zqSF4BgAAAAJ&hl=en"
--   , description = "Google Scholar"
--   , src = "scholar.svg"
--   }

myLinks : List Link
myLinks =
  [ linkedIn
  , gitHub
  , orcid
  -- , scholar
  ]

-- * Articles

type alias Article =
  { title : String
  , description : String
  , url : String
  , star : Bool
  }

showArticle : Colors -> Article -> Element msg
showArticle colors { title, description, url, star } =
  Element.link
    [ Background.color colors.button
    , Element.width (px 840)
    , Element.mouseOver
      [ Element.scale 1.03
      , Background.color colors.highlighted
      ]
    ]
    { url = url
    , label =
      Element.row
        [ Element.spacing 24 ]
        [ Element.column
          [ Element.spacing 8
          , Font.size 16
          , Element.padding 10
          ]
          [ Element.el
            [ Font.bold
            , Font.size 20
            , Element.spacing 8
            ]
            (Element.text title)
          , Element.el [ Font.italic ] (Element.text description)
          ]
        , if star
          then Element.el [ Font.size 32, Element.centerY ] (Element.text "★")
          else Element.none
        ]
    }

master_thesis : Article
master_thesis =
  { title = "Modular Semantics for Algebraic Effects"
  , description = "Master Thesis"
  , url = "papers/master_thesis.pdf"
  , star = False
  }

hatra_2020 : Article
hatra_2020 =
  { title = "Model-Driven Synthesis for Program Tutors"
  , description = "Human Aspects of Types and Reasoning Assistants (HATRA) 2020"
  , url = "papers/hatra20.pdf"
  , star = False
  }

padl_2023 : Article
padl_2023 =
  { title = "Program Synthesis Using Example Propagation"
  , description = "Practical Aspects of Declarative Languages (PADL) 2023"
  , url = "papers/padl23.pdf"
  , star = False
  }

icfp_2024 : Article
icfp_2024 =
  { title = "Example-Based Reasoning about the Realizability of Polymorphic Programs"
  , description = "International Conference on Functional Programming (ICFP) 2024, Distinguished Paper"
  , url = "papers/icfp24.pdf"
  , star = True
  }

pepm_2026 : Article
pepm_2026 =
  { title = "Hole Refinements for Polymorphic Type-and-Example Driven Synthesis"
  , description = "International Workshop on Partial Evaluation and Program Manipulation (PEPM) 2026"
  , url = "papers/pepm26.pdf"
  , star = False
  }

myArticles : List Article
myArticles =
  [ pepm_2026
  , icfp_2024
  , padl_2023
  , hatra_2020
  , master_thesis
  ]
