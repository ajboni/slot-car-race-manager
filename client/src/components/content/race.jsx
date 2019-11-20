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
import { toJS } from "mobx";
import {
  FormControl,
  InputLabel,
  Select,
  Input,
  FormHelperText,
  MenuItem,
  Divider,
  LinearProgress,
  Switch,
  Grid,
  FormGroup,
  Modal
} from "@material-ui/core";
import RaceLive from "../race_live";
import { width } from "@material-ui/system";


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
    minWidth: "90%"
  },
  selectEmpty: {
    marginTop: theme.spacing(2)
  },
  modal: {
    padding: theme.spacing(3, 2),
    width: "100vw",
    height: "100vh"

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
    return <LinearProgress />;
  }
  if (error_ruleset | error_racers) {
    return (
      <div>
        Error! {error.message} - {error_racers.message}
      </div>
    );
  }

  if (_.isEmpty(ruleset_data)) {
    return <div>{l.ERR_NO_RULESET}</div>;
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
  // console.log(store.appState.RACER);

  function showRacersSelection() {
    return (
      store.appState.RACE.ranked ?
        <Racer_Selector ruleset={selectedRuleset} racers={racers} />
        : null
    )

  }

  function showStartRaceButton() {
    if (store.appState.RACE.ranked) { return null }
    return (

      <div>
        <Divider light style={{ margin: "20px" }} />
        <Button
          variant="contained"
          className={classes.button}
          color="primary"
          onClick={() => store.startRace()}
        >
          {l.START_RACE}
        </Button>
      </div >
    )
  }

  return (
    <Paper className={classes.root}>
      <Modal
        aria-labelledby="simple-modal-title"
        aria-describedby="simple-modal-description"
        open={store.appState.RACE.status == "started"}
      >
        <Paper className={classes.modal}>
          {/* <h2 id="simple-modal-title">Text in a modal</h2> */}
          {/* <p id="simple-modal-description"></p> */}
          <RaceLive />
        </Paper>
      </Modal>

      <h1>{l.RACE}</h1>
      <Grid
        container
        direction="column"
        justify="space-evenly"
        alignItems="flex-start"
      >

        <div>
          <Switch
            checked={store.appState.RACE.ranked}
            onChange={(e) => store.setRankedRace(e.target.checked)}
            value={store.appState.RACE.ranked}
            inputProps={{ 'aria-label': 'secondary checkbox' }}
            label={l.RANKED_RACE}
          />
          {l.RANKED_RACE}
        </div>
        <FormControl className={classes.formControl}>
          <InputLabel>{l.RULESET}</InputLabel>
          <Select
            value={selectedRuleset}
            onChange={e => {
              setselectedRuleset(e.target.value);
              store.setSelectedRuleset(e.target.value)
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

      </Grid>

      {showStartRaceButton()}
      {showRacersSelection()}


    </Paper >
  );
});

export default Race;

const Racer_Selector = observer(({ ruleset, racers }) => {
  // TODO: IMPLEMENT SHUTTLE:  http://react-material.fusetheme.com/documentation/material-ui-components/transfer-list
  const classes = useStyles();

  // const {loading, error, racers} = useQuery(GET_RACERS);
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
      <Grid container >
        {arr.map((e, i) => (
          <Grid item xs={12} sm={12} md={4} lg={3} key={i}>
            <FormControl className={classes.formControl}>
              <InputLabel htmlFor="select-multiple">{l.CHOOSE_RACER} #{i + 1}</InputLabel>

              <Select
                error={checkError(i, selectedRacers)}
                value={selectedRacers[i] ? selectedRacers[i] : ''}
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
            </FormControl>
          </Grid>
        ))}
      </Grid>
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
