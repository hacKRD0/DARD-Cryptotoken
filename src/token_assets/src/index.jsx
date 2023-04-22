import ReactDOM from 'react-dom'
import React from 'react'
import App from "./components/App";
import { AuthClient } from '@dfinity/auth-client';

const init = async () => { 
  
  const authClient = await AuthClient.create();

  if (authClient.isAuthenticated()) {
    handleAuthenticated(authClient);
  } else {
    await authClient.login({
      identityProvider: "https://identity.ic0.app/#authorize",
      onSuccess: () => {
        handleAuthenticated(authClient);
      }
    });  
  }
  
  async function handleAuthenticated(authClient) {
    // const identity = authClient.getIdentity();
    const userPrincipal = "Local Principal";
    // userPrincipal = identity._pricipal.toString();
    ReactDOM.render(<App loggedInPrincipal={userPrincipal}/>, document.getElementById("root"));
  }
}


init();


