import * as c from "./constants";
import { Icon } from "@material-ui/core";

export const routes = [
  {
    target: "/",
    label: "home",
    icon: "home"
  },
  {
    target: "/race",
    label: c.race,
    icon: "directions_car"
  },
  {
    target: "/racers",
    label: c.racers,
    icon: "group"
  },
  {
    target: "/ruleset",
    label: c.ruleset,
    icon: "library_books"
  },
  {
    target: "/stats",
    label: c.stats,
    icon: "dashboard"
  },
  {
    target: "/settings",
    label: c.settings,
    icon: "settings"
  }
];
