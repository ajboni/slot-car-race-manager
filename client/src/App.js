import React from "react";
import Layout from "./components/layout";

import { createMuiTheme } from "@material-ui/core/styles";
import { ThemeProvider } from "@material-ui/styles";
import Store from "./store";

const theme = createMuiTheme({
  palette: {
    primary: {
      main: "#015C79"
    },
    secondary: {
      main: "#2979ff"
    }
  }
});

function App() {
  return (
    <ThemeProvider theme={theme}>
      <Layout />
    </ThemeProvider>
  );
}

export default App;
