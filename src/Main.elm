module Main exposing (..)

import Browser
import Html exposing (Html)
import Element exposing (Element, Color, rgb255, px)
import Element.Events as Events
import Element.Background as Background
import Element.Font as Font
import Element.Region exposing (description)

type Model
  = Light
  | Dark

type Msg =
  Switch

main : Program () Model Msg
main =
  Browser.sandbox { init = init, update = update, view = view }

init : Model
init =
  Dark

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

colorScheme : Model -> Colors
colorScheme model =
  case model of

    Light -> light

    Dark -> dark

view : Model -> Html Msg
view model =
  let
    colors = colorScheme model
    header = Element.el
      [ Font.size 36, Font.bold ]
      (Element.text "Niek Mulleners")
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
          [ header, switch model ]
        , research colors
        , links model
        ]
      )

switch : Model -> Element Msg
switch model =
  let
    symbol =
      case model of
        Light -> Element.text "🌗︎"
        Dark -> Element.text "🌓︎"
  in
    Element.el
      [ Font.size 36
      , Font.bold
      , Events.onClick Switch
      ]
      symbol

research : Colors -> Element msg
research colors =
  let
    header = Element.el
      [ Font.size 28, Font.bold, Element.moveRight 10 ]
      (Element.text "Research")
    articles = List.map (showArticle colors) myArticles
  in
    Element.column [ Element.spacing 16 ] (header :: articles)
    

links : Model -> Element msg
links model =
  Element.row
    [ Element.centerX
    , Element.spacing 16
    , Element.scale 0.5
    ]
    (List.map (makeLink model) myLinks)

type alias Link =
  { url : String
  , description : String
  , src : String
  }

makeLink : Model -> Link -> Element msg
makeLink model link =
  let
    folder =
      case model of
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

update : Msg -> Model -> Model
update _ model =
  case model of
    Light -> Dark
    Dark -> Light
  


-- main : Html msg
-- main = Element.layout
--   [ Background.color (rgb255 31 31 31)
--   , Font.color (rgb255 204 204 204)
--   ]
--   ( Element.column
--     [ Element.centerX
--     , Element.centerY
--     , Element.spacing 20
--     ]
--     (List.map showArticle myArticles)
--   )

type alias Article =
  { title : String
  , description : String
  , url : String
  }

showArticle : Colors -> Article -> Element msg
showArticle colors { title, description, url } =
  Element.link
    [ Background.color colors.button
    , Element.width (px 800)
    , Element.mouseOver
      [ Element.scale 1.03
      , Background.color colors.highlighted
      ]
    ]
    { url = url
    , label =  Element.column
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
    }
    


hatra_2020 : Article
hatra_2020 =
  { title = "Model-Driven Synthesis for Program Tutors"
  , description = "Human Aspects of Types and Reasoning Assistants (HATRA) 2020"
  , url = "https://arxiv.org/pdf/2011.07510"
  }

padl_2023 : Article
padl_2023 =
  { title = "Program Synthesis Using Example Propagation"
  , description = "Practical Aspects of Declarative Languages (PADL) 2023"
  , url = "https://rdcu.be/c26m0"
  -- , authors = myAuthors
  -- , venue = "PADL"
  -- , doi = "10.1007/978-3-031-24841-2_2"
  -- , year = 2023
  }

icfp_2024 : Article
icfp_2024 =
  { title = "Example-Based Reasoning about the Realizability of Polymorphic Programs"
  , description = "International Conference on Functional Programming (ICFP) 2024"
  , url = "https://arxiv.org/pdf/2406.18304"
  -- , authors = myAuthors
  -- , venue = "ICFP"
  -- , doi = "10.48550/arXiv.2406.18304"
  -- -- , doi = "10.1145/3674636"
  -- , year = 2024
  }

myArticles : List Article
myArticles =
  [ icfp_2024
  , padl_2023
  , hatra_2020
  ]
