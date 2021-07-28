pragma solidity ^0.5.0;

import "./BillyCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

contract BillyCoinSale is Crowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale, MintedCrowdsale {

    constructor(
        uint rate,
        address payable wallet,
        BillyCoin token,
        uint goal,
        uint open,
        uint close
    )
        Crowdsale(rate, wallet, token) // Pass the constructor parameters to the crowdsale contracts.
        TimedCrowdsale(now, now + 24 weeks)
        CappedCrowdsale(goal)
        RefundableCrowdsale(goal)
        public
    {
        // constructor can stay empty
    }
}

contract BillyCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet,
        uint goal
    )
        public
    {
        BillyCoin token = new BillyCoin(name, symbol, 0);
        token_address = address(token);

        BillyCoinSale token_sale = new BillyCoinSale(10, wallet, token, goal, now, now + 24 weeks);
        token_sale_address = address(token_sale);
        
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}