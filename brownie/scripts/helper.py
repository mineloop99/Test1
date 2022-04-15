from brownie import accounts, config, network, MultiSender

NETWORKS = ["rinkeby"]


def get_account():
    if network.show_active() in NETWORKS:
        account = accounts.add(config["wallets"]["private_key"])
    account = accounts[0]
    return account


def deploy_contract(account):
    Contract = MultiSender.deploy({"from": account})
    return Contract
