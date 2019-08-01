import React, { useState, Fragment } from "react";
import { observer } from "mobx-react";
import Button from "@material-ui/core/Button";
import DataTable from "../dataTable";
import Racer_edit_screen from "./racer_edit";
import racers_store from "../../stores/racers_store";
import l from "../../constants/lang";

const Racers = observer(() => {
  const [selectedRacer, setselectedRacer] = useState(null);

  let sampleColumns = [
    { title: l.NAME, field: "name" },
    { title: l.WINS, field: "wins" }
  ];

  let sampleData = [
    { name: "Eber", wins: 1 },
    { name: "Eusebio", wins: 12 },
    { name: "Ramon", wins: 22 },
    { name: "Rita", wins: 3 }
  ];

  let actions = [
    {
      icon: "edit",
      tooltip: l.EDIT_RACER,
      onClick: (event, rowData) => {
        // alert("You saved " + rowData.name);
        setselectedRacer(rowData);
        racers_store.openModal(true);
      }
    },
    {
      icon: "delete",
      tooltip: l.DELETE_RACER,
      onClick: (event, rowData) => confirm("You want to delete " + rowData.name)
    }
  ];

  return (
    <Fragment>
      <Racer_edit_screen
        open={racers_store.editRacerModalOpen}
        racer={selectedRacer}
      />
      <DataTable
        data={sampleData}
        columns={sampleColumns}
        title={l.RACERS}
        actions={actions}
      />
      <br />
      <Button variant="contained" size="large" color="secondary">
        {l.NEW_RACER}
      </Button>
    </Fragment>
  );
});

export default Racers;
