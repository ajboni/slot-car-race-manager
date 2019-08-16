import React, { useState } from "react";
import * as c from "../../constants/constants";
import Button from "@material-ui/core/Button";
import TextField from "@material-ui/core/TextField";
import Dialog from "@material-ui/core/Dialog";
import DialogActions from "@material-ui/core/DialogActions";
import DialogContent from "@material-ui/core/DialogContent";
import DialogContentText from "@material-ui/core/DialogContentText";
import DialogTitle from "@material-ui/core/DialogTitle";
import racers_store from "../../stores/racers_store";
import l from "../../constants/lang";
import { Query } from "react-apollo";
import gql from "graphql-tag";
import { Mutation, ApolloConsumer } from "react-apollo";
import { client } from "../../apollo";
import { useMutation } from "@apollo/react-hooks";
import store from "../../store";
import { makeStyles } from "@material-ui/styles";

const EDIT_RULESET = gql`
  mutation update_ruleset(
    $id: Int
    $newName: String
    $total_laps: Int
    $total_racers: Int
  ) {
    update_ruleset(
      where: { id: { _eq: $id } }
      _set: {
        name: $newName
        total_laps: $total_laps
        total_racers: $total_racers
      }
    ) {
      returning {
        id
        name
        total_laps
        total_racers
      }
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

const useStyles = makeStyles(theme => ({
  textField: {
    marginLeft: theme.spacing(1),
    marginRight: theme.spacing(1),
    width: 400,
    marginTop: theme.spacing(2)
  },
  dense: {
    marginTop: 19
  },
  menu: {
    width: 200
  }
}));

const Ruleset_edit_screen = ({ item, mode }) => {
  if (!item) return null;
  const classes = useStyles();
  const [newName, setNewName] = useState(item.name);
  const [laps, setLaps] = useState(item.total_laps);
  const [racers, setRacers] = useState(item.total_racers);

  const [updateRuleset, { data }] = useMutation(EDIT_RULESET);
  const [deleteRuleset, {}] = useMutation(DELETE_RULESET, {
    refetchQueries: ["GetRules"]
  });

  const collection = "RULESET";
  return (
    <div>
      <Dialog
        open={store.appState[collection].showEditItemModal}
        onClose={() => store.setOpenModal(collection, false)}
        aria-labelledby="form-dialog-title"
        fullWidth
        maxWidth="md"
      >
        <DialogTitle id="form-dialog-title">{l.EDIT_RULESET}</DialogTitle>
        <DialogContent>
          {/* <DialogContent Text> 
            To subscribe to this website, please enter your email address here.
            We will send updates occasionally.
          </DialogContentText> */}
          <TextField
            fullWidth
            autoFocus
            label={l.NAME}
            value={newName}
            onChange={e => setNewName(e.target.value)}
            className={classes.textField}
          />
          <TextField
            label={l.TOTAL_LAPS}
            value={laps}
            onChange={e => {
              let clean = e.target.value.replace(/\D/g, "");
              if (clean === "") {
                clean = 1;
              }
              setLaps(clean);
            }}
            type="number"
            className={classes.textField}
          />
          <TextField
            label={l.TOTAL_RACERS}
            value={racers}
            onChange={e => {
              let clean = e.target.value.replace(/\D/g, "");
              if (clean === "") {
                clean = 1;
              }
              setRacers(clean);
            }}
            type="number"
            className={classes.textField}
          />
        </DialogContent>
        <DialogActions>
          <Button
            onClick={() => {
              store.setOpenModal(collection, false);
            }}
            color="primary"
          >
            {l.CANCEL}
          </Button>
          <Button
            onClick={() => {
              updateRuleset({
                variables: {
                  id: item.id,
                  newName: newName,
                  total_laps: laps,
                  total_racers: racers
                }
              });

              store.setOpenModal(collection, false);
            }}
            color="primary"
          >
            OK
          </Button>
        </DialogActions>
      </Dialog>
    </div>
  );
};

export default Ruleset_edit_screen;
