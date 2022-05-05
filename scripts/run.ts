import 'dotenv/config'
import { getRinkebySdk } from '.dethcrypto/eth-sdk-client'
import { assert } from 'chai'

const hre = require('hardhat')

async function main() {
  const accounts = await hre.ethers.getSigners()
  const signer = accounts[0]
  const game = getRinkebySdk(signer).Game

  let flagHolder = await game.flagHolder()
  console.log('Initial flag holder:', flagHolder)

  const Cheater = await hre.ethers.getContractFactory('Cheater')
  const cheater = await Cheater.deploy()
  await cheater.deployed()
  console.log('Cheater deployed to:', cheater.address)

  console.log('Running cheater...')
  await cheater.cheat()

  flagHolder = await game.flagHolder()
  console.log('New flag holder:', flagHolder)
  assert(flagHolder === cheater.address)
  console.log('Flag captured by cheater!')
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
