import * as c from "./constants";
import { Icon } from "@material-ui/core";

export const routes = [
  {
    target: "/",
    label: "home",
    icon: "home",
    component:
    exact: true
  },
  {
    target: "/race",
    label: c.race,
    icon: "directions_car",
    exact: false
  },
  {
    target: "/racers",
    label: c.racers,
    icon: "group",
    exact: false
  },
  {
    target: "/ruleset",
    label: c.ruleset,
    icon: "library_books",
    exact: false
  },
  {
    target: "/stats",
    label: c.stats,
    icon: "dashboard",
    exact: false
  },
  {
    target: "/settings",
    label: c.settings,
    icon: "settings",
    exact: false
  }
];
