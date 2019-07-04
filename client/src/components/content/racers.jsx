import React from "react";
import * as c from "../../constants/constants";
import { observer } from "mobx-react";
import Button from "@material-ui/core/Button";
import DataTable from "../dataTable";

const Racers = observer(() => {
  let sampleColumns = [
    { title: c.get(c.name), field: "name" },
    { title: c.get(c.wins), field: "wins" }
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
      tooltip: "Save User",
      onClick: (event, rowData) => alert("You saved " + rowData.name)
    },
    {
      icon: "delete",
      tooltip: "Delete User",
      onClick: (event, rowData) => confirm("You want to delete " + rowData.name)
    },
    {
      icon: "add",
      tooltip: "Delete User",
      onClick: (event, rowData) =>
        confirm("You want to delete " + rowData.name),
      isFreeAction: true
    }
  ];
  return (
    <div>
      <DataTable
        data={sampleData}
        columns={sampleColumns}
        title={c.get(c.racers)}
        actions={actions}
      />
      <Button variant="contained" color="secondary">
        {c.get(c.newUser)}
      </Button>
    </div>
  );
});

export default Racers;
