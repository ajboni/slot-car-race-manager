import React from "react";
import { makeStyles } from "@material-ui/core/styles";
import Drawer from "@material-ui/core/Drawer";
import List from "@material-ui/core/List";
import Divider from "@material-ui/core/Divider";
import ListItem from "@material-ui/core/ListItem";
import ListItemIcon from "@material-ui/core/ListItemIcon";
import ListItemText from "@material-ui/core/ListItemText";
import InboxIcon from "@material-ui/icons/MoveToInbox";
import MailIcon from "@material-ui/icons/Mail";
import { routes } from "../constants/routes";
import { languages } from "../constants/constants";
import * as c from "../constants/constants";
import Flag from "react-world-flags";
import { IconButton, Button, ButtonGroup, Icon } from "@material-ui/core";
import logo from "../img/car.png";

const drawerWidth = 240;

const useStyles = makeStyles(theme => ({
  root: {
    display: "flex"
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
  toolbar: theme.mixins.toolbar
}));

function Sidebar() {
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
          <ListItem button key={route.target}>
            <ListItemIcon>
              <Icon>{route.icon}</Icon>
            </ListItemIcon>
            <ListItemText primary={route.label} />
          </ListItem>
        ))}
      </List>
      <Divider />

      <ButtonGroup
        size="small"
        style={{ alignSelf: "center", marginTop: "20px" }}
      >
        {Object.keys(languages).map(key => (
          <Button
            variant="contained"
            color="default"
            className={classes.button}
          >
            <Flag
              code={languages[key].code}
              fallback={<span>Unknown</span>}
              className={classes.leftIcon}
            />
            {languages[key].label}
          </Button>
        ))}
      </ButtonGroup>
    </Drawer>
  );
}

export default Sidebar;
