module Route exposing (Route(..), parseRoute, routeToPath)

import Maybe exposing (withDefault)
import Url exposing (Url)
import Url.Parser as Parser exposing (Parser, (</>), map, oneOf, s, string)

type Route
  = Home
  | About
  | Projects
  | Dissertation
  | Paper String

routeParser : Parser (Route -> a) a
routeParser = oneOf
  [ map Home (s "home")
  , map About (s "about")
  , map Projects (s "projects")
  , map Dissertation (s "dissertation")
  , map Paper (s "paper" </> string)
  ]

parseRoute : Url -> Route
parseRoute url = withDefault Dissertation (Parser.parse routeParser url)

routeToPath : Route -> String
routeToPath route =
  case route of
    Home -> "/home"
    About -> "/about"
    Projects -> "/projects"
    Dissertation -> "/dissertation"
    Paper paper -> "/paper/" ++ paper ++ ".pdf"
