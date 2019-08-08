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
}

export default new Store();
