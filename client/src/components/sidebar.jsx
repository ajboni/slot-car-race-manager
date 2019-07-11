import React from "react";
import { makeStyles } from "@material-ui/core/styles";
import Drawer from "@material-ui/core/Drawer";
import List from "@material-ui/core/List";
import Divider from "@material-ui/core/Divider";
import ListItem from "@material-ui/core/ListItem";
import ListItemIcon from "@material-ui/core/ListItemIcon";
import ListItemText from "@material-ui/core/ListItemText";
import { routes } from "../constants/routes";
import { languages } from "../constants/constants";
import Flag from "react-world-flags";

import { Button, ButtonGroup, Icon } from "@material-ui/core";
import ToggleButton from "@material-ui/lab/ToggleButton";
import ToggleButtonGroup from "@material-ui/lab/ToggleButtonGroup";
import logo from "../img/car.png";
import store from "../store";
import { observer } from "mobx-react";
import { Route, Link, BrowserRouter as Router } from "react-router-dom";
import l from "../constants/lang";

const drawerWidth = 240;

const useStyles = makeStyles(theme => ({
  root: {
    display: "flex",
    backgroundColor: "#333"
  },
  drawer: {
    width: drawerWidth,
    flexShrink: 0
  },
  drawerPaper: {
    width: drawerWidth
  },
  leftIcon: {
    marginRight: theme.spacing(1),
    width: "25px"
  },
  toggleContainer: {
    margin: theme.spacing(2, 0)
  },
  a: {
    textDecoration: "none"
  },
  toolbar: theme.mixins.toolbar
}));

const langs = Object.keys(languages);
// console.log(langs);

const Sidebar = observer(() => {
  const classes = useStyles();
  return (
    <Drawer
      className={classes.drawer}
      variant="permanent"
      classes={{
        paper: classes.drawerPaper
      }}
      anchor="left"
    >
      <img src={logo} style={{ width: "100%", height: "100" }} />
      {/* <div className={classes.toolbar}>
      </div> */}
      <Divider />
      <List>
        {routes.map(route => (
          <Link
            style={{ textDecoration: "none", color: "inherit" }}
            to={route.target}
            key={route.target}
          >
            <ListItem button key={route.target}>
              <ListItemIcon>
                <Icon>{route.icon}</Icon>
              </ListItemIcon>
              <ListItemText primary={route.label} />
            </ListItem>
          </Link>
        ))}
      </List>
      <Divider />
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
    </Drawer>
  );
});

export default Sidebar;
