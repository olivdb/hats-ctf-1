import '@nomiclabs/hardhat-ethers'

import * as dotenv from 'dotenv'
import { HardhatUserConfig } from 'hardhat/config'

dotenv.config()

const config: HardhatUserConfig = {
  solidity: '0.8.13',
  networks: {
    hardhat: {
      forking: {
        url: process.env.RINKEBY_RPC_URL || 'https://rinkeby.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161',
      },
    },
  },
}

export default config
