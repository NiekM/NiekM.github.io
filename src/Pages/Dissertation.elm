module Pages.Dissertation exposing (view)

import Element exposing (Element, px)
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
      (Element.text "Dissertation")
    , Element.el
      [ Font.size 20
      , Element.centerX
      , Element.width (px 600)
      ]
      (
        Element.paragraph []
          [ Element.text "The PDF of my thesis can be found "
          , Element.link []
            { url = "papers/dissertation.pdf"
            , label = Element.text "here"
            }
          , Element.text "."
          ]
      )
    ]
