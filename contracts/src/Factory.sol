// SPDX-License-Identifier: UNLINCESED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";

import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Address.sol";

import "./PayableERC721Upgradeable.sol";

contract Factory is Context, ERC165, AccessControlEnumerable {
  bytes32 public constant DEPLOYER_ROLE = keccak256("DEPLOYER_ROLE");
  bytes32 public constant MODERATOR_ROLE = keccak256("MODERATOR_ROLE");

  // upgradeable beacon
  UpgradeableBeacon public upgradeableBeacon;

  address public implementationAddress;

  bool public publicDeployerEnabled;

  event Create721(address proxy, string name, string symbol, string baseURI, uint256 mintPrice, uint256 maxSupply, uint256 launchDate, address payout, address creator);

  constructor() {
    _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    _setupRole(DEPLOYER_ROLE, msg.sender);
    _setupRole(MODERATOR_ROLE, msg.sender);

    implementationAddress = address(new PayableERC721Upgradeable());
    upgradeableBeacon = new UpgradeableBeacon(implementationAddress);
    upgradeableBeacon.transferOwnership(msg.sender);
    publicDeployerEnabled = true;
  }

  function upgrade(address newLogicImpl) public {
    require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "must have admin role to upgrade implementation");
    upgradeableBeacon.upgradeTo(newLogicImpl);
  }

  function deploy721Contract( string calldata _name, string calldata _symbol, string calldata _baseURI, uint256 _mintPrice, uint256 _maxSupply, uint256 _launchDate, address _payout) external returns (address) {
    require(hasRole(DEPLOYER_ROLE, _msgSender()) || publicDeployerEnabled, "must have deployer role to deploy contract");

    BeaconProxy proxy = new BeaconProxy(
      address(upgradeableBeacon),
      abi.encodeWithSelector(
        PayableERC721Upgradeable(address(0x0)).initialize.selector,
        _name,
        _symbol,
        _baseURI,
        _mintPrice,
        _maxSupply,
        _launchDate,
        _payout
      )
    );

    PayableERC721Upgradeable(address(proxy)).transferOwnership(msg.sender);

    emit Create721(address(proxy), _name, _symbol, _baseURI, _mintPrice, _maxSupply, _launchDate, _payout, msg.sender);

    return address(proxy);
  }

  /// @inheritdoc ERC165
  function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC165, AccessControlEnumerable)
    returns (bool)
  {
    return AccessControlEnumerable.supportsInterface(interfaceId);
  }

  function addDeployerRole(address _account) public {
    require(hasRole(MODERATOR_ROLE, _msgSender()), "must have moderator role to add deployer");
    _setupRole(DEPLOYER_ROLE, _account);
  }

  function revokeDeployerRole(address _account) public {
    require(hasRole(MODERATOR_ROLE, _msgSender()), "must have moderator role to remove deployer");
    revokeRole(DEPLOYER_ROLE, _account);
  }

  function addModeratorRole(address _account) public {
    require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "must have admin role to add moderator");
    grantRole(MODERATOR_ROLE, _account);
  }

  function revokeModeratorRole(address _account) public {
    require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "must have admin role to remove moderator");
    revokeRole(MODERATOR_ROLE, _account);
  }

  function enablePublicDeployer() public {
    require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "must have admin role to enable public deployer");

    publicDeployerEnabled = true;
  }

  function disablePublicDeployer() public {
    require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "must have admin role to enable public deployer");
    publicDeployerEnabled = false;
  }

}
