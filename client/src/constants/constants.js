import { sentenceCase } from "./string-utils";
import _ from "lodash";
import store from "../store";
import { computed } from "mobx";
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
    ruleset: "reglas",
    home: "Inicio",
    name: "nombre",
    wins: "victorias",
    emptyDataSourceMessage: "No hay datos para mostrar.",
    search: "buscar",
    actions: "acciones",
    newUser: "Nuevo Usuario"
  }
};

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

// Returns a localizated string
export function get(key) {
  const activeLanguage = store.language;
  let result = lang[activeLanguage.id][key];

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

export const scramTitle = "scramTitle";
export const home = "home";
export const race = "race";
export const racers = "racers";
export const ruleset = "ruleset";
export const settings = "settings";
export const stats = "stats";
export const wins = "wins";
export const name = "name";
export const emptyDataSourceMessage = "No records to display.";
export const search = "search";
export const actions = "actions";
export const newUser = "new user";
