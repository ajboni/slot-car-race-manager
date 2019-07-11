import { observable, configure, action } from "mobx";

configure({
  enforceActions: "observed"
});

class RacersStore {
  @observable editRacerModalOpen = false;

  @action openModal(value) {
    this.editRacerModalOpen = value;
  }
}

export default new RacersStore();
