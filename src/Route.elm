module Route exposing (Route(..), parseRoute, routeToPath)

import Maybe exposing (withDefault)
import Url exposing (Url)
import Url.Parser as Parser exposing (Parser, (</>), map, oneOf, s, string)

type Route
  = Home
  | About
  | Projects
  | Dissertation

routeParser : Parser (Route -> a) a
routeParser = oneOf
  [ map Home (s "home")
  , map About (s "about")
  , map Projects (s "projects")
  , map Dissertation (s "dissertation")
  ]

parseRoute : Url -> Route
parseRoute url = withDefault Projects (Parser.parse routeParser url)

routeToPath : Route -> String
routeToPath route =
  case route of
    Home -> "/home"
    About -> "/about"
    Projects -> "/projects"
    Dissertation -> "/dissertation"
