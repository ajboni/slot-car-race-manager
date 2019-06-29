import { camelCase, sentenceCase } from "./string-utils";
import _ from "lodash";
export const lang = {
  eng: {
    scramTitle: "Slot Car Race Manager",
    newRace: "new race",
    home: "home"
  },
  spa: {
    scramTitle: "Administacion de Carreras Scalectrix",
    race: "carrera",
    races: "carreras",
    racer: "piloto",
    racers: "pilotos",
    lap: "vuelta",
    edit: "editar",
    settings: "opciones",
    stats: "estadisticas",
    ruleset: "reglas"
  }
};

export const languages = {
  spa: {
    id: "spa",
    label: "spa",
    icon: "AL",
    code: "arg"
  },
  eng: {
    id: "eng",
    label: "eng",
    icon: "AL",
    code: "usa"
  }
};

export function get(key) {
  // TODO: fetch active language
  const activeLanguage = "eng";
  let result = lang[activeLanguage][key];

  // Falback #1
  if (_.isEmpty(result)) {
    let fallback = lang["eng"][key];
    if (_.isEmpty(fallback)) {
      fallback = key;
    }
    result = fallback;
  }

  result = sentenceCase(result);
  return result;
}

export const activeLang = "eng";
export const scramTitle = get("scramTitle");
export const home = get("home");
export const race = get("race");
export const racers = get("racers");
export const ruleset = get("ruleset");
export const settings = get("settings");
export const stats = get("stats");
