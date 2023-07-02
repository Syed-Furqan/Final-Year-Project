pragma solidity 0.5.16;

contract Contest{
	
	struct Contestant{
		uint id;
		string name;
		uint voteCount;
		string party;
		uint age;
		string qualification;
		string ipfs_hash;
	}

	struct Voter { 
		bool hasVoted;
		uint vote;
		bool isRegistered;
	}

	address admin;
	mapping(uint => Contestant) public contestants; 
   // mapping(address => bool) public voters;
    mapping(address => Voter) public voters;
	uint public contestantsCount;
	string public winner;
	// uint public counter;
	enum PHASE{reg, voting , done}
	PHASE public state;

	modifier onlyAdmin(){
		require(msg.sender==admin);
		_;
	}
	
	modifier validState(PHASE x){
	    require(state==x);
	    _;
	}

	constructor() public{
		admin=msg.sender;
        state=PHASE.reg;
		// counter = 0;
	}

    function changeState(PHASE x) onlyAdmin public{
		require(x > state);
        state = x;
    }

	function addContestant(string memory _name , string memory _party , uint _age , string memory _qualification, string memory _ipfs_hash) public onlyAdmin validState(PHASE.reg){
		contestantsCount++;
		contestants[contestantsCount] = Contestant(contestantsCount,_name,0,_party,_age,_qualification, _ipfs_hash);
	}

	function voterRegistration(address user) public onlyAdmin validState(PHASE.reg){
		voters[user].isRegistered = true;
	}

	function vote(uint _contestantId) public validState(PHASE.voting){
		require(voters[msg.sender].isRegistered);
		require(!voters[msg.sender].hasVoted);
        require(_contestantId > 0 && _contestantId <= contestantsCount);

		contestants[_contestantId].voteCount++;
		voters[msg.sender].hasVoted = true;
		voters[msg.sender].vote = _contestantId;
	}

	function findWinner () public onlyAdmin validState(PHASE.done) {
		uint max_count = 0;
		uint i = 0;

		for(i; i<contestantsCount; i++) {
			if(contestants[i].voteCount > max_count) {
				winner = contestants[i].name;
			}
		}
	}
}