module Pages.Projects exposing (view)

import Element exposing (Element, px)
import Element.Background as Background
import Element.Font as Font
import Theme exposing (Theme(..))
import View exposing (Colors)

view : Colors -> Element msg
view colors =
  Element.column
    [ Element.spacing 24
    , Element.centerX
    , Element.paddingXY 0 40
    ]
    [ Element.el
        [ Font.size 36
        , Font.bold
        , Element.centerX
        ]
        (Element.text "Projects")
    , Element.column
        [ Element.spacing 16
        , Element.centerX
        ]
        (List.map (showArticle colors) myArticles)
    ]

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
