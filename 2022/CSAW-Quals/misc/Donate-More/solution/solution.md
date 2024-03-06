# Solution 
This challenge is based on the Reentrancy vulnerability and attacking it, which is one of the most common vulnerability in smart contract developing. 

Bascially this smart contract is acting as a donation box for CSAW. Users can donate amount to the smart contract but only one. While creating account automatically 10 units is added to the account and contract gets 1 ether. Apart from that 10 units can be added if user wishes to donate more amount but only once and in return they get their 1 ether back. There is more to that also if he/she can donate more amount than once through Reentrancy attack on this smart contract and they get the flag from admins.

Attack file: attackBlockchainChallenge.sol
Test Network: Ropsten
IDE: Remix

Vulnerability is there in line 20 of `blockchainChallenge.sol`, where call method is used to transfer 1 ether to function caller. This transaction of crypto can be catched by a receive function which is a fallback function to receive any ether from external contracts or EOA when there is a matching function in the smart contract.

In attack file we initilise the constructors and the write the attack function which calls the newAccount() to create a account in the donator contract by giving 1 ether for advance. Then calling donateOnce() function to donate more 10 units. When this function is called, balances is increased by 10 units and 1 ether is send back to us. For capturing this ether we use receive() which is fallback function. Also we call the donateOnce() function again with this, therefore the doneDonating boolean is still false and we reentered the donateOnce() function. This will increase the balance of our account in the contract. Through this we satisfy the requirement of getFlag() function for claiming our flag. 

