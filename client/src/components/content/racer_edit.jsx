import React from "react";
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

const Racer_edit_screen = ({ racer }) => {
  if (!racer) return null;
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
          {/* <DialogContentText>
            To subscribe to this website, please enter your email address here.
            We will send updates occasionally.
          </DialogContentText> */}
          <TextField
            autoFocus
            margin="dense"
            id="name"
            label={l.EDIT_RACER}
            fullWidth
            defaultValue={racer.name}
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={() => racers_store.openModal(false)} color="primary">
            {l.CANCEL}
          </Button>
          <Button onClick={() => racers_store.openModal(false)} color="primary">
            OK
          </Button>
        </DialogActions>
      </Dialog>
    </div>
  );
};

export default Racer_edit_screen;
