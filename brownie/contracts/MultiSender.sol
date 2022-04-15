// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "./interfaces/IERC721.sol";
import "./interfaces/IERC20.sol";
import "./Utils/Ownable.sol";

contract MultiSender is Ownable {
    function multiTokensSend(
        address[] memory recievers,
        uint256[] memory amounts,
        address tokenAddr
    ) public onlyOwner {
        for (uint256 i = 0; i < recievers.length; i++) {
            if (recievers[i] == address(0)) {
                revert("There is 0x0 Address provided!");
            } else {
                IERC20(tokenAddr).transferFrom(
                    address(this),
                    recievers[i],
                    amounts[i]
                );
            }
        }
    }

    function multiNftSend(
        address[] memory recievers,
        uint256[] memory ids,
        address nftAddr
    ) public onlyOwner {
        for (uint256 i = 0; i < recievers.length; i++) {
            if (recievers[i] == address(0)) {
                revert("There is 0x0 Address provided!");
            } else {
                IERC721(nftAddr).transferFrom(
                    address(this),
                    recievers[i],
                    ids[i]
                );
            }
        }
    }

    function multiNativeTokensSend(
        address[] memory recievers,
        uint256[] memory amounts
    ) public onlyOwner {
        for (uint256 i = 0; i < recievers.length; i++) {
            if (recievers[i] == address(0)) {
                revert("There is 0x0 Address provided!");
            } else {
                payable(recievers[i]).transfer(amounts[i]);
            }
        }
    }
}
