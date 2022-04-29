//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./Voting.sol";


contract ManageVoting {
    Voting voting;
    address public owner;
    string[] public nameElections;
    bool isControlledVoting;

    //sets owner,
    //owner added as a stakeholder
    constructor(address _address) {
        voting = Voting(_address);
        owner = msg.sender;
        staff[owner] = true;

    }

    uint256 private electionsCount = 0;
    //EVENTS
    event CreateElection(address sender, string _electionName);
    event AddCandidate(address sender, string _electionName, string _name);
    event Vote(address sender, string _electionName, uint256 _candidateID);
    event ChangeVoteStatus(address sender, string _electionName);
    event GiveAccessRole(address sender, address _adr);
    //MAPPING
    mapping(address => bool) public stakeholders;
    mapping(string => Voting) public elections;
    mapping(address => bool) public staff;
    mapping(address => bool) public bod;
    mapping(address => bool) public student;



    //MODIFIERS
    modifier onlyChairman() {
        require(msg.sender == owner, "Chairman only access");
        _;
    }
    modifier staffOnly() {
        require(staff[msg.sender], "You are not a staff");
        _;
    }


    // modifier voteEnd(string memory _electionName) {
    //     //check if enum state is == "ongoing"
    //     //ongoing is indexed at 1
    //     require(
    //         uint(elections[_electionName].getVotingStatus()) == 2,
    //         "Election must end"
    //     );
    //     _;
    // }



    //FUNCTIONS
    function transferChairmanRole(address _adr) public onlyChairman {
        owner = _adr;
        emit GiveAccessRole(msg.sender, _adr);
    }

    function giveStaffRole(address _adr) public onlyChairman {
        staff[_adr] = true;
        emit GiveAccessRole(msg.sender, _adr);
    }

    function removeStaffRole(address _adr) public onlyChairman {
        staff[_adr] = false;
        emit GiveAccessRole(msg.sender, _adr);
    }

    function giveBodRole(address _adr) public onlyChairman {
        bod[_adr] = true;
        emit GiveAccessRole(msg.sender, _adr);
    }

    function removeBodRole(address _adr) public onlyChairman {
        bod[_adr] = false;
        emit GiveAccessRole(msg.sender, _adr);
    }

    function giveStudentRole(address _adr) public onlyChairman {
        student[_adr] = true;
        emit GiveAccessRole(msg.sender, _adr);
    }

    function removeStudentRole(address _adr) public onlyChairman {
        student[_adr] = false;
        emit GiveAccessRole(msg.sender, _adr);
    }

    function enableVoting(string memory _electionName) public onlyChairman {
        elections[_electionName].enableVoting();
        emit ChangeVoteStatus(msg.sender, _electionName);
    }

    function disableVoting(string memory _electionName) public onlyChairman {
        elections[_electionName].disableVoting();
        emit ChangeVoteStatus(msg.sender, _electionName);
    }

    function allowResultCompile(string memory _electionName) public onlyChairman {
        elections[_electionName].allowResult();
        emit ChangeVoteStatus(msg.sender, _electionName);
    }

    //add stakeholder
    function setStakeholders(address _adr) public staffOnly returns (bool) {
        emit GiveAccessRole(msg.sender, _adr);
        return stakeholders[_adr] = true;
        
    }

    //get status of an election
    function getElectionStatus(string memory _electionName) 
    public
    view returns(uint) {
        return uint(elections[_electionName].getVotingStatus());
    }

    //Create new instance of the voting contract
    //only chairman can create election
    function createElection(string memory _electionName, string memory category)
        public
        onlyChairman
        returns (bool)
    {
        Voting myVote = new Voting();
        elections[_electionName] = myVote;
        elections[_electionName].setVotingAccess(category);
        //increment the number of elections added
        electionsCount++;
        nameElections.push(_electionName);
        emit CreateElection(msg.sender, _electionName);
        return true;
    }

    //add candidate
    function addCandidate(string memory _electionName, string memory _name, string memory _imgUrl)
        public
        onlyChairman
        returns (bool)
    {
        elections[_electionName].addCandidate(_name, _imgUrl);
        emit AddCandidate(msg.sender, _electionName, _name);
        return true;
    }

    //stakeholders only vote
    function vote(string memory _electionName, uint256 _candidateID)
        public
        returns (bool)
    {
        // require(stakeholders[msg.sender], "You are not a stakeholder");
        elections[_electionName].vote(_candidateID);
        emit Vote(msg.sender, _electionName, _candidateID);
        return true;
    }

    //get list of all election
    function getAllElection() public view returns (string[] memory) {
        return nameElections;
    }

    //get list of all candidate for election name argument
    function getAllCandidate(string memory _electionName)
        public
        view
        returns (string[] memory, uint256[] memory, string[] memory)
    {
        return elections[_electionName].getAllCandidates();
    }

    //get result of an election name argument
    function getResults(string memory _electionName)
        public
        view

        returns (string[] memory, uint256[] memory)
    {
        return elections[_electionName].compileResult();
    }
}
