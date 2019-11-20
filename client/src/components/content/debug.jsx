import React, { useState, Fragment } from "react";
import { observer } from "mobx-react";
import Paper from "@material-ui/core/Paper";
import { makeStyles } from "@material-ui/styles";
import l from "../../constants/lang";
import { Button, ButtonGroup } from "@material-ui/core";
import store from "../../store";
import StateMachine from "./debug/state_machine";
import RaceClock from "./debug/race_clock";

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
    // margin: "10px"
  }
}));

const Debug = observer(() => {
  const classes = useStyles();

  function startRace() {
    console.log("startRace");
    store.sendMessage("startRace", store.config.START_RACE_2);
  }

  function getStatus() {
    console.log("getStatus");
    store.sendMessage("getStatus", store.config.GET_STATUS);

  }

  function restartRace() {
    console.log("restartRace");
    store.sendMessage("getStatus", store.config.RESTART_RACE);

  }

  function getRaceTime() {
    console.log("getRaceTime");
    store.getRaceTime();

  }



  return (
    <Paper className={classes.root}>
      <h2>{l.DEBUG}</h2>
      <ButtonGroup color="primary" variant="contained" size="small" aria-label="full-width contained primary button group">
        <Button onClick={startRace}>
          {l.START_RACE}
        </Button>
        <Button onClick={restartRace}>
          {l.RESTART_RACE}
        </Button>
        <Button onClick={getStatus}>
          {l.GET_STATUS}
        </Button>
        <Button onClick={getRaceTime}>
          {l.GET_RACE_TIME}
        </Button>
      </ButtonGroup>
      <StateMachine status="status" />
      <RaceClock />
    </Paper>
  );
});

export default Debug;
