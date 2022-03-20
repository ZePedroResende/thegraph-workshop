all: clean install update build

clean  :; forge clean

install :; forge install

update:; forge update

build  :; forge clean && forge build

test   :; forge clean && forge test

lint :; prettier --write src/**/*.sol && prettier --write src/*.sol

snapshot :; forge clean && forge snapshot

mainnet-fork :; npx hardhat node --fork ${ETH_MAINNET_RPC_URL}
