import { observable, configure, action } from "mobx";
import * as c from "./constants/constants";

configure({
  enforceActions: "observed"
});

class Store {
  id = Math.random();

  @observable finished = false;

  @observable language = c.languages.spa;
  @action setLanguage(lang) {
    console.log(lang);
    this.language = c.languages[lang];
  }
}

export default new Store();
