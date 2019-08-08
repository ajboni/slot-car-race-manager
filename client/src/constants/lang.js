// ES6 module syntax
import LocalizedStrings from "react-localization";

let l = new LocalizedStrings({
  eng: {
    ACTIONS: "Actions",
    CANCEL: "Cancel",
    DELETE_RACER: "Delete Racer",
    EDIT_RACER: "Edit Racer",
    HOME: "Home",
    NEW_RACE: "New Race",
    NEW_RACER: "New Racer",
    RACE: "Race",
    RACERS: "Racers",
    RULESET: "Ruleset",
    SCRAM_TITLE: "Slot Car Race Manager",
    SEARCH: "Search",
    SETTINGS: "Settings",
    STATS: "Stats",
    WINS: "Wins",
    NAME: "Name",
    EMPTY_DATASOURCE_MESSAGE: "No records to display.",
    LANGUAGE: "Language",
    LOADING: "Loading...",
    CONFIRM_DELETE: "Really delete "
  },
  spa: {
    ACTIONS: "Acciones",
    CANCEL: "Cancelar",
    DELETE_RACER: "Eliminar Piloto",
    EDIT_RACER: "Editar Piloto",
    HOME: "Inicio",
    NEW_RACE: "Nueva Carrera",
    NEW_RACER: "Nuevo Piloto",
    RACE: "Carrera",
    RACERS: "Pilotos",
    RULESET: "Reglas",
    SCRAM_TITLE: "Slot Car Race Manager",
    SEARCH: "Buscar",
    STATS: "Estadísticas",
    WINS: "Wins",
    NAME: "Nombre",
    EMPTY_DATASOURCE_MESSAGE: "No hay datos para mostrar.",
    SETTINGS: "Preferencias",
    LANGUAGE: "Idioma",
    LOADING: "Cargando...",
    CONFIRM_DELETE: "Eliminar "
  }
});

export default l;
