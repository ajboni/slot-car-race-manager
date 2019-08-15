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
import EditItemScreen from "./edit_item";
import { TextField } from "@material-ui/core";

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
  const [selectedRacer, setselectedRacer] = useState(null);
  const { loading, error, data } = useQuery(GET_RACERS);
  const [deleteRacer, { deletedRacer }] = useMutation(DELETE_RACER, {
    refetchQueries: ["GetRacers"]
  });

  const [createRacer, { createdRacer }] = useMutation(CREATE_RACER, {
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

  const collection = "RACER";

  return (
    <Fragment>
      <EditItemScreen
        open={store.appState[collection].showEditItemModal}
        item={store.appState[collection].selectedItem}
        collection={collection}
        content={
          <TextField
            autoFocus
            margin="dense"
            id="name"
            label={l["EDIT_" + collection]}
            fullWidth
            value={newName}
            onChange={e => setNewName(e.target.value)}
            onFocus={event => {
              event.target.select();
            }}
            onKeyPress={ev => {
              if (ev.key === "Enter") {
                // Do code here
                updateRacer({
                  variables: { id: racer.id, newName: newName }
                });

                store.setOpenModal(collection, false);
                ev.preventDefault();
              }
            }}
          />
        }
        actions={
          <Fragment>
            <Button
              onClick={() => racers_store.openModal(false)}
              color="primary"
            >
              {l.CANCEL}
            </Button>
            <Button
              onClick={() => {
                updateRacer({
                  variables: { id: racer.id, newName: newName }
                });

                racers_store.openModal(false);
              }}
              color="primary"
            >
              OK
            </Button>
          </Fragment>
        }
      />
      <DataTable
        data={data.racer}
        columns={sampleColumns}
        title={l.RACERS}
        actions={getAction(collection)}
      />
      openModal
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
            store.setSelectedItem(collection, racer);
            store.setOpenModal(collection, true);
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
