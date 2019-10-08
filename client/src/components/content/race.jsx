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
import Paper from "@material-ui/core/Paper";
import { makeStyles } from "@material-ui/styles";
import {
  FormControl,
  InputLabel,
  Select,
  Input,
  FormHelperText,
  MenuItem,
  Divider
} from "@material-ui/core";
import { toJS } from "mobx";

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

const GET_RACERS = gql`
  query GetRacers {
    racer {
      id
      name
    }
  }
`;

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

const Race = observer(() => {
  const classes = useStyles();
  const {
    loading: loading_ruleset,
    error: error_ruleset,
    data: ruleset_data
  } = useQuery(GET_RULES);
  const {
    loading: loading_racers,
    error: error_racers,
    data: racers_data
  } = useQuery(GET_RACERS);

  const [selectedRuleset, setselectedRuleset] = useState(null);

  if (loading_ruleset | loading_racers) {
    return <div>Loading...</div>;
  }
  if (error_ruleset | error_racers) {
    return (
      <div>
        Error! {error.message} - {error_racers.message}
      </div>
    );
  }

  const rulesets = ruleset_data.ruleset;
  const racers = racers_data.racer;

  if (_.isEmpty(rulesets)) {
    return <div>{l.ERR_NO_RULESET}</div>;
  }
  if (_.isEmpty(racers)) {
    return <div>{l.ERR_NO_RACER}</div>;
  }
  if (!!!selectedRuleset) {
    setselectedRuleset(rulesets[0]);
  }
  console.log(store.appState.RACER);

  return (
    <Paper className={classes.root}>
      <h1>{l.RACE}</h1>

      <FormControl className={classes.formControl}>
        <InputLabel>{l.RULESET}</InputLabel>
        <Select
          value={selectedRuleset}
          onChange={e => {
            setselectedRuleset(e.target.value);
          }}
        >
          {rulesets.map(ruleset => (
            <MenuItem value={ruleset} key={ruleset.id}>
              {ruleset.name} ( {ruleset.total_racers} {l.TOTAL_RACERS} |{" "}
              {ruleset.total_laps} {l.TOTAL_LAPS} )
            </MenuItem>
          ))}
        </Select>
        {/* <FormHelperText>Some important helper text</FormHelperText> */}
      </FormControl>
      <br />
      <br />
      <br />

      <Racer_Selector ruleset={selectedRuleset} racers={racers} />
    </Paper>
  );
});

export default Race;

const Racer_Selector = observer(({ ruleset, racers }) => {
  // TODO: IMPLEMENT SHUTTLE:  http://react-material.fusetheme.com/documentation/material-ui-components/transfer-list
  const classes = useStyles();

  // const { loading, error, racers } = useQuery(GET_RACERS);
  const [selectedRacers, setSelectedRacers] = useState([]);

  // const selectedRacers = store.appState.RACE.selectedRacers;

  let arr = [];
  for (let index = 0; index < ruleset.total_racers; index++) {
    arr.push(racers[0]);
  }

  const checkError = index => {
    if (!selectedRacers[index]) return true;

    for (let i = 0; i < index; i++) {
      if (_.isEmpty(selectedRacers[i])) continue;
      // if (_.isEmpty(selectedRacers[index])) break;
      if (selectedRacers[index].id === selectedRacers[i].id) {
        return true;
      }
    }
    return false;
  };

  const checkErrors = () => {
    var valuesSoFar = [];
    console.log(ruleset.total_racers);
    for (var i = 0; i < ruleset.total_racers; ++i) {
      if (!!!selectedRacers[i]) return true;
      var value = selectedRacers[i].id;
      if (valuesSoFar.indexOf(value) !== -1) {
        return true;
      }
      valuesSoFar.push(value);
    }
    return false;
  };

  return (
    <Fragment>
      <FormControl className={classes.formControl}>
        {arr.map((e, i) => (
          <Fragment key={i}>
            <InputLabel htmlFor="select-multiple">{l.CHOOSE_RACER}</InputLabel>

            <Select
              error={checkError(i, selectedRacers)}
              value={selectedRacers[i] ? selectedRacers[i].name : " "}
              renderValue={() =>
                selectedRacers[i]
                  ? `[ ${i.toString()} ] => ${selectedRacers[i].name}`
                  : " "
              }
              onChange={e => {
                let x = _.clone(selectedRacers);
                x[i] = e.target.value;
                setSelectedRacers(x);
                // setSelectedRacers(i, e.target.value);
              }}
            >
              {racers.map((racer, index) => (
                <MenuItem value={racer} key={index}>
                  {racer.name}
                </MenuItem>
              ))}
            </Select>
            {checkError(i, selectedRacers) ? (
              <FormHelperText>{l.ERR_DUPLICATED_RACER}</FormHelperText>
            ) : (
              ""
            )}
          </Fragment>
        ))}
      </FormControl>
      <Divider light style={{ margin: "20px" }} />
      <div>
        <Button
          variant="contained"
          className={classes.button}
          disabled={checkErrors()}
          color="primary"
          onClick={() => console.log(toJS(selectedRacers))}
        >
          {l.START_RACE}
        </Button>
      </div>
    </Fragment>
  );
});
