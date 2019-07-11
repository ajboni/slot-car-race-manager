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
    EMPTY_DATASOURCE_MESSAGE: "No records to display."
  },
  spa: {
    NEW_RACE: "Nueva Carrera",
    NEW_RACER: "Nuevo Piloto",
    EDIT_RACER: "Editar Piloto"
  }
});

export default l;
