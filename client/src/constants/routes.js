import React, { Component } from "react";

import * as c from "./constants";
import { Icon } from "@material-ui/core";
import Home from "../components/content/home";
import Race from "../components/content/race";
import Racers from "../components/content/racers";
import Rules from "../components/content/rules";
import Stats from "../components/content/stats";
import Settings from "../components/content/settings";
import l from "./lang";

export const routes = [
  {
    target: "/",
    label: l.HOME,
    icon: "home",
    component: Home,
    exact: true
  },
  {
    target: "/race",
    label: l.RACE,
    icon: "directions_car",
    component: Race,
    exact: false
  },
  {
    target: "/racers",
    label: l.RACERS,
    icon: "group",
    component: Racers,
    exact: false
  },
  {
    target: "/ruleset",
    label: l.RULESET,
    icon: "library_books",
    component: Rules,
    exact: false
  },
  {
    target: "/stats",
    label: l.STATS,
    icon: "dashboard",
    component: Stats,

    exact: false
  },
  {
    target: "/settings",
    label: l.SETTINGS,
    icon: "settings",
    component: Settings,
    exact: false
  }
];
