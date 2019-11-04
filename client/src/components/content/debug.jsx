import React, { useState, Fragment } from "react";
import { observer } from "mobx-react";
import Paper from "@material-ui/core/Paper";
import { makeStyles } from "@material-ui/styles";
import l from "../../constants/lang";
import { Button } from "@material-ui/core";
import store from "../../store";
import Bleep1 from "../../audio/BLEEP1.wav";
import StateMachine from "./debug/state_machine";
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
  },
  button: {    
    margin: "10px"
  }
}));

const Debug = observer(() => {
  const classes = useStyles();

  function startRace() {
    console.log("startRace");
    audio.play();    
    store.sendMessage("startRace", store.config.START_RACE_1);
  }

  function getStatus() {
    console.log("getStatus");
    store.sendMessage("getStatus", store.config.GET_STATUS);

  }

  function restartRace() {
    console.log("restartRace");
    store.sendMessage("getStatus", store.config.RESTART_RACE);

  }

  return (
    <Paper className={classes.root}>
      <h3>{l.DEBUG}</h3>
      <Button
        variant="contained"
        className={classes.button}
        color="primary"
        onClick={startRace}
      >
        {l.START_RACE}
      </Button>
      <Button
        variant="contained"
        className={classes.button}
        color="primary"
        onClick={restartRace}
      >
        {l.RESTART_RACE}
      </Button>
      <Button
        variant="contained"
        className={classes.button}
        color="primary"
        onClick={getStatus}
      >
        {l.GET_STATUS}
      </Button>
      <StateMachine status="status"/>
    </Paper>
  );
});

export default Debug;
