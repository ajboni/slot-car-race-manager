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
    START_RACE: "Start Race",
    RESTART_RACE: "Restart Race",
    CONFIRM_DELETE: "Really delete ",
    NEW_RULESET: "New Ruleset",
    EDIT_RULESET: "Edit Ruleset",
    TOTAL_LAPS: "Total Laps",
    TOTAL_RACERS: "Total Racers",
    DEBUG: "Debug",
    ERR_NO_RULESET: "Please add at least one ruleset before continuing...",
    ERR_NO_RACER: "Please add at least one racer before continuing...",
    ERR_DUPLICATED_RACER: "ERROR: Racer missing or already assigned.",
    CHOOSE_RACER: "Choose Racer",
    GET_STATUS: "Get Status",
    GET_RACE_TIME: "Get race time",
    RANKED_RACE: "Ranked Race"
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
    START_RACE: "Iniciar Carrera",
    RESTART_RACE: "Reiniciar Carrera",
    CONFIRM_DELETE: "Eliminar ",
    NEW_RULESET: "Nueva Regla",
    EDIT_RULESET: "Editar Regla",
    TOTAL_LAPS: "Vueltas",
    TOTAL_RACERS: "Pilotos",
    DEBUG: "Pruebas",
    ERR_NO_RULESET: "Por favor agregue al menos una regla antes de continuar...",
    ERR_NO_RACER: "Por favor agregue al menos un piloto antes de continuar...",
    ERR_DUPLICATED_RACER: "ERROR: Piloto ya asignado o inexistente.",
    CHOOSE_RACER: "Elegir Piloto",
    GET_STATUS: "Obtener Estado",
    GET_RACE_TIME: "Obtener reloj",
    RANKED_RACE: "Carrera Rankeada"
  }
});

export default l;
