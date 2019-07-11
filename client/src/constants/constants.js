import { sentenceCase, deUnderscore } from "./string-utils";
import _ from "lodash";
import store from "../store";
import { computed } from "mobx";

export const languages = {
  spa: {
    id: "spa",
    label: "spa",
    icon: "AL",
    flag: "arg",
    pos: "left"
  },
  eng: {
    id: "eng",
    label: "eng",
    icon: "AL",
    flag: "usa",
    pos: "right"
  }
};
