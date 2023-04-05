# Deposits and Withdrawals (L)

We are not into DeFi here, but Lending and Borrowing is a good concept to work with tokens. The protocols like AAVE and Compound allow users to deposit and withdraw the tokens. AAVE for example allows for the deposit of USDC and returns an equivalent amount of aUSDC, and so does Compound protocol. These are called receipt tokens. Let us create a sample version of the same.

## Requirements

Create a lending and borrowing contract that does the following things

    1. It allows for the deposit of a whitelisted set of tokens for example WBTC,. But should not allows any other tokens to be deposited. 
    2. Search for these tokens from the ethereum mainnet and deploy the contracts in our developer environment
    3. As the developer of the Lending and Borrowing protocol create receipt tokens for the above tokens.
    4. Mint the equivalent number of receipt tokens (rWBTC) to the sender for the amount of (wBTC) tokens deposited. 
    5. On withdrawal, the user shall send the receipt tokens to receive the equivalent number of WBTC tokens. The receipt tokens shall be burned.
    6. (Optional) Add feasibility so that the Protocol owner shall be able to add more tokens to the allowed list

<aside>
📑 **Hint**: Understand the usage of approve function and use it when required.

</aside>