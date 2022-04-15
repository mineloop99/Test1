from brownie import TestNFT, TestToken

from scripts.helper import get_account, deploy_contract

from brownie.network.web3 import Web3
import pytest


@pytest.mark.first
def test_deploy_and_send():
    # Deploy Contract
    account = get_account()
    token = TestToken.deploy({"from": account})
    nft = TestNFT.deploy({"from": account})
    multiSenderContract = deploy_contract(account)
    amount = 1000000000000000000
    # Mint tokens
    token.mint(multiSenderContract.address, amount, {"from": account})
    # Mint nft
    nft.mintMany(
        [
            multiSenderContract.address,
            multiSenderContract.address,
            multiSenderContract.address,
        ],  # reciepient
        ["1", "2", "3"],  # string datas
        {"from": account},
    )
    print(multiSenderContract.address)
    # test balance token
    assert token.balanceOf(multiSenderContract.address) == amount
    # test nft
    assert nft.balanceOf(multiSenderContract.address) == 3
    for i in range(3):
        assert nft.ownerOf(i) == multiSenderContract.address
    # test MultiSender Groups
    bob = "0x12Af6B31a61eC9F030849a3953394A69a1f9f9eC"
    alice = "0x35Af6B31a61eC9F030849a3942394A69a1f9f9eC"
    john = "0x366f6B31a61eC9F030849a3953394A69a1f9f9eC"
    # test Token Multisender
    amount1 = 50000000
    amount2 = 123000012
    amount3 = 1001231000
    multiSenderContract.multiTokensSend(
        [bob, alice, john],  # reciepient
        [amount1, amount2, amount3],  # ids
        token.address,
        {"from": account},
    )
    assert token.balanceOf(bob) == amount1
    assert token.balanceOf(alice) == amount2
    assert token.balanceOf(john) == amount3

    # test NFT Multisender
    multiSenderContract.multiTokensSend(
        [bob, alice, john],  # reciepient
        [0, 1, 2],  # ids
        nft.address,
        {"from": account},
    )
    assert token.ownerOf(0) == bob
    assert token.ownerOf(1) == alice
    assert token.ownerOf(2) == john

    # test Native Tokens Multisender
    multiSenderContract.multiNativeTokensSend(
        [bob, alice, john],  # reciepient
        [amount1, amount2, amount3],  # ids
        {"from": account},
    )

    assert Web3.eth.get_balance(bob) == amount1
    assert Web3.eth.get_balance(alice) == amount2
    assert Web3.eth.get_balance(john) == amount3
