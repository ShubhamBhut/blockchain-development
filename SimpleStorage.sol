pragma solidity >= 0.6.0 < 0.9.0;

contract SimpleStorage{

    uint256 public favouriteNumber;

    struct People {
        uint256 favouriteNumber;
        string name;
    }

    People[] public people;
    mapping(string => uint256) public nameToFavouriteNumber;

    function store(uint256 _favouriteNumber) public returns(uint256) {
        favouriteNumber = _favouriteNumber;
        return favouriteNumber;
    }

    function retrieve() public view returns(uint256) {
        return favouriteNumber;
    }

    function addPeople(string memory _name, uint256 _favouriteNumber) public {
        people.push(People({favouriteNumber: _favouriteNumber, name: _name}));
        nameToFavouriteNumber[_name] = _favouriteNumber;
    }
}