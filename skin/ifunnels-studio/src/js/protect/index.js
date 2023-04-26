import "../../scss/protect/protect.scss";

import SignIn from "./signin";
import { getTokenFromURL, setTokenOnLinks } from "../token";

document.addEventListener("DOMContentLoaded", () => {
  const token = getTokenFromURL();

  if (token) {
    window.config.token = token;
    setTokenOnLinks({ token });
  }

  window.refs = {
    signIn: new SignIn(),
  };
});
