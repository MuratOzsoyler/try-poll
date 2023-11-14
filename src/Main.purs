module Main where

import Prelude

import Control.Monad.ST.Global as ST
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Show.Generic (genericShow)
import Data.Tuple (curry, snd)
import Data.Tuple.Nested ((/\))
import Debug (spyWith)
import Deku.DOM (text_)
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Deku.Hooks ((<#~>))
import Deku.Toplevel (runInBody)
import Effect (Effect)
import FRP.Event as Event
import FRP.Poll as Poll
import Routing.Duplex (RouteDuplex', parse, path, root)
import Routing.Duplex.Generic as G
import Routing.Hash (matchesWith)

-- This main works
-- main :: Effect Unit
-- main = do
--   { event, push } <- toEffect $ create
--   let poll = map (spyWith "poll" show) $ step (-1) $ map (spyWith "event" show) event

--   unsub <- animate poll (Console.log <<< ("log: " <> _) <<< show)

--   launchAff_ do
--     delay $ Milliseconds 1000.0
--     liftEffect $ push (10)
--     delay $ Milliseconds 1000.0
--     liftEffect $ push (20)
--     delay $ Milliseconds 1000.0
--     liftEffect $ unsub

data Route = Home | Settings

derive instance Eq Route
derive instance Ord Route
derive instance Generic Route _

instance Show Route where
  show r = genericShow r

routes :: RouteDuplex' Route
routes = root $ G.sum
  { "Home": G.noArgs
  , "Settings": path "settings" G.noArgs
  }

main :: Effect Unit
main = do
  { event, push } <- ST.toEffect Event.create
  _ <- matchesWith (parse routes) (curry push)
  routeEvent <- pure $ map (spyWith "routePoll" show) $ Poll.step (Nothing /\ Home) $ map (spyWith "routeEvent" show) event

  runInBody $ D.div_
    [ Deku.do
        routeEvent <#~> case _ of
          _ /\ Home -> spyWith "home" (const "") $ D.a [ DA.href_ "#/settings" ] [ text_ "Go to Settings" ]
          _ /\ Settings -> spyWith "settings" (const "") $ D.a [ DA.href_ "#/" ] [ text_ "Go to Home" ]
    ]
