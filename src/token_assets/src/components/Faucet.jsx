import React, { useState } from "react";
import { token, canisterId, createActor } from "../../../declarations/token";
import { AuthClient } from '@dfinity/auth-client';

function Faucet(props) {

  const [isDisabled, setDisable] = useState(false);
  const [buttonText, setButtonText] = useState("Gimme Gimme");

  async function handleClick(event) {
    setDisable(true);
    setButtonText(await token.payOut());
  }

  return (
    <div className="blue window">
      <h2>
        <span role="img" aria-label="tap emoji">
          🚰
        </span>
        Faucet
      </h2>
      <label>Get your free Dard tokens here! Claim 10,000 DRD coins to {props.userPrincipal}.</label>
      <p className="trade-buttons">
        <button id="btn-payout" onClick={handleClick} disabled={isDisabled}>
          {buttonText}
        </button>
      </p>
    </div>
  );
}

export default Faucet;
