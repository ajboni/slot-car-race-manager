import React, { Fragment } from "react";
import { observer } from "mobx-react";
import { makeStyles } from "@material-ui/core/styles";
import { languages } from "../../constants/constants";
import ToggleButtonGroup from "@material-ui/lab/ToggleButtonGroup";
import ToggleButton from "@material-ui/lab/ToggleButton";
import Flag from "react-world-flags";
import store from "../../store";
import l from "../../constants/lang";

const useStyles = makeStyles(theme => ({
  root: {
    display: "flex",
    backgroundColor: "#333"
  },
  leftIcon: {
    marginRight: theme.spacing(1),
    width: "25px"
  },
  toggleContainer: {
    margin: theme.spacing(2, 0)
  },
  formItem: {
    display: "flex",
    alignItems: "flex-end"
  },
  label: {
    marginRight: "20px",
    fontWeight: "400"
  },
  a: {
    textDecoration: "none"
  },
  toolbar: theme.mixins.toolbar
}));

const langs = Object.keys(languages);

const Settings = observer(() => {
  const classes = useStyles();

  return (
    <Fragment>
      <h1>{l.SETTINGS}</h1>
      <div className={classes.formItem}>
        <div className={classes.label}>{l.LANGUAGE}</div>
        <ToggleButtonGroup
          size="small"
          style={{ alignSelf: "center", marginTop: "20px" }}
          exclusive
          value={store.language.id}
        >
          {langs.map(key => (
            <ToggleButton
              value={languages[key].id}
              key={languages[key].id}
              onClick={e => store.setLanguage(e.currentTarget.value)}
            >
              <Flag code={languages[key].flag} className={classes.leftIcon} />
              {languages[key].label}
            </ToggleButton>
          ))}
        </ToggleButtonGroup>
      </div>
    </Fragment>
  );
});

export default Settings;
