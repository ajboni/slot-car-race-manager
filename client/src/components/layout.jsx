import React from "react";
import Sidebar from "./sidebar";
import Header from "./header";
import { CssBaseline, makeStyles } from "@material-ui/core";
import Footer from "./footer";
import Content from "./content";

const useStyles = makeStyles(theme => ({
  root: {
    display: "flex"
  }
}));

function Layout() {
  const classes = useStyles();

  return (
    <div className={classes.root}>
      <CssBaseline />
      {/* <Header /> */}
      <Sidebar />
      <Content />
      {/* <Footer /> */}
    </div>
  );
}

export default Layout;
