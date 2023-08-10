pragma solidity ^0.8.0;

import { Attack } from "./Attack.sol";

contract CreationCodeProvider {

  function getAttackCreationCode() external pure returns (bytes memory) {
    return type(Attack).creationCode;
  }

}