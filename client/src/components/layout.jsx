import React from "react";
import Sidebar from "./sidebar";
import Header from "./header";
import { CssBaseline } from "@material-ui/core";

function Layout() {
  return (
    <div>
      <CssBaseline />
      <Header />
      <Sidebar />
    </div>
  );
}

export default Layout;
