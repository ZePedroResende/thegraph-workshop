import { BigInt, Bytes } from "@graphprotocol/graph-ts";
import {
  Factory,
  Create721,
  RoleAdminChanged,
  RoleGranted,
  RoleRevoked
} from "../generated/Factory/Factory";
import { Transfer } from "../generated/templates/PayableERC721Upgradeable/PayableERC721Upgradeable";
import * as PayableERC721UpgradeableTemplates from "../generated/templates/PayableERC721Upgradeable/PayableERC721Upgradeable";
import { PayableERC721Upgradeable } from "../generated/templates";
import { Collection, Asset } from "../generated/schema";

export function handleCreate721(event: Create721): void {
  let proxy = event.params.proxy;
  let name = event.params.name;
  let symbol = event.params.symbol;
  let baseURI = event.params.baseURI;
  let mintPrice = event.params.mintPrice;
  let maxSupply = event.params.maxSupply;
  let launchDate = event.params.launchDate;
  let payout = event.params.payout;
  let creator = event.params.creator;

  let collection = new Collection(proxy.toHex());

  collection.address = proxy;
  collection.name = name;
  collection.symbol = symbol;
  collection.baseURI = baseURI;
  collection.mintPrice = mintPrice;
  collection.maxSupply = maxSupply;
  collection.currentSupply = BigInt.fromI32(0);
  collection.launchDate = launchDate;
  collection.payout = payout;
  collection.creator = creator;
  collection.status =
    event.block.timestamp < launchDate ? "pending" : "ongoing";
  collection.createdAt = event.block.timestamp;
  collection.updatedAt = event.block.timestamp;

  collection.save();

  PayableERC721Upgradeable.create(proxy);
}

export function handleTransfer(event: Transfer): void {
  let from = event.params.from;
  let to = event.params.to;
  let tokenId = event.params.tokenId;
  let contractAddress = event.address;

  let asset = new Asset(contractAddress.toString() + tokenId.toString());

  asset.tokenId = tokenId;
  asset.contractAddress = contractAddress;
  asset.owner = to;
  asset.minter = to;
  asset.collection = contractAddress.toHex();

  asset.save();
}
