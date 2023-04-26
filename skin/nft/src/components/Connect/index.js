import React, { useState } from "react";
import classNames from "classnames";

const Connect = ({ config, data, onConnect, styles }) => {
  const [claimingNft, setClaimingNft] = useState(false);
  const [mintAmount, setMintAmount] = useState(1);
  const [feedback, setFeedback] = useState({
    message: `Select how many NFTs you want to mint, then click the Mint button to proceed`,
    error: false,
  });

  const decrementMintAmount = () => {
    let newMintAmount = mintAmount - 1;
    if (newMintAmount < 1) {
      newMintAmount = 1;
    }
    setMintAmount(newMintAmount);
  };

  const incrementMintAmount = () => {
    const { max_mint_amount } = config;
    let newMintAmount = mintAmount + 1;
    if (newMintAmount > parseInt(max_mint_amount)) {
      newMintAmount = parseInt(max_mint_amount);
    }
    setMintAmount(newMintAmount);
  };

  const claimNFTs = () => {
    const { wei_cost: cost, gas_limit: gasLimit, contract_address } = config;
    const totalCostWei = String(cost * mintAmount);
    const totalGasLimit = String(gasLimit * mintAmount);
    const { smartContract, account } = data;

    console.log("Cost: ", totalCostWei);
    console.log("Gas limit: ", totalGasLimit);
    setFeedback({ message: `Minting your NFT...` });
    setClaimingNft(true);

    smartContract.methods
      .mint(mintAmount)
      .send({
        gasLimit: String(totalGasLimit),
        to: contract_address,
        from: account,
        value: totalCostWei,
      })
      .once("error", (err) => {
        console.log(err);
        setFeedback({
          message: "Sorry, something went wrong please try again later.",
          error: true,
        });
        setClaimingNft(false);
      })
      .then((receipt) => {
        console.log(receipt);
        setFeedback({
          message: `WOW, the NFT is yours! go visit Opensea.io to view it.`,
        });
        setClaimingNft(false);
        // dispatch(fetchData(blockchain.account));
      });
  };

  const { classList, styles: style } = styles;

  return (
    <>
      {data.account === null ? (
        <>
          <button
            className={classList.join(" ")}
            style={{ ...style }}
            onClick={onConnect}
          >
            {style.text}
          </button>
        </>
      ) : (
        <>
          {config.show_quantity && <h2>{data.totalSupply} / {config.max_supply}</h2>}
          
          <div className="nft-mint">
            <div
              className={classNames("alert", {
                "alert-danger": feedback.error,
              })}
            >
              {feedback.message}
            </div>
            <p>
              <button
                className="btn btn-xs btn-info"
                onClick={(e) => {
                  e.preventDefault();
                  decrementMintAmount();
                }}
              >
                <i className="fa fa-minus"></i>
              </button>

              <span className="mint_amount">{mintAmount}</span>

              <button
                className="btn btn-xs btn-info"
                onClick={(e) => {
                  e.preventDefault();
                  incrementMintAmount();
                }}
              >
                <i className="fa fa-plus"></i>
              </button>
            </p>

            <button
              className={classList.join(" ")}
              style={{ ...style }}
              disabled={claimingNft ? 1 : 0}
              onClick={(e) => {
                e.preventDefault();
                claimNFTs();
              }}
            >
              MINT
            </button>
          </div>
        </>
      )}
    </>
  );
};

export default Connect;
