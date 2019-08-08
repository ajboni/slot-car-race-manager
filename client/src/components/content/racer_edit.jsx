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

const EDIT_RACER = gql`
  mutation update_racer($id: Int, $newName: String) {
    update_racer(where: { id: { _eq: $id } }, _set: { name: $newName }) {
      returning {
        id
        name
      }
    }
  }
`;

const GET_RACERS = gql`
  query GetRacers {
    racer {
      id
      name
    }
  }
`;

const Racer_edit_screen = ({ racer }) => {
  if (!racer) return null;
  const [newName, setNewName] = useState(racer.name);
  const [updateRacer, { data }] = useMutation(EDIT_RACER);

  return (
    <div>
      <Dialog
        open={racers_store.editRacerModalOpen}
        onClose={() => racers_store.openModal(false)}
        aria-labelledby="form-dialog-title"
        fullWidth
        maxWidth="md"
      >
        <DialogTitle id="form-dialog-title">{l.EDIT_RACER}</DialogTitle>
        <DialogContent>
          {/* <DialogContent Text> 
            To subscribe to this website, please enter your email address here.
            We will send updates occasionally.
          </DialogContentText> */}
          <TextField
            autoFocus
            margin="dense"
            id="name"
            label={l.EDIT_RACER}
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

                racers_store.openModal(false);
                ev.preventDefault();
              }
            }}
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={() => racers_store.openModal(false)} color="primary">
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
        </DialogActions>
      </Dialog>
    </div>
  );
};

export default Racer_edit_screen;
