// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract AccessControl {
    event GrantRole(bytes32 indexed role, address indexed account);
    event RevokeRole(bytes32 indexed role, address indexed account);
    //role => account => bool
    mapping(bytes32 => mapping(address => bool)) public roles;

    bytes32 public constant ADMIN = keccak256(abi.encodePacked("ADMIN"));
    bytes32 public constant USER = keccak256(abi.encodePacked("USER"));

    modifier onlyRole(bytes32 _role) {
        require(roles[_role][msg.sender], "not authorized");
        _;
    }

    constructor() {
        _grantRoles(ADMIN, msg.sender);
    }

    function _grantRoles(bytes32 _role, address _account) internal {
        roles[_role][_account] = true;
        emit GrantRole(_role, _account);
    }

    function grantRoles(bytes32 _role, address _account) onlyRole(ADMIN) external{
         _grantRoles(_role, _account);
    }

    function revokeRoles(bytes32 _role, address _account) onlyRole(ADMIN) external{
        roles[_role][_account] = false;
        emit RevokeRole(_role, _account);
    }

}