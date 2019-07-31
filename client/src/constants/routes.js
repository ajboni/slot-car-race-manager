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
    label: "HOME",
    icon: "home",
    component: Home,
    exact: true
  },
  {
    target: "/race",
    label: "RACE",
    icon: "directions_car",
    component: Race,
    exact: false
  },
  {
    target: "/racers",
    label: "RACERS",
    icon: "group",
    component: Racers,
    exact: false
  },
  {
    target: "/ruleset",
    label: "RULESET",
    icon: "library_books",
    component: Rules,
    exact: false
  },
  {
    target: "/stats",
    label: "STATS",
    icon: "dashboard",
    component: Stats,

    exact: false
  },
  {
    target: "/settings",
    label: "SETTINGS",
    icon: "settings",
    component: Settings,
    exact: false
  }
];
