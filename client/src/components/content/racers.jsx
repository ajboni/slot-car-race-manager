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
import store from "../../store";
import { getAction } from "../dataTable";
import { TextField, LinearProgress } from "@material-ui/core";

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

const CREATE_RACER = gql`
  mutation create_racer($name: String) {
    insert_racer(objects: { name: $name }) {
      returning {
        id
        name
      }
    }
  }
`;

const Racers = observer(() => {
  const { loading, error, data } = useQuery(GET_RACERS);

  const [createRacer, { createdRacer }] = useMutation(CREATE_RACER, {
    refetchQueries: ["GetRacers"]
  });

  const [deleteRacer, {}] = useMutation(DELETE_RACER, {
    refetchQueries: ["GetRacers"]
  });

  if (loading) {
    return <LinearProgress />;
  }
  if (error) {
    return <div>Error! {error.message}</div>;
  }

  let sampleColumns = [
    { title: "ID", field: "id" },
    { title: l.NAME, field: "name" }
    // { title: l.WINS, field: "wins" }
  ];

  const collection = "RACER";

  return (
    <Fragment>
      <Racer_edit_screen
        open={store.appState[collection].showEditItemModal}
        item={store.appState[collection].selectedItem}
        collection={collection}
      />
      <DataTable
        data={data.racer}
        columns={sampleColumns}
        title={l.RACERS}
        actions={getAction(collection, deleteRacer)}
      />
      <br />
      <Button
        variant="contained"
        size="large"
        color="secondary"
        onClick={async () => {
          // TODO: Find out why created racer is undefined...
          const y = await createRacer({ variables: { name: l.NEW_RACER } });
          const racer = y.data.insert_racer.returning[0];
          if (racer) {
            // store.setSelectedItem(collection, racer);
            // store.setOpenModal(collection, true);
            // setselectedRacer(racer);
            // racers_store.openModal(true);
          }
        }}
      >
        {l.NEW_RACER}
      </Button>
    </Fragment>
  );
});

export default Racers;
