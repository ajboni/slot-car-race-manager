import React, { useEffect } from "react";
import Layout from "./components/layout";
import {
  BrowserRouter as Router,
  Switch,
  Route,
  Link,
  Redirect
} from "react-router-dom";
import { createMuiTheme } from "@material-ui/core/styles";
import { ThemeProvider } from "@material-ui/styles";
import Store from "./store";
import { ApolloProvider } from "react-apollo";
import { client } from "./apollo";
import { ApolloProvider as ApolloHooksProvider } from "@apollo/react-hooks";

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

Store.init();

function App() {
  return (
    <ApolloProvider client={client}>
      <ApolloHooksProvider client={client}>
        <ThemeProvider theme={theme}>
          <Router>
            <Layout />
          </Router>
        </ThemeProvider>
      </ApolloHooksProvider>
    </ApolloProvider>
  );
}

export default App;
