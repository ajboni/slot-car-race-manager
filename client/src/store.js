import { observable, configure, action, runInAction } from "mobx";
import * as c from "./constants/constants";
import l from "./constants/lang";
import { settings as s } from "./constants/constants";
import socketIOClient from "socket.io-client";

import configFile from "../../config.yaml"
import YAML from 'yaml'


const fetchConfig = async() =>  {
  const response = await fetch(configFile);
  const text = await response.text();
  const yaml = YAML.parse(text)
  return yaml;
}

function bit_clear(num, bit) {
  return num & ~(1 << bit);
}


function stripValue (b) {
  b = bit_clear(b,4)
  b = bit_clear(b,5)
  b = bit_clear(b,6)
  b = bit_clear(b,7)
  return b;
}

function stripCommand (b) {
   // Shift value bytes into non existence
   b = bit_clear(b,0)
   b = bit_clear(b,1)
   b = bit_clear(b,2)
   b = bit_clear(b,3)
   return b;
}

configure({
  enforceActions: "observed"
});

class Store {
  id = Math.random();
  socket = null;
  config = "";
  constructor() {
    console.log("constructed")
  }

  @action async init() {

    var config = await fetchConfig();
    this.config = config;
    this.socket = socketIOClient.connect(config.BACKEND_IP + ':' + config.BACKEND_PORT); // ip of wifi shield and port of socket
    this.socket.on("update", data => {

      const command = stripCommand(data.data);
      const value = stripValue(data.data);
      
      console.log(command);
      switch (command) {
        case stripCommand(config.STATUS_IDLE):
          console.log(value)
          runInAction(()=> this.appState.RACE.status = data.data);
         
          break;
      
        default:
          break;
      }
      
      // TODO: Bitshift for commands + values
      // Add logic for each command
    });


    console.log("Loading user Settings...");
    const lang = this.getItem(s.LANGUAGE, "eng");
    this.setLanguage(lang, false);
    runInAction(()=> this.initialized = true)
    console.log("Done.")
  }


  @observable initialized = false;
  @observable finished = false;
  @observable language = c.languages.spa;
  @observable appState = {
    RACE: {
      status: "stopped"
    },
    RACER: {
      selectedItem: null,
      showEditItemModal: false
    },
    RULESET: {
      showEditItemModal: false,
      selectedItem: null
    },
  };

  /** Gets an Item from local storage, returning an optional default value */
  @action getItem(item, defaultValue = "") {
    let _item = localStorage.getItem(item);
    if (_item === null) {
      _item = defaultValue;
    }
    return _item;
  }

  @action setLanguage(lang, forceReload = true) {
    l.setLanguage(lang);
    this.language = c.languages[lang];
    localStorage.setItem(s.LANGUAGE, lang);

    if (forceReload) {
      window.location.reload();
    }
  }

  @action setSelectedItem(collection, item) {
    this.appState[collection].selectedItem = item;
  }
  @action setOpenModal(collection, value) {
    this.appState[collection].showEditItemModal = value;
  }

  @action setSelectedRacers(index, value) {
    console.log(index);
    this.appState.RACE.selectedRacers[index] = value;
  }
  @action addSelectedRacer(value) {
    this.appState.RACE.selectedRacers.push(value);
  }

  @action sendMessage(event, params) {
    this.socket.emit(event,Number(params));
  }
  
}

export default new Store();
