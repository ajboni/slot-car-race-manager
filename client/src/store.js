import { observable, configure, action } from "mobx";
import * as c from "./constants/constants";
import l from "./constants/lang";
import { settings as s } from "./constants/constants";

configure({
  enforceActions: "observed"
});

class Store {
  id = Math.random();

  @action init() {
    console.log("Loading user Settings...");
    const lang = this.getItem(s.LANGUAGE, "eng");
    this.setLanguage(lang, false);
  }

  @observable finished = false;
  @observable language = c.languages.spa;
  @observable appState = {
    RACER: {
      selectedItem: null,
      showEditItemModal: false
    },
    RULESET: {
      showEditItemModal: false,
      selectedItem: null
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
}

export default new Store();
