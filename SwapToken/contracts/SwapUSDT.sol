// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;

// pragma solidity >=0.7.6 <=0.8.19;

pragma abicoder v2;

import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';


interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract SwapUSDT {

    mapping(string => uint256) public tokenBucket;
    address public routerAddress;
    ISwapRouter public  swapRouter;
    address public  DAI ;
    address public  WETH9 ;
    address public USDT;
    address public WBTC;
    address public LINK;
    // For this example, we will set the pool fee to 0.3%.
    uint24 public constant poolFee = 3000;


function initVars(address routeraddr, address dai, address weth, address wbtc, address link, address usdt,
                uint256 daipercent, uint256 wethpercent, uint256 wtbcpercent, uint256 linkpercent) public {
             
        //It's same for testnet and mainnet so hardcoded it
            routerAddress = routeraddr;
            swapRouter = ISwapRouter(routerAddress); //IMulticall(routerAddress);// ISwapRouter(routerAddress);
             DAI = dai;
             WETH9 = weth;
             WBTC = wbtc;
             LINK = link;
             USDT = usdt;
             tokenBucket["DAI"] = daipercent;
             tokenBucket["WETH"] = wethpercent;
             tokenBucket["WBTC"] = wtbcpercent;
             tokenBucket["LINK"] = linkpercent;
            
        /*
        routerAddress = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
        swapRouter = ISwapRouter(routerAddress); //IMulticall(routerAddress);// ISwapRouter(routerAddress);
             DAI = 0x11fE4B6AE13d2a6055C8D9cF65c55bac32B5d844;
             WETH9 = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;
             USDC = 0x07865c6E87B9F70255377e024ace6630C1Eaa37F;
           //  WASMYT = 0x4c50BbD740fCc670B213144031D1965adB3d5a70 ;
             USDT = 0x509Ee0d083DdF8AC028f2a56731412edD63223B9;
             WBTC = 0xC04B0d3107736C32e19F1c62b2aF67BE61d63a05;
             LINK=0x326C977E6efc84E512bB9C30f76E30c160eD06FB;//= 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;
             bucket = CoinBucket(30,30,40);
             tokenBucket["DAI"] = 30;
             tokenBucket["WETH"] = 30;
             tokenBucket["WBTC"] = 20;
             tokenBucket["LINK"] = 20;
        */
             
    }
    function fetchPercentSwap(string memory tokenid, uint256 amoountIn) public view returns(uint256) {
       
       uint256 percent = tokenBucket[tokenid];
       return  (amoountIn * percent) / 100;

    }

    function swapToDai(uint256 amountIn, bool isSwappedValue) public   {
       
           if(isSwappedValue == true) {
                IERC20(USDT).transferFrom(msg.sender, address(this), amountIn);
                IERC20(USDT).approve(address(swapRouter), amountIn);

                ISwapRouter.ExactInputSingleParams memory params =
                ISwapRouter.ExactInputSingleParams({
                    tokenIn: USDT,
                    tokenOut: DAI,//WETH9,
                    fee: poolFee,
                    recipient: msg.sender,
                    deadline: block.timestamp,
                    amountIn: amountIn,
                    amountOutMinimum: 0,
                    sqrtPriceLimitX96: 0
                });
                swapRouter.exactInputSingle(params);
           } else {
                uint256 swapAmt = fetchPercentSwap("DAI",amountIn);
                IERC20(USDT).transferFrom(msg.sender, address(this), swapAmt);
                IERC20(USDT).approve(address(swapRouter), swapAmt);

                ISwapRouter.ExactInputSingleParams memory params =
                ISwapRouter.ExactInputSingleParams({
                    tokenIn: USDT,
                    tokenOut: DAI,//WETH9,
                    fee: poolFee,
                    recipient: msg.sender,
                    deadline: block.timestamp,
                    amountIn: swapAmt,
                    amountOutMinimum: 0,
                    sqrtPriceLimitX96: 0
                });
                swapRouter.exactInputSingle(params);

           }
           

    }

    function swapToWETH9(uint256 amountIn,bool isSwappedValue) public   {
            //https://goerli.etherscan.io/tx/0x2b09a7b57486c0be9b006a7a3cd5b3969f0fbedcc26965d8e5ce701a68975e6a

            if(isSwappedValue == true) {

                IERC20(USDT).transferFrom(msg.sender, address(this), amountIn);
                IERC20(USDT).approve(address(swapRouter), amountIn);

                ISwapRouter.ExactInputSingleParams memory params =
                ISwapRouter.ExactInputSingleParams({
                    tokenIn: USDT,
                    tokenOut: WETH9,
                    fee: poolFee,
                    recipient: msg.sender,
                    deadline: block.timestamp,
                    amountIn: amountIn,
                    amountOutMinimum: 0,
                    sqrtPriceLimitX96: 0
                });
                swapRouter.exactInputSingle(params);

            } else {

                uint swapAmt = fetchPercentSwap("WETH",amountIn);
                IERC20(USDT).transferFrom(msg.sender, address(this), swapAmt);
                IERC20(USDT).approve(address(swapRouter), swapAmt);

                ISwapRouter.ExactInputSingleParams memory params =
                ISwapRouter.ExactInputSingleParams({
                    tokenIn: USDT,
                    tokenOut: WETH9,
                    fee: poolFee,
                    recipient: msg.sender,
                    deadline: block.timestamp,
                    amountIn: swapAmt,
                    amountOutMinimum: 0,
                    sqrtPriceLimitX96: 0
                });
                swapRouter.exactInputSingle(params);

            }
           

    }

    function swaptoWTBC(uint amountIn, bool isSwappedValue) public {
           
           if(isSwappedValue == true) {

                IERC20(USDT).transferFrom(msg.sender, address(this), amountIn);
                IERC20(USDT).approve(address(swapRouter), amountIn);

                ISwapRouter.ExactInputSingleParams memory params =
                ISwapRouter.ExactInputSingleParams({
                    tokenIn: USDT,
                    tokenOut: WBTC,
                    fee: poolFee,
                    recipient: msg.sender,
                    deadline: block.timestamp,
                    amountIn: amountIn,
                    amountOutMinimum: 0,
                    sqrtPriceLimitX96: 0
                });
                swapRouter.exactInputSingle(params);

           } else {
                uint swapAmt = fetchPercentSwap("WBTC",amountIn);
                IERC20(USDT).transferFrom(msg.sender, address(this), swapAmt);
                IERC20(USDT).approve(address(swapRouter), swapAmt);

                ISwapRouter.ExactInputSingleParams memory params =
                ISwapRouter.ExactInputSingleParams({
                    tokenIn: USDT,
                    tokenOut: WBTC,
                    fee: poolFee,
                    recipient: msg.sender,
                    deadline: block.timestamp,
                    amountIn: swapAmt,
                    amountOutMinimum: 0,
                    sqrtPriceLimitX96: 0
                });
                swapRouter.exactInputSingle(params);

           }
         
    }
    
    function swaptoLink(uint amountIn,  bool isSwappedValue) public {
            
            if(isSwappedValue == true) {

                IERC20(USDT).transferFrom(msg.sender, address(this), amountIn);
                IERC20(USDT).approve(address(swapRouter), amountIn);

                ISwapRouter.ExactInputSingleParams memory params =
                ISwapRouter.ExactInputSingleParams({
                    tokenIn: USDT,
                    tokenOut: LINK,
                    fee: poolFee,
                    recipient: msg.sender,
                    deadline: block.timestamp,
                    amountIn: amountIn,
                    amountOutMinimum: 0,
                    sqrtPriceLimitX96: 0
                });
                swapRouter.exactInputSingle(params);
            } else {    
                uint swapAmt = fetchPercentSwap("LINK",amountIn);
                IERC20(USDT).transferFrom(msg.sender, address(this), swapAmt);
                IERC20(USDT).approve(address(swapRouter), swapAmt);

                ISwapRouter.ExactInputSingleParams memory params =
                ISwapRouter.ExactInputSingleParams({
                    tokenIn: USDT,
                    tokenOut: LINK,
                    fee: poolFee,
                    recipient: msg.sender,
                    deadline: block.timestamp,
                    amountIn: swapAmt,
                    amountOutMinimum: 0,
                    sqrtPriceLimitX96: 0
                });
                swapRouter.exactInputSingle(params);
            }
    }

    function swap(uint256 wbtcamt, uint256 linkamt, uint256 wethamt, uint256 daiamt) public payable  returns (bytes[] memory results) {
        
        bytes[] memory callData = new bytes[](4);
        callData[0] = abi.encodeWithSelector(this.swapToDai.selector,fetchPercentSwap("DAI",daiamt),true); 
        callData[1] = abi.encodeWithSelector(this.swapToWETH9.selector,fetchPercentSwap("WETH",wethamt),true);
        callData[2] = abi.encodeWithSelector(this.swaptoWTBC.selector,fetchPercentSwap("WBTC",wbtcamt),true);
        callData[3] = abi.encodeWithSelector(this.swaptoLink.selector,fetchPercentSwap("LINK",linkamt),true);

        results = new bytes[](callData.length);

        for (uint256 i = 0; i < callData.length; i++) {
            (bool success, bytes memory result) = address(this).delegatecall(callData[i]);

            if (!success) {
                if (result.length < 68) revert();
                assembly {
                    result := add(result, 0x04)
                }
                revert(abi.decode(result, (string)));
            }
            results[i] = result;
        }

    }

}

/*

78.72594 USDC
6484.96354 DAI

0x8fcD64e3dBc59E7a373a60c7D8bAdce6EfF68852 usdc -> weth
0xD0Fb5AC66953A5C1e68cBDcD95983131e313426d usdc -> dai
*/

/* mainnet addresess
usdt https://etherscan.io/address/0xdac17f958d2ee523a2206206994597c13d831ec7
dai https://etherscan.io/token/0x6b175474e89094c44da98b954eedeac495271d0f
link : https://etherscan.io/token/0x514910771af9ca656af840dff83e8264ecf986ca
weth : https://etherscan.io/address/0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2
usdc : https://etherscan.io/token/0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48
*/