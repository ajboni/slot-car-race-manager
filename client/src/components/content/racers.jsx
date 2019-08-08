import React, { useState, Fragment } from "react";
import { observer } from "mobx-react";
import Button from "@material-ui/core/Button";
import DataTable from "../dataTable";
import Racer_edit_screen from "./racer_edit";
import racers_store from "../../stores/racers_store";
import l from "../../constants/lang";
import { Query, graphql } from "react-apollo";
import gql from "graphql-tag";
import { useQuery, useMutation } from "@apollo/react-hooks";

const GET_RACERS = gql`
  query GetRacers {
    racer {
      id
      name
    }
  }
`;

const DELETE_RACER = gql`
  mutation delete_racer($id: Int) {
    delete_racer(where: { id: { _eq: $id } }) {
      returning {
        id
        name
      }
    }
  }
`;

const Racers = observer(() => {
  const [selectedRacer, setselectedRacer] = useState(null);
  const { loading, error, data } = useQuery(GET_RACERS);
  const [deleteRacer, { deletedRacer }] = useMutation(DELETE_RACER, {
    refetchQueries: ["GetRacers"]
  });

  if (loading) {
    return <div>Loading...</div>;
  }
  if (error) {
    return <div>Error! {error.message}</div>;
  }

  let sampleColumns = [
    { title: l.NAME, field: "name" }
    // { title: l.WINS, field: "wins" }
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
      onClick: (event, racer) => {
        const confirmDeletion = confirm(l.CONFIRM_DELETE + racer.name + " ?");

        if (confirmDeletion) {
          deleteRacer({ variables: { id: racer.id } });
        }
      }
    }
  ];
  return (
    <Fragment>
      <Racer_edit_screen
        open={racers_store.editRacerModalOpen}
        racer={selectedRacer}
      />
      <DataTable
        data={data.racer}
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
