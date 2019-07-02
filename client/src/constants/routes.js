import React, { Component } from "react";

import * as c from "./constants";
import { Icon } from "@material-ui/core";
import Home from "../components/content/home";
import Race from "../components/content/race";
import Racers from "../components/content/racers";
import Rules from "../components/content/rules";
import Stats from "../components/content/stats";
import Settings from "../components/content/settings";

export const routes = [
  {
    target: "/",
    label: "home",
    icon: "home",
    component: Home,
    exact: true
  },
  {
    target: "/race",
    label: c.race,
    icon: "directions_car",
    component: Race,
    exact: false
  },
  {
    target: "/racers",
    label: c.racers,
    icon: "group",
    component: Racers,
    exact: false
  },
  {
    target: "/ruleset",
    label: c.ruleset,
    icon: "library_books",
    component: Rules,
    exact: false
  },
  {
    target: "/stats",
    label: c.stats,
    icon: "dashboard",
    component: Stats,

    exact: false
  },
  {
    target: "/settings",
    label: c.settings,
    icon: "settings",
    component: Settings,
    exact: false
  }
];
