import React from "react";
import ReactDOM from "react-dom";
import App from "./App.js";
import "!style-loader!css-loader!sass-loader!./scss/index.scss";

ReactDOM.render(<App />, document.querySelector('[data-component="nft"]'));
