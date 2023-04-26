export default class Helper {
  static networkName(network_id) {
    switch (network_id) {
      case "137": {
        return "Polygon";
      }

      case "1": {
        return "Ethereum Mainnet";
      }

      case "4": {
        return "Rinkeby";
      }

      case "3": {
        return "Ropsten";
      }

      case "5": {
        return "Goerli";
      }

      default: {
        return "Undefined network";
      }
    }
  }
}
