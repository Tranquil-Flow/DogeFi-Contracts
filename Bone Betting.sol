pragma solidity ^0.5.16;

contract Aion {
    uint256 public serviceFee;
    function ScheduleCall(uint256 blocknumber, address to, uint256 value, uint256 gaslimit, uint256 gasprice, bytes data, bool schedType) public payable returns (uint,address);
}

contract VitaminBetting {

  //--State variables
  IERC20 contractVITA;
  uint rewardPool;
  address owner;
  uint decimals;

struct game {
  uint GameNumber;
  uint StartingTime;
  uint ID;
  uint upVotes;
  uint downVotes;
  address[] upvoters;
  address[] downvoters;
  mapping(address=>bool)hasVoted;
}

uint BetAmount;
uint HouseTaxRate;

mapping  (uint=>game) internal gamesbyID;
mapping (address=>uint)public VITAbalance;
mapping (address=>uint)public GameStartTime;
mapping (uint=>uint) public rewardPoolbyGameID;

constructor (address VITAaddress) public {
    owner = msg.sender;
    decimals = 18;

    contractVITA = IERC20(VITAaddress);
    BetAmount = 100;
    HouseTaxRate = 5;
}

function scheduleendgame() public {
    aion = Aion(0xFcFB45679539667f7ed55FA59A15c8Cad73d9a4E);
    bytes memory data = abi.encodeWithSelector(bytes4(keccak256('endgame()')));
    uint callCost = 200000*1e9 + aion.serviceFee();
    aion.ScheduleCall.value(callCost)( block.timestamp + 2 days, address(this), 0, 200000, 1e9, data, true);
    }

function startnewgame () public onlyOwner {
    game memory regGame;
    regGame.id = gameCounter;
    regGame.startTime = now;
    gamesbyID[gameCounter] = regGame;
    currentgameID = gameCounter;
    gameCounter++;
    scheduleendgame;
}

function GetInfoGameByID (uint256 GameID) public view returns (uint256 ID, uint256 upVotes, uint256 downVotes) {
    game memory getGame = gamesbyID[GameID];
    return (getGame.ID, getGame.upVotes, getGame.downVotes);
}

function GetInfoCurrentGame () public view returns (uint256 ID, uint256 upVotes, uint256 downVotes) {
    game memory getGame = gamesbyID[GetCurrentGameID];
    return (getGame.ID, getGame.upVotes, getGame.downVotes);
}

function GetCurrentGameID () public view returns (uint256 GameID) {
    GameID = gameCounter.sub(1);
}

function upvote() public{
    require (VITAbalance(msg.sender) >= BetAmount);
    GetCurrentGameID = currentID;
    gamesbyID[currentID].upVotes++;
    gamesbyID[currentID].upvoters.push(msg.sender);
    VITAbalance[msg.sender] -= BetAmount;
    dappsById[_id].hasVoted[msg.sender]=true;
 }

 function downvote() public{
    require (VITAbalance(msg.sender) >= BetAmount);
    GetCurrentGameID = currentID;
    gamesbyID[currentID].downVotes++;
    gamesbyID[currentID].downvoters.push(msg.sender);
    VITAbalance[msg.sender] -= BetAmount;
    dappsById[_id].hasVoted[msg.sender]=true;
 }

function changeHouseTaxRate (uint NewHouseTaxRate) public onlyOwner {
    require (NewHouseTaxRate < 100 & NewHouseTaxRate > 0, "House Tax Rate must be between 0 and 100.");
    HouseTaxRate = NewHouseTaxRate;
}

function changeHouseAddress (address NewHouseAddress) public onlyOwner {
    NewHouseAddress = NewHouseAddress;
}

function endgame () public onlyOwner {

    //check Oracle for price to determine winner/loser

    address[] memory winners = gamesbyID[ID].downvoters:gamesbyID[ID].upvoters ;  //EDIT THIS FOR ORACLE WINNER

    HouseTaxAmount = rewardPoolbyGameID[GetCurrentGameID].div(100).mul(HouseTaxRate);
    uint rewardperVoter = (rewardPoolbyGameID[GetCurrentGameID].sub(HouseTaxAmount)).div(winners.length);

    contractVITA.transfer(HouseAddress, HouseTaxAmount);
    for(uint i=0;i<winners.length;i++){
      VITAbalance[winners[i]] += rewardperVoter;
    }

    startnewgame;
}

function () public payable {}

}
