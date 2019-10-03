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
  MenuItem
} from "@material-ui/core";

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
  const { loading: loading_ruleset, error: error_ruleset, data:ruleset_data} = useQuery(GET_RULES);
  const { loading: loading_racers, error: error_racers, data:racers_data} = useQuery(GET_RACERS);


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
    console.log(racers_data)


  if(_.isEmpty(rulesets)) {
    return <div>{l.ERR_NO_RULESET}</div>;
  }
  if(_.isEmpty(racers)) {
    return <div>{l.ERR_NO_RACER}</div>;
  }
  if (!!!selectedRuleset) {
    setselectedRuleset(rulesets[0]);
  }


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

  let arr = [];
  for (let index = 0; index < ruleset.total_racers; index++) {
    arr.push(racers[0]);
  }

  console.log(arr)
  
  return (
    <Fragment>
      <div>{ruleset.name}</div>
      <div>{ruleset.total_racers}</div>

      <FormControl className={classes.formControl}>
        {arr.map((e, i) => (
          <Fragment key={i}>
            <InputLabel htmlFor="select-multiple">Chose Player</InputLabel>
            <Select
              inputProps={{
                name: 'age',
                id: 'select-multiple',
              }}
              value={selectedRacers[i]}
              onChange={e => {
                
                let x = selectedRacers;
                x[i] = e.target.value;
                setSelectedRacers(x);
                console.log(selectedRacers[i])
              }}
            >
              {racers.map(racer => (
                <MenuItem value={racer} key={racer.id}>
                  {racer.name}
                </MenuItem>
              ))}
            </Select>
          </Fragment>
        ))}
      </FormControl>
    </Fragment>
  );
});
