import React, { useState, Fragment } from "react";
import { observer } from "mobx-react";
import Button from "@material-ui/core/Button";
import DataTable from "../dataTable";
import Racer_edit_screen from "./racer_edit";
import racers_store from "../../stores/racers_store";
import l from "../../constants/lang";
import { Query } from "react-apollo";
import gql from "graphql-tag";

const GET_RACERS = gql`
  query GetRacers {
    racer {
      id
      name
    }
  }
`;

const Racers = observer(() => {
  const [selectedRacer, setselectedRacer] = useState(null);

  let sampleColumns = [
    { title: l.NAME, field: "name" }
    // { title: l.WINS, field: "wins" }
  ];

  // let sampleData = [
  //   { name: "Eber", wins: 1 },
  //   { name: "Eusebio", wins: 12 },
  //   { name: "Ramon", wins: 22 },
  //   { name: "Rita", wins: 3 }
  // ];

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
      <Query query={GET_RACERS}>
        {({ data, loading, error }) => {
          if (loading) return <p>{l.LOADING}</p>;
          if (error) return <p>ERROR: {error.message}</p>;
          console.log(data);
          return (
            <Fragment>
              <DataTable
                data={data.racer}
                columns={sampleColumns}
                title={l.RACERS}
                actions={actions}
              />
            </Fragment>
          );
        }}
      </Query>

      <br />
      <Button variant="contained" size="large" color="secondary">
        {l.NEW_RACER}
      </Button>
    </Fragment>
  );
});

export default Racers;
