pragma solidity ^0.5.0;

import "./ERC20.sol";
import "./KyberNetworkProxyInterface.sol";

// DO NOT SEND ERC20 TOKENS TO THIS CONTRACT!
/// @title Simple contract to convert ETH to token with kyber 
contract KyberQuick {
    
    address public owner;
    address public tokenAddr;
    
    // Mainnet
    address constant KYBER_INTERFACE = 0x818E6FECD516Ecc3849DAf6845e3EC868087B755;
    address constant ETHER_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    
    constructor(address _tokenAddr) public {
        owner = msg.sender;
        tokenAddr = _tokenAddr;
    }
    
    function() payable external {
        swapEtherToToken(msg.value, tokenAddr);
    }
    
    function swapEtherToToken (uint _ethAmount, address _tokenAddr) internal {
        uint minRate;
        ERC20 ETH_TOKEN_ADDRESS = ERC20(ETHER_ADDRESS);
        ERC20 token = ERC20(_tokenAddr);

        KyberNetworkProxyInterface _kyberNetworkProxy = KyberNetworkProxyInterface(KYBER_INTERFACE);

        (, minRate) = _kyberNetworkProxy.getExpectedRate(ETH_TOKEN_ADDRESS, token, _ethAmount);

        _kyberNetworkProxy.trade.value(_ethAmount)(
            ETH_TOKEN_ADDRESS,
            _ethAmount,
            token,
            msg.sender,
            uint(-1),
            minRate,
            owner
        );

    }
    
    
    // ONLY OWNER, IF TOKENS GET STUCK
    function withdrawToken(address _tokenAddr, uint _amount) public {
        require(msg.sender == owner, "Must be the owner");
        
        ERC20(_tokenAddr).transfer(owner, _amount);
    }
    
    function withdrawEth(uint _amount) public {
        require(msg.sender == owner, "Must be the owner");
        
        msg.sender.transfer(_amount);
    }
}