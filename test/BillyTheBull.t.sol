// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { IERC721 } from "../src/interfaces/IERC721.sol";

import "forge-std/Test.sol";
import { BillyTheBull } from "../src/BillyTheBull.sol";
import { Attack } from "../src/Attack.sol";
import { CreationCodeProvider } from "../src/CreationCodeProvider.sol";

interface ICurta {
    function solve(uint32 _puzzleId, uint256 _solution) external returns (bool);
}

interface IFreeWilly {
    function mint(uint tokenId) external;
}

contract BillyTheBullTest is Test {
    BillyTheBull public level;

    address player;
    ICurta curta = ICurta(0x0000000006bC8D9e5e9d436217B88De704a9F307);

    IFreeWilly freeWilly = IFreeWilly(0xe5608a36489Fe45a8f08fD0c6B028801cE6B38d1);
    IERC721 rippedJesus = IERC721(0xe5220446640A68693761e6e7429965D82db4c474);

    function setUp() public {
        player = address(this);
        level = BillyTheBull(0x9C48aE1Ae4C1a8BACcA3a52AEb22657FA0a52D3B);
    }

    function test100proofSolution() public {
        vm.createSelectFork(vm.envString("EVMNET_FORK_URL"), 17843232);
        bytes32 SALT = 0;
        CreationCodeProvider ccp = new CreationCodeProvider();
        bytes memory magicBytes = createMagicBytes(address(this), SALT, ccp.getAttackCreationCode() , abi.encode(address(level), address(ccp)));
        bytes32 solution = keccak256(magicBytes);
        address computedAddress = address(uint160(uint256(solution)));
        Attack attack = new Attack{salt: SALT}(address(level), address(ccp));
        require(address(attack) == computedAddress, "Addresses not equal");
        require(keccak256(attack.justGetMagicFlag()) == keccak256(magicBytes), "magic bytes not the same");

        curta.solve(15, uint256(solution));
    }

    function notestChainlightSolution() public {
        vm.createSelectFork(vm.envString("EVMNET_FORK_URL"), 17843535);
        player = 0xB49bf876BE26435b6fae1Ef42C3c82c5867Fa149;
        vm.startPrank(player);

        level.verify(15677059489704813788781237196353174814172828311164112259534916405903994689373, 876945921415861996177457232047055113170687653836);
        IERC721(0xe5220446640A68693761e6e7429965D82db4c474).transferFrom(0x999B9d7980a2709000EdFA893d5557344EA477CC, 0x21E66240cC62AB55ce093af77084d007f35e5090, 46070737169132354891453603826207332189);
        curta.solve(15, 82072898835053368733015234053518728118332065667604516339771390844112889335952);
    }


    function computeCreate2Hash(address deployer, bytes32 salt, bytes memory creationCode, bytes memory abiEncodedParams) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(bytes1(0xff), deployer, salt, keccak256(abi.encodePacked(creationCode, abiEncodedParams))));
    }

    function createMagicBytes(address deployer, bytes32 salt, bytes memory creationCode, bytes memory abiEncodedParams) internal pure returns (bytes memory) {
        return abi.encodePacked(bytes1(0xff), deployer, salt, keccak256(abi.encodePacked(creationCode, abiEncodedParams)));
    }

}
