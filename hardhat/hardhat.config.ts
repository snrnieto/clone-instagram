import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-foundry";
import dotenv from "dotenv";
dotenv.config();

const AVAX_PRIVATE_KEY = process.env.AVAX_PRIVATE_KEY || "";
if (!AVAX_PRIVATE_KEY) {
  throw new Error("AVAX_PRIVATE_KEY must be set in .env file");
  
}
const config: HardhatUserConfig = {
  solidity: "0.8.24",
  networks: {
    avaxFuji: {
      url: "https://api.avax.network/ext/bc/C/rpc",
      accounts: ["0x"+AVAX_PRIVATE_KEY]
    },
    avalanche:{
      url: "https://api.avax.network/ext/bc/C/rpc",
      accounts: ["0x"+AVAX_PRIVATE_KEY]
    }
  }
};

export default config;
