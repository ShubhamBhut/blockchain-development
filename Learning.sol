//

//solidity is very similar to python and js
//It is a contract oriented language, quite similar to object oriented. It is also static language means types of all variables must be declared first


//first thing is to define the version of solidity
//It can also be defined in range eg. >=0.6.1 <0.8.0
pragma solidity ^0.6.6; //this indicates use of a specific version of solidity

contract Learning {

    string value;
    
    //the code inside constructor will get executed first
    constructor(address payable _wallet) public {
        value = "Default value";
        state = State.Waiting;
        owner = msg.sender; //the deploying account will be owner, check mapping section down below
        wallet = _wallet; //for dealing with ETH. check that section below
    }

    // the following is function in solidity. public is the visibility status, view is type of action, check docs for more info
    function get() public view returns(string memory){
        return value;
    }

    //following function will set the value of variabe value of datatype string, memory stands for storage type
    function set(string memory _value) public {
        value = _value;
    }

 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   

    //dataypes 
    string public mystring = "this is my string";
    bool public mybool = true;
    int public myint = -1;
    uint256 public myuint = 1; 
    //unit can't have sign means can't be negative

    //enum is enumerated list that is used to keep tracks of things in contract
    enum State { Waiting, Ready, Active} //all 3 are states of contract
    State public state;
    function activate() public {
        state = State.Active;
    }

    //function to check if state is active or not
    function isActive() public view returns(bool) {
        return state == State.Active;
    }

    //structs are custom data structures
    struct Person {
        string _firstName;
        string _lastName;
    }

    Person[] public people; //shows an array names people filled with data structure Person
    
    function addPerson(string memory _firstName, string memory _lastName) public {
        peopleCount +=1;
        people.push(Person(_firstName, _lastName));
    }

//Point to note here is that, unlike python solidity doesn't know the size of dynamic array hence entire array
//can not be accessed, only array members can be accessed by their id (index), quite same to c++

    uint256 public peopleCount;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    //mapping and modifiers
    //mapping is also a data structure but very important here. its like a key,value pair

    uint256 peopleCount2;

    struct Person2 {
        uint id;
        string _firstName;
        string _lastName;
    }

    mapping(uint256 => Person2) public people_mapping;

    //onlyOwner modifier allows only owner address to use function

    address owner; //address is anothr datatype stands for account or wallet address

    //Function Modifiers are used to modify the behaviour of a function. For example to add a prerequisite to a function
    modifier onlyOwner() {
        require(msg.sender == owner);
        _; //consider this something like syntax
    }

    //msg is special global variable which displays metadata of transaction. 
    //There are many other special functions and variables in solidity and I would highly recommend to read about them at -
    //https://docs.soliditylang.org/en/develop/units-and-global-variables.html#special-variables-and-functions

    function addPerson2(string memory _firstName, string memory _lastName) public onlyOwner{

        peopleCount2 += 1;
        people_mapping[peopleCount2] = Person2(peopleCount2, _firstName, _lastName);

    } 

    // To make a timeout in contract, solidity uses epoch time, google if you wanna know more
    uint256 openingTime = 1673834726;

    modifier onlyWhileOpen() {
        require(block.timestamp >= openingTime); //every block has its time in solidity, read more on docs
        _;
    }

 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    //dealing in ETH

    mapping(address => uint256) public balances;
    address payable wallet;

     

    function buyToken() public payable{
        //buy a token
        balances[msg.sender] += 1;
        //send ether to wallet
        wallet.transfer(msg.value);

        emit Purchase(msg.sender, 1);

    }
    //fallback funciton, quite used in ICOs combined with events   
    fallback() external payable{
        buyToken();
    }

    event Purchase(
        address _buyer,
        uint256 _amount
    );
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    // now a basic idea of how ERC20 tokens work

contract ERC20Token {
    string name;
    mapping(address => uint256) public balances;

    function mint() public {
        balances[tx.origin] += 1;
        }
    }

contract MyContract{
    
    address payable wallet2;
    address public token;

    constructor(address payable _wallet2, address _token) public {
        wallet2 = _wallet2;
        token = _token;
    }

    fallback() external payable{
        buyToken2();
    }

    function buyToken2() public payable{
        ERC20Token _token= ERC20Token(address(token));
        _token.mint();
        wallet2.transfer(msg.value);
    }

    //solidity also supports inheritence, but I believe self practice will be best way to learn it
    //so refer the docs and start writing your contracts.
}


