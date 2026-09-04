module Icons exposing (icons)

import Element exposing (Element, Color, rgb255, px)
import Theme exposing (Theme(..))

icons : Theme -> Element msg
icons theme =
  Element.row
    [ Element.centerX
    , Element.spacing 16
    , Element.scale 0.5
    ]
    (List.map (makeIcon theme) myIcons)

type alias Icon =
  { url : String
  , description : String
  , src : String
  }

makeIcon : Theme -> Icon -> Element msg
makeIcon theme icon =
  let
    folder =
      case theme of
        Light -> "images/dark/"
        Dark -> "images/light/"
  in
  Element.link []
    { url = icon.url
    , label = Element.image []
      { description = icon.description
      , src = folder ++ icon.src
      }
    }

gitHub : Icon
gitHub =
  { url = "https://github.com/NiekM/"
  , description = "GitHub"
  , src = "github.svg"
  }

linkedIn : Icon
linkedIn =
  { url = "https://www.linkedin.com/in/niek-mulleners/"
  , description = "LinkedIn"
  , src = "linkedin.svg"
  }

orcid : Icon
orcid =
  { url = "https://orcid.org/0000-0002-7934-6834"
  , description = "ORCID"
  , src = "orcid.svg"
  }

-- Somehow not working?
-- scholar : Icon
-- scholar =
--   { url = "https://scholar.google.nl/citations?user=zqSF4BgAAAAJ&hl=en"
--   , description = "Google Scholar"
--   , src = "scholar.svg"
--   }

myIcons : List Icon
myIcons =
  [ linkedIn
  , gitHub
  , orcid
  -- , scholar
  ]
