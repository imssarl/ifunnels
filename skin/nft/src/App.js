import React from "react";
import Web3EthContract from "web3-eth-contract";
import Web3 from "web3";
import SaleEnded from "./components/SaleEnded";
import Connect from "./components/Connect";
import Helper from "./includes/Helper";

class App extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      config: {},
      abi: {},
      styles: {},
      loading: true,
      data: {
        totalSupply: 0,
        web3: null,
        account: null,
        smartContract: null,
      },
      alert: "",
    };
  }

  async componentDidMount() {
    const abiResponse = await fetch("/bundles/abi.json", {
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
      },
    });

    const abi = await abiResponse.json();

    const configResponse = await fetch("/bundles/config.json", {
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
      },
    });

    const config = await configResponse.json();

    const stylesResponse = await fetch("/bundles/styles.json", {
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
      },
    });

    const styles = await stylesResponse.json();
    this.setState({ config, abi, styles, loading: false });

    if (!(window.ethereum && window.ethereum.isMetaMask)) {
      this.setState({ alert: "Install or enable Metamask." });
    }
  }

  async connect(e) {
    e.preventDefault();

    const { ethereum } = window;
    const metamaskIsInstalled = ethereum && ethereum.isMetaMask;
    const { config, abi, data } = this.state;

    if (metamaskIsInstalled) {
      Web3EthContract.setProvider(ethereum);
      let web3 = new Web3(ethereum);

      try {
        const accounts = await ethereum.request({
          method: "eth_requestAccounts",
        });

        const networkId = await ethereum.request({
          method: "net_version",
        });

        if (networkId == config.network) {
          const SmartContractObj = new Web3EthContract(
            abi,
            config.contract_address
          );

          const totalSupply = await SmartContractObj.methods
            .totalSupply()
            .call();

          this.setState({
            data: {
              ...data,
              totalSupply,
              account: accounts[0],
              smartContract: SmartContractObj,
              web3,
            },
          });

          // Add listeners start
          ethereum.on("accountsChanged", (accounts) => {
            this.setState({ data: { ...data, account: accounts[0] } });
          });

          ethereum.on("chainChanged", () => {
            window.location.reload();
          });
          // Add listeners end
        } else {
          this.setState({ alert: `Change network to ${Helper.networkName(config.network)}.` });
          console.log(`Change network to ${config.network}.`);
        }
      } catch (err) {
        console.log(err);
      }
    } else {
      console.log(`Install Metamask.`);
    }
  }

  render() {
    const { config, data, styles, loading, alert } = this.state;

    if (loading) {
      return <p>Loading...</p>;
    }

    return (
      <>
        {alert.length > 0 && (
          <div className="alert alert-danger text-white">{alert}</div>
        )}

        {parseInt(config.max_supply) > parseInt(data.totalSupply) ? (
          <Connect
            config={config}
            data={data}
            styles={styles}
            onConnect={this.connect.bind(this)}
          />
        ) : (
          <SaleEnded />
        )}
      </>
    );
  }
}

export default App;
