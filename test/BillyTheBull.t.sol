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

    function testSolution() public {
        vm.createSelectFork(vm.envString("EVMNET_FORK_URL"), 17843232);
        bytes32 SALT = 0;
        CreationCodeProvider ccp = new CreationCodeProvider();
        bytes memory magicBytes = createMagicBytes(address(this), SALT, ccp.getAttackCreationCode() , abi.encode(address(level), address(ccp)));
        bytes32 solution = keccak256(magicBytes);
        address computedAddress = address(uint160(uint256(solution)));
        Attack attack = new Attack{salt: SALT}(address(level), address(ccp));
        require(address(attack) == computedAddress, "Addresses not equal");
        require(keccak256(attack.justGetMagicFlag()) == keccak256(magicBytes), "magic bytes not the same");

        // Work out tokenId1 and tokenId2
        uint256 start = level.generate(address(this));
        uint256 tokenId1 = start >> 128;
        uint256 tokenId2 = uint256(uint128(start));

        console.log("tokenId1 = %s , tokenId2 = %s", tokenId1, tokenId2);

        // Calculate increment amount
        uint256 incrementAmount = tokenId1 - level.nftPrice();
        console.log("nftPrice =      = %s", level.nftPrice());
        console.log("incrementAmount = %s", incrementAmount);

        curta.solve(15, uint256(solution));
    }

    // function notestJinuSolution() public {
    //     vm.createSelectFork(vm.envString("EVMNET_FORK_URL"), 17843232);

    //     player = 0x4a69B81A2cBEb3581C61d5087484fBda2Ed39605;
    //     vm.startPrank(player);

    //     uint256 forkId = vm.createFork(vm.envString("EVMNET_FORK_URL"), 17843233);
    //     // just perform the contract creation transaction
    //     vm.transact(forkId, 0xba33f65c46cbf22a752fe045996f6448f2338e4a02bbc7f7505faa33760435c5);

    //     console.log("%s", vm.toString(0x486F9F1DF7f011D3ae58e6cd200999E5915ca586.code));
    //     // // Create one more contract
    //     // string memory bytesAsString = "0x60806040818152600436101561001457600080fd5b600091823560e01c9081630d39fc811461025357508063150b7a021461010d578063690aae96146100e55780638da5cb5b146100be5763a04e646b1461005957600080fd5b346100ba57816003193601126100ba576100716102fb565b91815192839160208084528251928382860152825b8481106100a457505050828201840152601f01601f19168101030190f35b8181018301518882018801528795508201610086565b5080fd5b50346100ba57816003193601126100ba57905490516001600160a01b039091168152602090f35b50346100ba57816003193601126100ba5760015490516001600160a01b039091168152602090f35b50346100ba5760803660031901126100ba576001600160a01b036004358181160361024f57602435908116036100ba5760643567ffffffffffffffff80821161024b573660238301121561024b57816004013590811161024b57369101602401116100ba576f43bab70e5dd8287c88cb1cca5a1d4c1e6044351461019c575b51630a85bd0160e11b8152602090f35b81739c48ae1ae4c1a8bacca3a52aeb22657fa0a52d3b803b156100ba578190604484518094819363041161b160e41b83527f8dd77f04b1b7ff930ce89d672d57ca9543bab70e5dd8287c88cb1cca5a1d4c1e60048401527f04941ab0646689b6f3647954486f9f1df7f011d3ae58e6cd200999e5915ca58660248401525af1801561023f5760209350610230575b5061018c565b6102399061026f565b3861022a565b505051903d90823e3d90fd5b8380fd5b8280fd5b8390346100ba57816003193601126100ba576020906002548152f35b67ffffffffffffffff811161028357604052565b634e487b7160e01b600052604160045260246000fd5b6060810190811067ffffffffffffffff82111761028357604052565b90601f8019910116810190811067ffffffffffffffff82111761028357604052565b908160209103126102f657516001600160a01b03811681036102f65790565b600080fd5b600080549061030930610541565b604090815192638da5cb5b60e01b90818552602094739c48ae1ae4c1a8bacca3a52aeb22657fa0a52d3b908681600481855afa9081156104e5579061035591869161052a575b50610541565b856bffffffffffffffffffffffff60a01b9330858516178655600487518094819382525afa90811561052057906103929185916104f35750610541565b6001546001600160a01b0391908216803b156104ef578480916024885180948193634558d71760e01b835273e5608a36489fe45a8f08fd0c6b028801ce6b38d160048401525af180156104e5576104d2575b50169082541617815581516318160ddd60e01b8152838160048173e5220446640a68693761e6e7429965d82db4c4745afa9182156104c7578092610494575b50501561044e57636a696e7560e01b5a91519283015260248201526024815261044b81610299565b90565b80519181830183811067ffffffffffffffff821117610283577fd6944a69b81a2cbeb3581c61d5087484fbda2ed396052f00000000000000000092526017835282015290565b9091508382813d83116104c0575b6104ac81836102b5565b810103126104bd5750513880610423565b80fd5b503d6104a2565b8351903d90823e3d90fd5b6104de9094919461026f565b92386103e4565b86513d87823e3d90fd5b8480fd5b6105139150873d8911610519575b61050b81836102b5565b8101906102d7565b3861034f565b503d610501565b85513d86823e3d90fd5b6105139150883d8a116105195761050b81836102b5565b60008091604051602081019163161765e160e11b835260018060a01b031660248201526024815261057181610299565b51906a636f6e736f6c652e6c6f675afa5056fea2646970667358221220c2f255b73a21031e462a652953303b41d9435e6e0052303cc6a65c8bf5c3deba64736f6c63430008140033";
    //     // vm.etch(0x486F9F1DF7f011D3ae58e6cd200999E5915ca586, vm.parseBytes(bytesAsString));

    //     // uint256 start = level.generate(player);
    //     bool result = curta.solve(15, 2070928960849307239422656736499557531883358129155233575738070712546523653510);

    //     // level.verify(start, 2070928960849307239422656736499557531883358129155233575738070712546523653510);
    //     console.log("result = %s", result);

    // }

    // function notestChainlightSolution() public {
    //     vm.createSelectFork(vm.envString("EVMNET_FORK_URL"), 17843535);
    //     player = 0xB49bf876BE26435b6fae1Ef42C3c82c5867Fa149;
    //     vm.startPrank(player);

    //     level.verify(15677059489704813788781237196353174814172828311164112259534916405903994689373, 876945921415861996177457232047055113170687653836);
    //     IERC721(0xe5220446640A68693761e6e7429965D82db4c474).transferFrom(0x999B9d7980a2709000EdFA893d5557344EA477CC, 0x21E66240cC62AB55ce093af77084d007f35e5090, 46070737169132354891453603826207332189);
    //     bool result = curta.solve(15, 82072898835053368733015234053518728118332065667604516339771390844112889335952);

    //     // level.verify(start, 2070928960849307239422656736499557531883358129155233575738070712546523653510);
    //     console.log("result = %s", result);

    // }


    function computeCreate2Hash(address deployer, bytes32 salt, bytes memory creationCode, bytes memory abiEncodedParams) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(bytes1(0xff), deployer, salt, keccak256(abi.encodePacked(creationCode, abiEncodedParams))));
    }

    function createMagicBytes(address deployer, bytes32 salt, bytes memory creationCode, bytes memory abiEncodedParams) internal pure returns (bytes memory) {
        return abi.encodePacked(bytes1(0xff), deployer, salt, keccak256(abi.encodePacked(creationCode, abiEncodedParams)));
    }

}
