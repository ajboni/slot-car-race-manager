import { observable, configure, action } from "mobx";
import * as c from "./constants/constants";
import l from "./constants/lang";
import { settings as s } from "./constants/constants";
import socketIOClient from "socket.io-client";

var socket = socketIOClient.connect("http://127.0.0.1:10002"); // ip of wifi shield and port of socket

configure({
  enforceActions: "observed"
});

class Store {
  id = Math.random();
  constructor() {
    socket.on("update", function(data) {
      console.log(data);
    });
  }

  @action init() {
    console.log("Loading user Settings...");
    const lang = this.getItem(s.LANGUAGE, "eng");
    this.setLanguage(lang, false);
  }

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
    RACE: {
      // selectedRacers: new Array(15)
    }
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
    socket.emit(event, params);
  }
}

export default new Store();
