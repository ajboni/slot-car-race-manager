import { observable, configure, action } from "mobx";
import * as c from "./constants/constants";
import l from "./constants/lang";

configure({
  enforceActions: "observed"
});

class Store {
  id = Math.random();

  @observable finished = false;
  @observable language = c.languages.spa;
  @action setLanguage(lang) {
    l.setLanguage(lang);
    this.language = c.languages[lang];
    window.location.reload();
  }
}

export default new Store();
