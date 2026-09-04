module View exposing (..)

import Element exposing (Element, Color, rgb255, px)
import Element.Background as Background
import Element.Font as Font
import Theme exposing (Theme(..))
import Route exposing (Route(..), routeToPath)

type alias Colors =
  { background : Color
  , button : Color
  , highlighted : Color
  , text : Color
  }

gray255 : Int -> Color
gray255 g = rgb255 g g g

lightColors : Colors
lightColors =
  { background = gray255 255
  , button = gray255 243
  , highlighted = gray255 224
  , text = gray255 31
  }

darkColors : Colors
darkColors =
  { background = gray255 31
  , button = gray255 43
  , highlighted = gray255 62
  , text = gray255 204
  }

colorScheme : Theme -> Colors
colorScheme theme =
  case theme of
    Light -> lightColors
    Dark -> darkColors

navBar : Route -> Element msg
navBar current =
  Element.row
    [ Element.spacing 32
    , Element.padding 20
    , Element.centerX
    ]
    -- [ navLink current Home "Home"
    -- , navLink current About "About"
    [ navLink current Projects "Projects"
    , navLink current Dissertation "Dissertation"
    ]

navLink : Route -> Route -> String -> Element msg
navLink current target label =
  let
    isCurrent = current == target
  in
    Element.link
      [ Font.size 18
      , if isCurrent then Font.bold else Font.regular
      , Element.mouseOver [ Element.scale 1.1 ]
      ]
      { url = routeToPath target
      , label = Element.text label
      }
