
// SPX-License-Identifier: MIT
pragma solidity ^0.8.0;
interface IFreeWilly {
    function mint(uint tokenId) external;
    function transferFrom(address _from, address _to, uint tokenId) external;
    function setApprovalForAll(address operator, bool approved) external;
}
