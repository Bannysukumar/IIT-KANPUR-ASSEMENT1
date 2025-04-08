// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PharmaSupplyChain {
    
    enum Role { None, Manufacturer, Distributor, Retailer, Customer }
    enum Status { Created, InTransit, Delivered }

    struct Drug {
        uint256 id;
        string name;
        address currentOwner;
        Status status;
    }

    mapping(address => Role) public roles;
    mapping(uint256 => Drug) public drugs;
    mapping(uint256 => address[]) private drugHistory;

    uint256 public drugCounter;

    event DrugAdded(uint256 drugId, string name, address owner);
    event OwnershipTransferred(uint256 drugId, address from, address to);

    modifier onlyRegistered() {
        require(roles[msg.sender] != Role.None, "Not registered");
        _;
    }

    modifier onlyOwner(uint256 _id) {
        require(drugs[_id].currentOwner == msg.sender, "Not the owner");
        _;
    }

    function registerRole(address _user, Role _role) public {
        roles[_user] = _role;
    }

    function addDrug(string memory _name) public onlyRegistered {
        drugCounter++;
        drugs[drugCounter] = Drug(drugCounter, _name, msg.sender, Status.Created);
        drugHistory[drugCounter].push(msg.sender);
        emit DrugAdded(drugCounter, _name, msg.sender);
    }

    function transferDrug(uint256 _id, address _to) public onlyOwner(_id) onlyRegistered {
        require(roles[_to] != Role.None, "Recipient not registered");
        drugs[_id].currentOwner = _to;
        drugs[_id].status = Status.InTransit;
        drugHistory[_id].push(_to);
        emit OwnershipTransferred(_id, msg.sender, _to);
    }

    function markDelivered(uint256 _id) public onlyOwner(_id) {
        drugs[_id].status = Status.Delivered;
    }

    function getDrugHistory(uint256 _id) public view returns (address[] memory) {
        return drugHistory[_id];
    }
} 