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
import { getAction } from "../dataTable";
import Ruleset_edit_screen from "./ruleset_edit";
import store from "../../store";

const GET_RULES = gql`
  query GetRules {
    ruleset {
      id
      name
      total_laps
      total_racers
    }
  }
`;

const DELETE_RULESET = gql`
  mutation delete_ruleset($id: Int) {
    delete_ruleset(where: { id: { _eq: $id } }) {
      returning {
        id
        name
      }
    }
  }
`;

const CREATE_RULESET = gql`
  mutation create_ruleset($name: String) {
    insert_ruleset(objects: { name: $name }) {
      returning {
        id
        name
      }
    }
  }
`;

const Rules = observer(() => {
  const { loading, error, data } = useQuery(GET_RULES);
  const [createRuleset, { createdRacer }] = useMutation(CREATE_RULESET, {
    refetchQueries: ["GetRules"]
  });

  let columns = [
    { title: l.NAME, field: "id" },
    { title: l.NAME, field: "name" },
    { title: l.NAME, field: "total_laps" },
    { title: l.NAME, field: "total_racers" }

    // { title: l.WINS, field: "wins" }
  ];

  if (loading) {
    return <div>Loading...</div>;
  }
  if (error) {
    return <div>Error! {error.message}</div>;
  }

  const collection = "RULESET";

  return (
    <Fragment>
      <Ruleset_edit_screen
        open={store.appState[collection].showEditItemModal}
        item={store.appState[collection].selectedItem}
        collection={collection}
      />
      <DataTable
        data={data.ruleset}
        columns={columns}
        title={l.RULESET}
        actions={getAction(collection)}
      />
      <br />
      <Button
        variant="contained"
        size="large"
        color="secondary"
        onClick={async () => {
          // TODO: Find out why created racer is undefined...
          const y = await createRuleset({ variables: { name: l.NEW_RACER } });
          const item = y.data.insert_ruleset.returning[0];
          if (item) {
            store.setSelectedItem(collection, item);
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

export default Rules;
