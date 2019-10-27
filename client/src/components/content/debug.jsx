import React, { useState, Fragment } from "react";
import { observer } from "mobx-react";
import Paper from "@material-ui/core/Paper";
import { makeStyles } from "@material-ui/styles";
import l from "../../constants/lang";
import { Button } from "@material-ui/core";
import store from "../../store";
import Bleep1 from "../../audio/BLEEP1.wav";
var audio = new Audio(Bleep1);

const useStyles = makeStyles(theme => ({
  root: {
    padding: theme.spacing(3, 2)
  },
  formControl: {
    margin: theme.spacing(1),
    minWidth: 400
  },
  selectEmpty: {
    marginTop: theme.spacing(2)
  }
}));

const Debug = observer(() => {
  const classes = useStyles();

  function startRace() {
    console.log("startRace");
    audio.play();


    store.sendMessage("startRace", 0b00010000);
  }

  return (
    <Paper className={classes.root}>
      <h1>{l.Debug}</h1>
      <Button
        variant="contained"
        className={classes.button}
        color="primary"
        onClick={startRace}
      >
        {l.START_RACE}
      </Button>
    </Paper>
  );
});

export default Debug;
