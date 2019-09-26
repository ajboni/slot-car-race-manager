import React, { useState, Fragment } from "react";
import { observer } from "mobx-react";
import Paper from "@material-ui/core/Paper";
import { makeStyles } from "@material-ui/styles";
import l from "../../constants/lang";

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

  return (
    <Paper className={classes.root}>
      <h1>{l.Debug}</h1>
    </Paper>
  );
});

export default Debug;
